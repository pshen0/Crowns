//
//  NameTextField.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.03.2025.
//

import UIKit

// MARK: - NameTextField class
final class NameTextField: UITextField {
    
    // MARK: - Properties
    private let customButton = CustomButton(button: UIImageView(image: UIImage.doneButton), tapped: UIImageView(image: UIImage.doneButtonTap))
    private let toolbar = UIToolbar()
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    var doneButton: UIBarButtonItem = UIBarButtonItem()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureTextField()
    }
    
    // MARK: - Private funcs
    private func configureTextField() {
        self.backgroundColor = Colors.lightGray
        self.textAlignment = .center
        self.placeholder = Constants.userNamePlaceholder
        self.delegate = self
        self.layer.cornerRadius = Constants.numberFieldRadius
        self.textColor = Colors.white
        self.tintColor = .clear
        self.font = UIFont(name: Fonts.IrishGrover, size: Constants.selectorTextSize) ?? UIFont.systemFont(ofSize: Constants.selectorTextSize)
        
        customButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        
        doneButton = UIBarButtonItem(customView: customButton)
        toolbar.sizeToFit()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let screenWidth = windowScene.windows.first?.frame.width {
                toolbar.frame.size.width = screenWidth
                self.inputAccessoryView?.frame.size.width = screenWidth
            }
        }
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.barTintColor = Colors.lightGray
        self.inputAccessoryView = toolbar
        toolbar.isTranslucent = false
        self.keyboardType = .asciiCapable
    }
    
    // MARK: - Actions
    @objc private func doneTapped() {
        let currentText = self.text
        if let empty = currentText?.trimmingCharacters(in: .whitespaces).isEmpty {
            self.text = empty ? "" : currentText
        }
        self.resignFirstResponder()
    }
    
    // MARK: - Constants
    private enum Constants {
        static let userNamePlaceholder: String = "User name"
        
        static let selectorTextSize: CGFloat = 25
        
        static let numberFieldRadius: CGFloat = 10
        static let nameMaxLength: Int = 12
    }
}

// MARK: - Extension
extension NameTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        return newText.count <= Constants.nameMaxLength
    }
}
