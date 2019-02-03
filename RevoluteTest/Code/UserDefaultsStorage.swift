//
//  UserDefaultsStorage.swift
//  RevoluteTest
//
//  Created by Yaroslav Minaev on 28/01/2019.
//  Copyright © 2019 Minaev.pro. All rights reserved.
//

import Foundation

class UserDefaultsStorage: NSObject {
    
    // MARK: - Private properties
    
    private let defaults = UserDefaults.standard
    
    private enum UserDefaultsStorageKey: String {
        case currencyOrder, currencyBaseValue
    }
    
    // MARK: - Public properties
    
    static let shared = UserDefaultsStorage()
    
    var currencyBaseValue: String? {
        get {
            return defaults.object(forKey: UserDefaultsStorageKey.currencyBaseValue.rawValue) as! String?
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsStorageKey.currencyBaseValue.rawValue)
        }
    }

    @objc dynamic var currencyOrder: [String] {
        get {
            guard let archivedData = defaults.object(forKey: UserDefaultsStorageKey.currencyOrder.rawValue) as? Data else { return [] }
            guard let data = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archivedData) as? [String] else { return [] }
            
            return data ?? []
        }
        set {
            let archivedData = try? NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false)
            defaults.set(archivedData, forKey: UserDefaultsStorageKey.currencyOrder.rawValue)
        }
    }
}
