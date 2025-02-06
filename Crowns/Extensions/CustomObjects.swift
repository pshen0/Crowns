//
//  CustomObjects.swift
//  Crowns
//
//  Created by Анна Сазонова on 23.01.2025.
//

import UIKit


class CustomButton: UIButton {
    init(button: UIImageView) {
        super.init(frame: .zero)
        if let image = button.image {
            setImage(image, for: .normal)
        }
    }
    
    init(button: UIImageView, tapped: UIImageView) {
        super.init(frame: .zero)
        if let image1 = button.image, let image2 = tapped.image {
            setImage(image1, for: .normal)
            setImage(image2, for: .highlighted)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Text.initErrorCoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}

class CustomText: UILabel {
    
    init(text: String, fontSize: CGFloat, textColor: UIColor = .black) {
        super.init(frame: .zero)
        self.text = text
        self.textColor = textColor
        setupFont(with: fontSize)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFont(with: Constraints.textSize)
        setupUI()
    }
    
    private func setupFont(with size: CGFloat) {
        if let customFont = UIFont(name: Text.fontIrishGrover, size: size) {
            self.font = customFont
        } else {
            self.font = UIFont.systemFont(ofSize: size)
        }
    }

    private func setupUI() {
        self.numberOfLines = 0
        self.textAlignment = .center
    }
}

class BlinkingCatView: UIImageView {
    
    private let animationFrames: [UIImage?]
    
    init(images: [UIImage?], duration: TimeInterval, repeatCount: Int) {
        self.animationFrames = images + images.reversed()
        super.init(frame: .zero)
        setupAnimation(duration: duration, repeatCount: repeatCount)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Text.initErrorCoder)
    }
        
    override init(frame: CGRect) {
        fatalError(Text.initErrorFrame)
    }
    
    private func setupAnimation(duration: TimeInterval, repeatCount: Int) {
        if let image = animationFrames.first {
            self.image = image
        }
        self.animationImages = animationFrames.compactMap { $0 }
        self.animationDuration = duration
        self.animationRepeatCount = repeatCount
    }
    
    func startBlinking() {
        self.startAnimating()
    }
    
    func stopBlinking() {
        self.stopAnimating()
    }
}

class CustomNumberPicker: UITextField, UIPickerViewDelegate, UIPickerViewDataSource {
    
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

class TimePickerTextField: UITextField, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = Colors.lightGray
        self.textAlignment = .center
        self.layer.cornerRadius = Constraints.numberFieldRadius
        self.inputView = timePicker
        self.textColor = Colors.white
        self.tintColor = Colors.white.withAlphaComponent(Numbers.timePickerTintAlpha)
        self.font = UIFont(name: Text.fontIrishGrover, size: Constraints.selectorTextSize) ?? UIFont.systemFont(ofSize: Constraints.selectorTextSize)
        timePicker.backgroundColor = Colors.lightGray
        timePicker.delegate = self
        timePicker.dataSource = self
        toolbar.sizeToFit()
        customButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        doneButton = UIBarButtonItem(customView: customButton)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.barTintColor = Colors.lightGray
        self.inputAccessoryView = toolbar
        toolbar.isTranslucent = false
        self.keyboardType = .numberPad
        
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        self.smartQuotesType = .no
        self.smartDashesType = .no
        self.smartInsertDeleteType = .no
        self.textContentType = .oneTimeCode
        
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
