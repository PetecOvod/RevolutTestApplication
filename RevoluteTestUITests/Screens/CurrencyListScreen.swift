//
//  CurrencyListScreen.swift
//  RevoluteTestUITests
//
//  Created by Yaroslav Minaev on 03/02/2019.
//  Copyright © 2019 Minaev.pro. All rights reserved.
//

import XCTest

class CurrencyListScreen: Screen {
    
    lazy var table = app.tables.element(boundBy: 0)
    
    func currencyName(at index: Int) -> String? {
        
        let cell = table.cells.element(boundBy: index)
        return cell.staticTexts.element(boundBy: 0).value as! String?
    }
}

