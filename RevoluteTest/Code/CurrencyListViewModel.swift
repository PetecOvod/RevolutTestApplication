//
//  CurrencyListViewModel.swift
//  RevoluteTest
//
//  Created by Yaroslav Minaev on 27/01/2019.
//  Copyright © 2019 Minaev.pro. All rights reserved.
//

import Foundation

class CurrencyListViewModel {
    
    private struct Constants {
        static let endpoint = "https://revolut.duckdns.org/latest?base=EUR"
        static let baseDefaultValue = "100"
    }
    
    // MARK: - Dependencies
    
    private let apiClient = ApiClient()
    private let currencyContainer = CurrencyContainer()
    private let userDefaultsStorage = UserDefaultsStorage.shared
    
    // MARK: - Private properties
    
    private var loadingState: State = .loading
    private var networkState: NetworkState = .readyToUpdate
    private var networkRequestTimer : Timer?
    
    // MARK: - Events
    
    var didChangedState: ((State) -> Void)?
    var didLoadCurrency: (() -> Void)?
    var didUpdateCurrency: (() -> Void)?
    
    // MARK: - Life Cycle
    
    func initialSetup() {
        currencyContainer.delegate = self
    }
    
    func didBindUIWithViewModel() {
        didChangedState?(loadingState)
        startNetworkTimer()
    }
    
    // MARK: - Public
    
    var numberOfRows: Int {
        return currencyContainer.currencies.count
    }
    
    func currency(for indexPath: IndexPath) -> Currency {
        return currencyContainer[indexPath.row]
    }
    
    func moveToTop(currencyWith indexPath: IndexPath) {
        currencyContainer.moveToTop(currencyWith: indexPath.row)
    }
    
    func didChangedBaseCellInputData(with value: String?) {
        currencyContainer.updateBaseValue(with: value)
    }
    
    // MARK: - Private
    
    private func startNetworkTimer() {
        networkRequestTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            [weak self] _ in
            
            self?.requestCurrencyRatesInfo()
        }
    }
    
    private func requestCurrencyRatesInfo() {
        guard networkState == .readyToUpdate else { return }
        networkState = .updating
        let request = URLRequest(url: URL(string: Constants.endpoint)!)
        apiClient.obtainData(for: request) {
            [weak self] (result: Result<CurrencyRatesInfo, Error>) in
            
            guard let sSelf = self else { return }
            switch result {
            case .success(let info):
                if sSelf.currencyContainer.currencies.isEmpty {
                    sSelf.createEmptyCurrencyList(with: info)
                }
                
                sSelf.currencyContainer.updateCurrencyList(with: info)
                
            case .failure:
                //TODO: Handle error
                break
            }
        }
    }
    
    private func createEmptyCurrencyList(with info: CurrencyRatesInfo) {
        if !userDefaultsStorage.currencyOrder.isEmpty {
            currencyContainer.createEmptyCurrencyList(with: userDefaultsStorage.currencyOrder, baseValue: userDefaultsStorage.currencyBaseValue)
        } else {
            currencyContainer.createEmptyCurrencyList(with: info, baseValue: Constants.baseDefaultValue)
        }
    }
}

extension CurrencyListViewModel: CurrencyContainerDelegate {
    
    func currencyContainerOrderDidUpdate() {
        userDefaultsStorage.currencyOrder = currencyContainer.currencies.map({ $0.name })
    }
    
    func currencyContainerBaseValueDidUpdate(with value: String?) {
        userDefaultsStorage.currencyBaseValue = value
    }
    
    func currencyContainerDidUpdate() {
        if loadingState == .loading {
            loadingState = .load
            didChangedState?(loadingState)
            didLoadCurrency?()
        } else {
            didUpdateCurrency?()
        }
        networkState = .readyToUpdate
    }
}
