//
//  NameTextField.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.03.2025.
//

import UIKit

final class NameTextField: UITextField, UITextFieldDelegate{
    
    private let customButton = CustomButton(button: UIImageView(image: Images.doneButton ?? UIImage()), tapped: UIImageView(image: Images.doneButtonTap ?? UIImage()))
    private let toolbar = UIToolbar()
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    var doneButton: UIBarButtonItem = UIBarButtonItem()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureTextField()
    }
    
    private func configureTextField() {
        self.backgroundColor = Colors.lightGray
        self.textAlignment = .center
        self.placeholder = Text.userNamePlaceholder
        self.delegate = self
        self.layer.cornerRadius = Constraints.numberFieldRadius
        self.textColor = Colors.white
        self.font = UIFont(name: Text.fontIrishGrover, size: Constraints.selectorTextSize) ?? UIFont.systemFont(ofSize: Constraints.selectorTextSize)
        
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
    
    @objc 
    private func doneTapped() {
        let currentText = self.text
        if let empty = currentText?.trimmingCharacters(in: .whitespaces).isEmpty {
            self.text = empty ? "" : currentText
        }
        self.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        return newText.count <= Numbers.nameMaxLength
    }
}
