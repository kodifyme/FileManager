//
//  RegistrationViewController.swift
//  Registration
//
//  Created by KOДИ on 14.02.2024.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    // hw
    // 1. validation
    // 2. mvc (view (with subviews) in vc)
    
    // q
    // inheritance
    // uiview
    // UIViewController
    
    // MARK: - Subviews
    private let titleLabel = UILabel(text: "Регистрация",
                                     font: .systemFont(ofSize: 30))
    
    private let nameTextField = CustomTextField(placeholder: "Имя", 
                                                keyBoardType: .default)
    private let numberTextField = CustomTextField(placeholder: "Номер телефона", 
                                                  keyBoardType: .numberPad)
    
    private var ageLabel = UILabel()
    
    private lazy var ageSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 6
        slider.maximumValue = 100
        slider.value = 6
        slider.minimumTrackTintColor = .blue
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private let genderSegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Мужской", "Женский", "Другое"])
        segmentControl.selectedSegmentTintColor = .systemBlue
        segmentControl.selectedSegmentIndex = 0
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    }()
    
    private let noticeLabel = UILabel(text: "Получать уведомление по смс", 
                                      font: .italicSystemFont(ofSize: 17))
    
    private let noticeSwitch: UISwitch = {
        let noticeSwitch = UISwitch()
        noticeSwitch.isOn = true
        return noticeSwitch
    }()
    
    private var noticeStackView = UIStackView()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Зарегистрироваться", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 19)
        button.addTarget(self, action: #selector(handleRegistrationButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        embeddingViews()
        setupConstraints()
        setDelegate()
        addTaps()
        registerKeyboardNotification()
    }
    
    // MARK: - Private Methods
    private func setupAppearance() {
        view.backgroundColor = .white
    }
    
    // MARK: - Set Delegate
    private func setDelegate() {
        nameTextField.delegate = self
        numberTextField.delegate = self
    }
    
    @objc
    private func sliderValueChanged() {
        ageLabel.text = "Возраст: \(Int(ageSlider.value))"
    }
    
    @objc
    private func handleRegistrationButtonTap() {
        nameTextField.setBorderColor(nameTextField.text?.isEmpty ?? true ? .red : .gray)
        numberTextField.setBorderColor(numberTextField.text?.isEmpty ?? true ? .red : .gray)
        
        guard let userName = nameTextField.text, !userName.isEmpty,
              let phoneNumber = numberTextField.text, !phoneNumber.isEmpty else {
            return
        }
        
        print("Имя: \(userName), \nНомер телефона: \(phoneNumber), \nВозраст: \(Int(ageSlider.value)), \nПол: \(genderSegmentControl.titleForSegment(at: genderSegmentControl.selectedSegmentIndex) ?? "")")
    }
}

//MARK: - Embedding Views
private extension RegistrationViewController {
    func embeddingViews() {
        ageLabel = UILabel(text: "Возраст: \(Int(ageSlider.value))",
                           font: .systemFont(ofSize: 18))
        
        noticeStackView = UIStackView(arrangedSubviews: [noticeLabel, noticeSwitch],
                                      axis: .horizontal,
                                      spacing: 20)
        [
            titleLabel,
            nameTextField,
            numberTextField,
            ageLabel,
            ageSlider,
            genderSegmentControl,
            noticeStackView,
            registrationButton
        ].forEach { view.addSubview($0) }
    }
}

//MARK: - UITextFieldDelegate
extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        numberTextField.resignFirstResponder()
        return true
    }
}

//MARK: - Scrolling content
private extension RegistrationViewController {
    var originalContentOffset: CGPoint {
        CGPoint(x: 0, y: 0)
    }
    
    func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc
    func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        
        let registrationButtonFrame = registrationButton.frame
        let registrationButtonBottomY = registrationButtonFrame.origin.y + registrationButtonFrame.size.height
        let screenHeight = UIScreen.main.bounds.size.height
        if registrationButtonBottomY > screenHeight - keyboardHeight {
            let contentOffsetY = registrationButtonBottomY - (screenHeight - keyboardHeight)
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -contentOffsetY
            }
        }
    }
    
    @objc
    func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = self.originalContentOffset.y
        }
    }
}

//MARK: - Keyboard Hiding
private extension RegistrationViewController {
    func addTaps() {
        //UITapGestureRecognizer
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        //UISwipeGestureRecognizer
        let swipeScreen = UISwipeGestureRecognizer(target: self, action: #selector(swipeKeyboard))
        swipeScreen.cancelsTouchesInView = false
        swipeScreen.direction = [.left, .right]
        view.addGestureRecognizer(swipeScreen)
    }
    
    @objc
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    func swipeKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - Setup Constraints
private extension RegistrationViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([   //stackview?
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 45),
            
            numberTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 25),
            numberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            numberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            numberTextField.heightAnchor.constraint(equalToConstant: 45),
            
            ageLabel.topAnchor.constraint(equalTo: numberTextField.bottomAnchor, constant: 30),
            ageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            ageSlider.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 15),
            ageSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ageSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            genderSegmentControl.topAnchor.constraint(equalTo: ageSlider.bottomAnchor, constant: 25),
            genderSegmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            genderSegmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            genderSegmentControl.heightAnchor.constraint(equalToConstant: 40),
            
            noticeStackView.topAnchor.constraint(equalTo: genderSegmentControl.bottomAnchor, constant: 30),
            noticeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noticeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            registrationButton.topAnchor.constraint(equalTo: noticeStackView.bottomAnchor, constant: 60),
            registrationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

