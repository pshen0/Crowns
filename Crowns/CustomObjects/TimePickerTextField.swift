//
//  TemePickerTextField.swift
//  Crowns
//
//  Created by Анна Сазонова on 21.02.2025.
//

import UIKit

final class TimePickerTextField: UITextField, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let timePicker: UIPickerView = UIPickerView()
    private let minutesArray: [String] = Array(Numbers.timePickerMin...Numbers.timePickerMax).map { String(format: Numbers.timePickerFormat, $0) }
    private let secondsArray: [String] = Array(Numbers.timePickerMin...Numbers.timePickerMax).map { String(format: Numbers.timePickerFormat, $0) }
    private let customButton = CustomButton(button: UIImageView(image: Images.doneButton), tapped: UIImageView(image: Images.doneButtonTap))
    private let toolbar = UIToolbar()
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    private var selectedMinute: String = Numbers.timePickerStartPosition
    private var selectedSecond: String = Numbers.timePickerStartPosition
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
        self.layer.cornerRadius = Constraints.numberFieldRadius
        self.inputView = timePicker
        self.textColor = Colors.white
        self.tintColor = Colors.white.withAlphaComponent(Numbers.timePickerTintAlpha)
        self.font = UIFont(name: Text.fontIrishGrover, size: Constraints.selectorTextSize) ?? UIFont.systemFont(ofSize: Constraints.selectorTextSize)
        
        customButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        doneButton = UIBarButtonItem(customView: customButton)
        
        timePicker.backgroundColor = Colors.lightGray
        timePicker.delegate = self
        timePicker.dataSource = self
        toolbar.sizeToFit()
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.barTintColor = Colors.lightGray
        self.inputAccessoryView = toolbar
        toolbar.isTranslucent = false
        self.keyboardType = .numberPad
        
        updateTextField()
    }
    
    private func updateTextField() {
        self.text = "\(selectedMinute):\(selectedSecond)"
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Numbers.timePickerComponentsNumber
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return minutesArray.count
        } else {
            return secondsArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = view as? UILabel ?? UILabel()
        
        let text = component == 0 ? minutesArray[row] : secondsArray[row]
        label.text = text
        label.textAlignment = .center
        label.font = UIFont(name: Text.fontIrishGrover, size: Constraints.selectorTextSize) ?? UIFont.systemFont(ofSize: Constraints.selectorTextSize)
        label.textColor = Colors.white
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedMinute = minutesArray[row]
        } else {
            selectedSecond = secondsArray[row]
        }
        updateTextField()
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    override var textInputContextIdentifier: String? {
        return nil
    }
    
    override var hasText: Bool {
        return false
    }
    
    
    @objc private func doneTapped() {
        self.resignFirstResponder()
    }
}
