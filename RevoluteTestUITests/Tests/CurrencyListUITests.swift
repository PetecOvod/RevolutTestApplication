//
//  CurrencyListUITests.swift
//  CurrencyListUITests
//
//  Created by Yaroslav Minaev on 03/02/2019.
//  Copyright © 2019 Minaev.pro. All rights reserved.
//

import XCTest

class CurrencyListUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()

        sleep(1)
    }

    func testCurrencyListMoveToTop() {
        let screen = CurrencyListScreen()
        let predicate = NSPredicate(format: "count > 0")
        screen.table.cells.waitUntil(predicate: predicate, timeout: UITestsConstants.defaultTimeout)
        
        let firstCellCurrencyName = screen.currencyName(at: 0)
        
        let index = Int.random(in: 2..<6)
        let previousIndex = index - 1
        
        let targetCellCurrencyName = screen.currencyName(at: index)
        let chekingCellCurrencyName = screen.currencyName(at: previousIndex)
        
        screen.table.cells.element(boundBy: index).tap()
        sleep(1)
        
        XCTAssert(screen.currencyName(at: 0) == targetCellCurrencyName, "Move action failed")
        XCTAssert(screen.currencyName(at: 1) == firstCellCurrencyName, "Move action failed")
        XCTAssert(screen.currencyName(at: index) == chekingCellCurrencyName, "Move action failed")
    }
}
