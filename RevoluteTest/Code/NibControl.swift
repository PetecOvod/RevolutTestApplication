//
//  NibControl.swift
//  RevoluteTest
//
//  Created by Yaroslav Minaev on 28/01/2019.
//  Copyright © 2019 Minaev.pro. All rights reserved.
//

import UIKit

class NibControl: UIControl {
    
    var contentView: UIView!
    
    var nibName: String {
        return String(describing: type(of: self))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    private func loadViewFromNib() {
        contentView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?[0] as? UIView
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.frame = bounds
        addSubview(contentView)
        setupUI()
    }
    
    func setupUI() {
        // Implement in subclass
    }
}

