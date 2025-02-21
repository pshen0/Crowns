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
    private let numbers = Array(Numbers.queensSizeMin...Numbers.queensSizeMax)
    private let customButton = CustomButton(button: UIImageView(image: Images.doneButton), tapped: UIImageView(image: Images.doneButtonTap))
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
        self.layer.cornerRadius = Constraints.numberFieldRadius
        self.inputView = pickerView
        self.textColor = Colors.white
        self.tintColor = Colors.white.withAlphaComponent(Numbers.numberPickerTintAlpha)
        self.font = UIFont(name: Text.fontIrishGrover, size: Constraints.selectorTextSize) ?? UIFont.systemFont(ofSize: Constraints.selectorTextSize)
        pickerView.backgroundColor = Colors.lightGray
        pickerView.delegate = self
        pickerView.dataSource = self
        toolbar.sizeToFit()
        customButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        doneButton = UIBarButtonItem(customView: customButton)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.barTintColor = Colors.lightGray
        self.inputAccessoryView = toolbar
        toolbar.isTranslucent = false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return Numbers.numberPickerComponentsNumber }
    
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
        label.font = UIFont(name: Text.fontIrishGrover, size: Constraints.selectorTextSize) ?? UIFont.systemFont(ofSize: Constraints.selectorTextSize)
        
        return label
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    override var textInputContextIdentifier: String? { return "" }
    
    @objc private func doneTapped() {
        self.resignFirstResponder()
    }
}
