//
//  CurrencyTextField.swift
//  RevoluteTest
//
//  Created by Yaroslav Minaev on 28/01/2019.
//  Copyright © 2019 Minaev.pro. All rights reserved.
//

import UIKit

class CurrencyTextField: NibControl, UITextFieldDelegate {

    // MARK: - Private properties
    
    private struct Constants {
        static let maximumIntegerDigits = 10
        static let maximumFractionDigits = 2
    }
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var bottomLineView: UIView!
    
    private lazy var regularExpressionString: String = {
        return "^0$|^[1-9]\\d{0,\(Constants.maximumIntegerDigits)}$|^[\\.,]\\d+$|^0[\\.,]\\d{0,\(Constants.maximumFractionDigits)}$|^[1-9]\\d*[\\.,]\\d{0,\(Constants.maximumFractionDigits)}$"
    }()
    
    private let bottomLineActiveColor = UIColor.black
    private let bottomLineInactiveColor = UIColor.black.withAlphaComponent(0.15)
    
    // MARK: - Public properties
    
    var text: String? {
        get { return textField.text }
        set {
            textField.text = newValue
        }
    }
    
    var didUpdateTextField: ((String?) -> Void)?

    override var isEnabled: Bool {
        didSet {
            textField.isEnabled = isEnabled
        }
    }
    override var nibName: String {
        return String(describing: CurrencyTextField.self)
    }
    
    override var canBecomeFirstResponder: Bool {
        return superview != nil
    }
    
    override var isFirstResponder: Bool {
        return textField.isFirstResponder
    }
    
    // MARK: - Life cycle
    
    override func setupUI() {
        super.setupUI()
        textField.text = nil
        textField.placeholder = "0"
        textField.delegate = self
        textField.keyboardType = .decimalPad
        bottomLineView.backgroundColor = bottomLineInactiveColor
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    // MARK: - Private
    
    private func updateUnderline(isActive: Bool) {
        bottomLineView.backgroundColor = isActive ? bottomLineActiveColor : bottomLineInactiveColor
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard textField.keyboardType == .decimalPad else { return false }
        let text = textField.text ?? ""
        guard let swiftRange = range.range(for: text) else { return false }
        let replaceText = text.replacingCharacters(in: swiftRange, with: string)
        guard !replaceText.isEmpty else {
            didUpdateTextField?(nil)
            return true
        }
        let trimmedString = replaceText.components(separatedBy: .whitespaces).joined()
        guard trimmedString.range(of: regularExpressionString, options: .regularExpression) != nil else { return false }
        
        didUpdateTextField?(trimmedString)
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateUnderline(isActive: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let range = textField.text?.suffix(1).rangeOfCharacter(from: CharacterSet(charactersIn: ",.")) {
            textField.text = String(textField.text![..<range.lowerBound])
            didUpdateTextField?(textField.text)
        }
        updateUnderline(isActive: false)
    }
}
