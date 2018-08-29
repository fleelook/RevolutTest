//
//  CurrencyCell.swift
//  RevolutTest
//
//  Created by Daniil Smirnov on 28/08/2018.
//  Copyright © 2018 Daniil Smirnov. All rights reserved.
//

import UIKit
import Kingfisher


class CurrencyCell: UICollectionViewCell, UITextFieldDelegate {
    
    var inputDidChange: ((_ input: Double) -> Void)?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        inputTextField.isUserInteractionEnabled = false
    }
    
    func configure(with item: CurrencyItem, imageUrl: URL?) {
        self.inputDidChange = item.didInput
        self.codeLabel.text = item.currency.code
        self.nameLabel.text = item.currency.code

        if item.currency.code == "EUR" {
            print(item.value)
            print("\(item.value)")
        }
        
        inputTextField.text = "\(item.value)".split(separator: ".").joined(separator: ",")
        
        inputTextField.delegate = self
        inputTextField.isUserInteractionEnabled = false
        inputTextField.keyboardType = .decimalPad
        inputTextField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
        
        if let url = imageUrl {
            setImage(with: url)
        }
    }
    
    func setImage(with url: URL?) {
        imageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    func setFirstResponder(_ shouldSetFirstResponder: Bool) {
        inputTextField.isUserInteractionEnabled = true
        if shouldSetFirstResponder {
            inputTextField.becomeFirstResponder()
        } else {
            inputTextField.resignFirstResponder()
        }
    }
    
    func getInputValue() -> Double? {
        guard let text = inputTextField?.text else {
            return nil
        }
        
        return text.doubleValue
    }
    
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty || text.doubleValue == nil {
            textField.text = "0,0"
        }
    }
    
    
    // MARK: cell height
    
    static let cellHeight: CGFloat = 80.0

    
    // MARK: fileprivate
    
    @objc fileprivate dynamic func textFieldDidChange() {
        guard
            let text = inputTextField.text,
            let value = text.doubleValue else {
                inputDidChange?(0)
                return
        }
        
        inputDidChange?(value)
    }

    @IBOutlet fileprivate weak var codeLabel: UILabel!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var inputTextField: UITextField!
}
