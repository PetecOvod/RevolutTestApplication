//
//  CurrencyContainerEntities.swift
//  RevoluteTest
//
//  Created by Yaroslav Minaev on 03/02/2019.
//  Copyright © 2019 Minaev.pro. All rights reserved.
//

struct Currency {
    let name: String
    let value: String?
}

protocol CurrencyContainerDelegate: class {
    func currencyContainerDidUpdate()
    func currencyContainerOrderDidUpdate()
    func currencyContainerBaseValueDidUpdate(with value: String?)
}
