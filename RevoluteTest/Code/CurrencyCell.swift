//
//  CurrencyCell.swift
//  RevoluteTest
//
//  Created by Yaroslav Minaev on 27/01/2019.
//  Copyright © 2019 Minaev.pro. All rights reserved.
//

import UIKit

struct CurrencyCellModel {
    let name: String
    let value: String?
}

class CurrencyCell: UITableViewCell {

    // MARK: - Private properties
    
    @IBOutlet private weak var currencyTextField: CurrencyTextField!
    @IBOutlet private weak var nameLabel: UILabel!
    
    // MARK: - Public properties
    
    var isBaseCell = true {
        didSet {
            guard isBaseCell != oldValue else { return }
            currencyTextField.isEnabled = isBaseCell
            if isBaseCell {
                currencyTextField.becomeFirstResponder()
            }
        }
    }
    
    var didChangedCellInputData: ((String?) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func config(with model: CurrencyCellModel, isBaseCell: Bool) {
        self.isBaseCell = isBaseCell
        nameLabel.text = model.name
        currencyTextField.text = model.value
        currencyTextField.didUpdateTextField = {
            [unowned self] value in
            
            self.didChangedCellInputData?(value)
        }
    }
}
