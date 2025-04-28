//
//  TemePickerTextField.swift
//  Crowns
//
//  Created by Анна Сазонова on 21.02.2025.
//

import UIKit

final class TimePickerTextField: UITextField, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let timePicker: UIPickerView = UIPickerView()
    private let minutesArray: [String] = Array((Constants.timePickerMin + 1)...Constants.timePickerMax).map { String(format: Constants.timePickerFormat, $0) }
    private let secondsArray: [String] = Array(Constants.timePickerMin...Constants.timePickerMax).map { String(format: Constants.timePickerFormat, $0) }
    private let customButton = CustomButton(button: UIImageView(image: UIImage.doneButton), tapped: UIImageView(image: UIImage.doneButtonTap))
    private let toolbar = UIToolbar()
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    private var selectedMinute: String = Constants.timePickerStartMinPosition
    private var selectedSecond: String = Constants.timePickerStartSecPosition
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
        self.layer.cornerRadius = Constants.numberFieldRadius
        self.inputView = timePicker
        self.textColor = Colors.white
        self.tintColor = Colors.white.withAlphaComponent(Constants.numberPickerTintAlpha)
        self.font = UIFont(name: Fonts.IrishGrover, size: Constants.selectorTextSize) ?? UIFont.systemFont(ofSize: Constants.selectorTextSize)
        
        customButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        doneButton = UIBarButtonItem(customView: customButton)
        
        timePicker.backgroundColor = Colors.lightGray
        timePicker.delegate = self
        timePicker.dataSource = self
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
        self.keyboardType = .numberPad
        
        updateTextField()
    }
    
    private func updateTextField() {
        self.text = "\(selectedMinute):\(selectedSecond)"
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Constants.timePickerComponentsNumber
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
        label.font = UIFont(name: Fonts.IrishGrover, size: Constants.selectorTextSize) ?? UIFont.systemFont(ofSize: Constants.selectorTextSize)
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
    
    private enum Constants {
        static let selectorTextSize: CGFloat = 25
        
        static let timePickerStartSecPosition: String = "00"
        static let timePickerStartMinPosition: String = "01"
        static let timePickerMin: Int = 0
        static let timePickerMax: Int = 59
        static let timePickerFormat: String = "%02d"
        static let timePickerTintAlpha: Double = 0
        static let timePickerComponentsNumber: Int = 2
        static let numberFieldRadius = 10.0

        static let numberPickerTintAlpha: Double = 0
        static let numberPickerComponentsNumber: Int = 1
    }
}
