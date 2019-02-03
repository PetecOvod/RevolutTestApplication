//
//  XCUIElement+Extensions.swift
//  RevoluteTestUITests
//
//  Created by Yaroslav Minaev on 03/02/2019.
//  Copyright © 2019 Minaev.pro. All rights reserved.
//

import XCTest

extension XCUIElementQuery {
    
    func waitUntil(predicate: NSPredicate, timeout: TimeInterval = UITestsConstants.defaultTimeout) {
        let expectation = XCTNSPredicateExpectation(predicate: predicate,
                                                    object: self)
        XCTWaiter().wait(for: [expectation], timeout: timeout)
    }
}
