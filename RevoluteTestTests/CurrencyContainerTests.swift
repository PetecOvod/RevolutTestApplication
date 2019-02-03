//
//  RevoluteTestTests.swift
//  CurrencyContainerTests
//
//  Created by Yaroslav Minaev on 27/01/2019.
//  Copyright © 2019 Minaev.pro. All rights reserved.
//

import XCTest
@testable import RevoluteTest

class CurrencyContainerTests: XCTestCase {

    func testCurrencyContainerFillWithList() {
        let currencyContainer = CurrencyContainer()
        
        let currencies = ["USD", "EUR", "RUB"]
        let baseValue = "200"
        
        currencyContainer.createEmptyCurrencyList(with: currencies, baseValue: baseValue)

        XCTAssert(currencyContainer[0].name == currencies[0] , "Wrong first currency name")
        XCTAssert(currencyContainer[0].value == nil, "Wrong first base value")
        XCTAssert(currencyContainer[1].name == currencies[1] , "Wrong second name")
        XCTAssert(currencyContainer[1].value == nil , "Wrong second base value")
    }
    
    func testCurrencyContainerFillWithInfo() {
        let currencyContainer = CurrencyContainer()
        
        let baseCurrencyName = "EUR"
        let info = CurrencyRatesInfo(baseCurrencyName: baseCurrencyName, rates: ["USD": 1.5, "RUB": 2])
        let baseValue = "200"
        
        currencyContainer.createEmptyCurrencyList(with: info, baseValue: baseValue)
        
        XCTAssert(currencyContainer[0].name == baseCurrencyName, "Wrong baseCurrencyName")
        XCTAssert(currencyContainer[0].value == "200", "Wrong baseValue")
        XCTAssert(currencyContainer[1].name == "RUB" , "Wrong second name")
        XCTAssert(currencyContainer[1].value == nil , "Wrong second base value")
        XCTAssert(currencyContainer[2].name == "USD" , "Wrong third name")
        XCTAssert(currencyContainer[2].value == nil , "Wrong third base value")
    }
    
    func testCurrencyContainerUpdate() {
        let currencyContainer = CurrencyContainer()
        let delegate = CurrencyContainerDelegateMock()
        currencyContainer.delegate = delegate
        
        let currencies = ["USD", "EUR", "RUB"]
        let baseValue = "300"
        
        currencyContainer.createEmptyCurrencyList(with: currencies, baseValue: baseValue)

        let info = CurrencyRatesInfo(baseCurrencyName: "EUR", rates: ["USD": 1.5, "RUB": 2])
        
        currencyContainer.updateCurrencyList(with: info)
        
        let update = expectation(description: "Update")
        
        delegate.didUpdate = {
            XCTAssert(currencyContainer[0].name == "USD", "Wrong baseCurrencyName")
            XCTAssert(currencyContainer[0].value == "300", "Wrong baseValue")
            XCTAssert(currencyContainer[1].name == "EUR" , "Wrong second name")
            XCTAssert(currencyContainer[1].value == "200" , "Wrong second base value")
            XCTAssert(currencyContainer[2].name == "RUB" , "Wrong third name")
            XCTAssert(currencyContainer[2].value == "400" , "Wrong third base value")
            update.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testCurrencyContainerUpdateOrder() {
        let currencyContainer = CurrencyContainer()
        let delegate = CurrencyContainerDelegateMock()
        currencyContainer.delegate = delegate
        
        let currencies = ["USD", "EUR", "RUB"]
        let baseValue = "300"
        
        currencyContainer.createEmptyCurrencyList(with: currencies, baseValue: baseValue)
        
        let info = CurrencyRatesInfo(baseCurrencyName: "EUR", rates: ["USD": 1.5, "RUB": 2])
        
        currencyContainer.updateCurrencyList(with: info)
        currencyContainer.moveToTop(currencyWith: 2)
        
        let updateOrder = expectation(description: "UpdateOrder")

        delegate.orderDidUpdate = {
            var newOrder = currencies
            newOrder.insert(newOrder.remove(at: 2), at: 0)
            XCTAssert(currencyContainer.currencies.map({ $0.name }) == newOrder, "Wrong new order")
            updateOrder.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testCurrencyContainerUpdateBaseValue() {
        let currencyContainer = CurrencyContainer()
        let delegate = CurrencyContainerDelegateMock()
        currencyContainer.delegate = delegate
        
        let currencies = ["USD", "EUR", "RUB"]
        let baseValue = "300"
        
        currencyContainer.createEmptyCurrencyList(with: currencies, baseValue: baseValue)
        let info = CurrencyRatesInfo(baseCurrencyName: "EUR", rates: ["USD": 1.5, "RUB": 2])
        
        currencyContainer.updateCurrencyList(with: info)
        currencyContainer.updateBaseValue(with: "600")
        
        let updateBaseValue = expectation(description: "UpdateBaseValue")
        
        delegate.baseValueDidUpdate = {
            value in
            
            XCTAssert(currencyContainer[0].value == "600" , "Wrong third base value")
            updateBaseValue.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
