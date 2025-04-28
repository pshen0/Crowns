//
//  CustomNumberPicker.swift
//  Crowns
//
//  Created by Анна Сазонова on 21.02.2025.
//

import UIKit

final class CustomNumberPicker: UITextField, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let pickerView = UIPickerView()
    private let toolbar = UIToolbar()
    private let numbers = Array(Constants.queensSizeMin...Constants.queensSizeMax)
    private let customButton = CustomButton(button: UIImageView(image: UIImage.doneButton), tapped: UIImageView(image: UIImage.doneButtonTap))
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    var doneButton: UIBarButtonItem = UIBarButtonItem()
    var selectedNumber: Int? {
        didSet {
            self.text = selectedNumber.map { "\($0)" }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    private func configureUI() {
        self.backgroundColor = Colors.lightGray
        self.textAlignment = .center
        self.layer.cornerRadius = Constants.numberFieldRadius
        self.inputView = pickerView
        self.textColor = Colors.white
        self.tintColor = Colors.white.withAlphaComponent(Constants.numberPickerTintAlpha)
        self.font = UIFont(name: Fonts.IrishGrover, size: Constants.selectorTextSize) ?? UIFont.systemFont(ofSize: Constants.selectorTextSize)
        pickerView.backgroundColor = Colors.lightGray
        pickerView.delegate = self
        pickerView.dataSource = self
        
        toolbar.sizeToFit()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let screenWidth = windowScene.windows.first?.frame.width {
                toolbar.frame.size.width = screenWidth
                self.inputAccessoryView?.frame.size.width = screenWidth
            }
        }
        customButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        doneButton = UIBarButtonItem(customView: customButton)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.barTintColor = Colors.lightGray
        self.inputAccessoryView = toolbar
        toolbar.isTranslucent = false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return Constants.numberPickerComponentsNumber }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numbers[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedNumber = numbers[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = "\(numbers[row])"
        label.textColor = Colors.white
        label.textAlignment = .center
        label.font = UIFont(name: Fonts.IrishGrover, size: Constants.selectorTextSize) ?? UIFont.systemFont(ofSize: Constants.selectorTextSize)
        
        return label
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    override var textInputContextIdentifier: String? { return "" }
    
    @objc private func doneTapped() {
        self.resignFirstResponder()
    }
    
    private enum Constants {
        static let selectorTextSize: CGFloat = 25
        
        static let queensSizeMin: Int = 4
        static let queensSizeMax: Int = 12
        static let numberPickerTintAlpha: Double = 0
        static let numberPickerComponentsNumber: Int = 1
        static let numberFieldRadius = 5.0
    }
}
