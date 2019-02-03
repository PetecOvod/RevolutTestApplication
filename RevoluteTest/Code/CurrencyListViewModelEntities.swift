//
//  CurrencyListViewModelEntities.swift
//  RevoluteTest
//
//  Created by Yaroslav Minaev on 27/01/2019.
//  Copyright © 2019 Minaev.pro. All rights reserved.
//

struct CurrencyRatesInfo: Codable {
    
    let baseCurrencyName: String
    let rates: [String: Double]
    
    private enum CodingKeys: String, CodingKey {
        case baseCurrencyName = "base"
        case rates
    }
}

enum State {
    case loading, load
}

enum NetworkState {
    case updating, readyToUpdate
}
