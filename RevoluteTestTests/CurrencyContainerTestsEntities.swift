//
//  CurrencyContainerTestsEntities.swift
//  RevoluteTestTests
//
//  Created by Yaroslav Minaev on 03/02/2019.
//  Copyright © 2019 Minaev.pro. All rights reserved.
//

import XCTest
@testable import RevoluteTest

class CurrencyContainerDelegateMock: CurrencyContainerDelegate {
    
    var didUpdate: (() -> Void)?
    var orderDidUpdate: (() -> Void)?
    var baseValueDidUpdate: ((String?) -> Void)?
    
    func currencyContainerDidUpdate() {
        didUpdate?()
    }
    
    func currencyContainerOrderDidUpdate() {
        orderDidUpdate?()
    }
    
    func currencyContainerBaseValueDidUpdate(with value: String?) {
        baseValueDidUpdate?(value)
    }
}
