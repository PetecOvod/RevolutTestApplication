//
//  UIKit+Extension.swift
//  RevoluteTest
//
//  Created by Yaroslav Minaev on 27/01/2019.
//  Copyright © 2019 Minaev.pro. All rights reserved.
//

import Foundation

import UIKit

extension UINib {
    
    public convenience init?(safeWithName name: String, bundle: Bundle = .main) {
        guard bundle.path(forResource: name, ofType: "nib") != nil else {
            return nil
        }
        
        self.init(nibName: name, bundle: bundle)
    }
}

extension UITableView {
    
    public func sw_register<Cell: UITableViewCell>(cellType: Cell.Type, bundle: Bundle = .main, tryNib: Bool = true) {
        let reuseIdentifier = String(describing: cellType)
        
        if tryNib, let nib = UINib(safeWithName: reuseIdentifier, bundle: bundle) {
            register(nib, forCellReuseIdentifier: reuseIdentifier)
        } else {
            register(cellType, forCellReuseIdentifier: reuseIdentifier)
        }
    }
    
    public func sw_dequeueCell<Cell: UITableViewCell>(of cellType: Cell.Type, for indexPath: IndexPath) -> Cell {
        return dequeueReusableCell(withIdentifier: String(describing: cellType), for: indexPath) as! Cell
    }
    
    public func sw_register<HeaderFooter: UITableViewHeaderFooterView>(headerFooterType: HeaderFooter.Type, bundle: Bundle = .main, tryNib: Bool = true) {
        let identifier = String(describing: headerFooterType)
        
        if tryNib, let nib = UINib(safeWithName: identifier, bundle: bundle) {
            register(nib, forHeaderFooterViewReuseIdentifier: identifier)
        } else {
            register(headerFooterType, forHeaderFooterViewReuseIdentifier: identifier)
        }
    }
    
    public func sw_dequeueHeaderFooter<HeaderFooter: UITableViewHeaderFooterView>(of viewType: HeaderFooter.Type) -> HeaderFooter {
        return dequeueReusableHeaderFooterView(withIdentifier: String(describing: viewType)) as! HeaderFooter
    }
}

extension UIViewController {
    
    var sw_typeNameWithoutGeneric: String? {
        let fullName = String(describing: type(of: self))
        if let charIndex = fullName.index(of: "<") {
            let nameWithoutGeneric = String(fullName[..<charIndex])
            return nameWithoutGeneric
        }
        return fullName
    }
}
