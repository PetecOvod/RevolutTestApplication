//
//  CurrencyContainer.swift
//  RevoluteTest
//
//  Created by Yaroslav Minaev on 27/01/2019.
//  Copyright © 2019 Minaev.pro. All rights reserved.
//

import Foundation

class CurrencyContainer {
    
    weak var delegate: CurrencyContainerDelegate?
    
    // MARK: - Private properties
    
    private let storageQueue = DispatchQueue(label: "com.minaev.CurrencyContainer.storageQueue")
    private let currencyQueue = DispatchQueue(label: "com.minaev.CurrencyContainer.currencyQueue", attributes: .concurrent)
    private var storage = [Currency]()
    private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = " "
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        
        return formatter
    }()
    
    private var baseValue: String? 
    private var baseCurrency: String!
    private var lastRates: CurrencyRatesInfo?
    
    // MARK: - Public properties
    
    var currencies: [Currency] {
        get { return currencyQueue.sync { storage } }
        set { currencyQueue.async(flags: .barrier) { self.storage = newValue } }
    }
    
    // MARK: - Public
    
    subscript(index: Int) -> Currency {
        get {
            return currencies[index]
        }
    }
    
    func createEmptyCurrencyList(with data: [String] , baseValue: String?) {
        storageQueue.sync {
            self.baseValue = baseValue
            self.baseCurrency = data[0]
            let emptyCurrencies = data.map({ Currency(name: $0, value: nil) })
            
            self.currencies = emptyCurrencies
        }
    }
    
    func createEmptyCurrencyList(with info: CurrencyRatesInfo, baseValue: String) {
        storageQueue.sync {
            self.baseValue = baseValue
            self.baseCurrency = info.baseCurrencyName
            let baseCurrency = Currency(name: info.baseCurrencyName, value: baseValue)
            var emptyCurrencies = info.rates.keys.sorted().map({ Currency(name: $0, value: nil) })
            emptyCurrencies.insert(baseCurrency, at: 0)
            
            self.currencies = emptyCurrencies
        }
    }
    
    func updateCurrencyList(with info: CurrencyRatesInfo) {
        storageQueue.async {
            self.updateList(with: info)
            DispatchQueue.main.async {
                self.delegate?.currencyContainerDidUpdate()
            }
        }
    }
    
    func moveToTop(currencyWith index: Int) {
        storageQueue.async {
            var currencies = self.currencies
            currencies.insert(currencies.remove(at: index), at: 0)
            self.baseCurrency = currencies[0].name
            self.baseValue = currencies[0].value
            self.currencies = currencies
            DispatchQueue.main.async {
                self.reportAboutBaseValueUpdate()
                self.delegate?.currencyContainerOrderDidUpdate()
            }
        }
    }
    
    func updateBaseValue(with value: String?) {
        storageQueue.async {
            guard let lastRates = self.lastRates else { return }
            if let value = value {
                var fractionSymbol = ""
                
                if let range = value.suffix(1).rangeOfCharacter(from: CharacterSet(charactersIn: ",.")) {
                    fractionSymbol = String(value[range.lowerBound...])
                }

                guard let valueDouble = self.numberFormatter.number(from: value)?.doubleValue else { fatalError("Can't convert to double") }
                guard let formattedValue = self.numberFormatter.string(from: NSNumber(value: valueDouble)) else { fatalError("Can't convert to string") }
                
                self.baseValue = formattedValue + fractionSymbol
            } else {
                self.baseValue = nil
            }
            
            self.updateList(with: lastRates)
            DispatchQueue.main.async {
                self.reportAboutBaseValueUpdate()
                self.delegate?.currencyContainerDidUpdate()
            }
        }
    }
    
    // MARK: - Private
    
    private func updateList(with info: CurrencyRatesInfo) {
        guard let baseValue = baseValue else {
            let list = currencies.map({ Currency(name: $0.name, value: nil) })
            currencies = list
            
            return
        }
        guard var baseValueDouble = numberFormatter.number(from: baseValue)?.doubleValue else { fatalError("Can't convert to double") }
        
        lastRates = info
        if baseCurrency != info.baseCurrencyName {
            guard let rate = info.rates[baseCurrency] else { fatalError("No such currency") }
            
            baseValueDouble = baseValueDouble / rate
        }
        
        let oldCurrencies = currencies
        
        var newCurrencies: [Currency] = []
        newCurrencies.append(Currency(name: baseCurrency, value: baseValue))
        
        for index in 1..<oldCurrencies.count {
            let oldCurrency = oldCurrencies[index]
            var valueDouble: Double
            
            if let rate = info.rates[oldCurrency.name] {
                valueDouble = baseValueDouble * rate
            } else {
                valueDouble = baseValueDouble
            }
            guard let value = numberFormatter.string(from: NSNumber(value: valueDouble)) else { fatalError("Can't convert to string") }
            
            let currency = Currency(name: oldCurrency.name, value: value)
            
            newCurrencies.append(currency)
        }
        
        currencies = newCurrencies
    }
    
    private func reportAboutBaseValueUpdate() {
        var result = currencies[0].value
        
        if let range = result?.suffix(1).rangeOfCharacter(from: CharacterSet.punctuationCharacters) {
            result = String(result![..<range.lowerBound])
        }
        self.delegate?.currencyContainerBaseValueDidUpdate(with: result)
    }
}
