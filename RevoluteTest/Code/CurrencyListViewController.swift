//
//  CurrencyListViewController.swift
//  RevoluteTest
//
//  Created by Yaroslav Minaev on 27/01/2019.
//  Copyright © 2019 Minaev.pro. All rights reserved.
//

import UIKit

class CurrencyListViewController<ViewModelType: CurrencyListViewModel>: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    // MARK: - Private properties
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Public properties
    
    override var nibName: String? {
        return sw_typeNameWithoutGeneric
    }
    var viewModel: CurrencyListViewModel
    
    // MARK: - Initialization
    
    init(viewModel: CurrencyListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    func initialSetup() {
        viewModel.initialSetup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUIWithViewModel()
        viewModel.didBindUIWithViewModel()
    }

    func setupUI() {
        tableView.separatorStyle = .none
        tableView.sw_register(cellType: CurrencyCell.self)
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.rowHeight = 60
        tableView.keyboardDismissMode = .onDrag
        tableView.refreshControl = UIRefreshControl()
    }
    
    func bindUIWithViewModel() {
        viewModel.didChangedState = {
            [weak self] state in
            
            guard let sSelf = self else { return }
            switch state {
            case .loading:
                sSelf.tableView.refreshControl?.beginRefreshing()
            case .load:
                sSelf.tableView.refreshControl?.endRefreshing()
            }
        }
        
        viewModel.didLoadCurrency = {
            [weak self] in
            
            self?.tableView.reloadData()
        }
        
        viewModel.didUpdateCurrency = {
            [weak self] in
            
            guard let sSelf = self else { return }
            
            let indexPathsForVisibleRows = sSelf.tableView.indexPathsForVisibleRows ?? []
            
            for indexPath in indexPathsForVisibleRows {
                guard let cell = sSelf.tableView.cellForRow(at: indexPath) as? CurrencyCell else { return }
                let model = sSelf.viewModel.currency(for: indexPath)
                let cellModel = CurrencyCellModel(name: model.name, value: model.value)
                cell.config(with: cellModel, isBaseCell: cell.isBaseCell)
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.sw_dequeueCell(of: CurrencyCell.self, for: indexPath)
        
        let model = viewModel.currency(for: indexPath)
        let cellModel = CurrencyCellModel(name: model.name, value: model.value)
        
        cell.config(with: cellModel, isBaseCell: indexPath.row == 0)
        cell.didChangedCellInputData = {
            [unowned self] text in
            
            self.viewModel.didChangedBaseCellInputData(with: text)
        }
        
        return cell
    }
    
    // MARK: - Private
    
    private func moveToTop(currencyWith indexPath: IndexPath) {
        let topIndexPath = IndexPath(row: 0, section: 0)
        
        guard indexPath != topIndexPath else { return }
        
        
        tableView.beginUpdates()
        
        
        if let topCell = tableView.cellForRow(at: topIndexPath) as? CurrencyCell {
            topCell.isBaseCell = false
        }
        let newTopCell = tableView.cellForRow(at: indexPath) as! CurrencyCell
        newTopCell.isBaseCell = true
        tableView.moveRow(at: indexPath, to: topIndexPath)
        viewModel.moveToTop(currencyWith: indexPath)
        
        tableView.endUpdates()
        tableView.scrollToRow(at: topIndexPath, at: .top, animated: true)
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        moveToTop(currencyWith: indexPath)
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
}
