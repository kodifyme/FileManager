//
//  RegistrationViewController.swift
//  Registration
//
//  Created by KOДИ on 14.02.2024.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    // hw
    // 1. mvc (view (with subviews) in vc)
    // 2. validation: 8(***), Capitalized name, hide password, Capitalization
// 3. wrong pass alert
    // 4. nvc, vc builder
    // 5. FileManager Manager
    // 6. animation cell updates
    // 7. back button
    // 8. few accounts, different contents
    // 9. replacingOccurrences
    // 10. setTextField -> restrict specific symbols
    
    //MARK: - Subviews
    private let titleLabel = UILabel(text: "Регистрация",
                                     font: .systemFont(ofSize: 30))
    
    private let nameTextField = CustomTextField(placeholder: "Имя",
                                                keyBoardType: .default)
    private let numberTextField = CustomTextField(placeholder: "Номер телефона в формате +7",
                                                  keyBoardType: .phonePad)
    private let passwordTextField = CustomTextField(placeholder: "Пароль",
                                                    keyBoardType: .default)
    
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
    
    private var screenObjectsStackView = UIStackView()
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
    
    private lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Пропустить", for: .normal)
        button.setTitleColor(.systemBlue, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 19)
        button.configuration = .plain()
        button.addTarget(self, action: #selector(handleSkipButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        embeViews()
        setupConstraints()
        setDelegate()
        setupKeyboardDismissalGestures()
        registerKeyboardNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        nameTextField.text = nil
        numberTextField.text = nil
        passwordTextField.text = nil
        
        nameTextField.setBorderColor(.gray)
        numberTextField.setBorderColor(.gray)
        passwordTextField.setBorderColor(.gray)
    }
    
    //MARK: - Private Methods
    private func setupAppearance() {
        view.backgroundColor = .white
    }
    
    //MARK: - Set Delegate
    private func setDelegate() {
        nameTextField.delegate = self
        numberTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @objc
    private func sliderValueChanged() {
        ageLabel.text = "Возраст: \(Int(ageSlider.value))"
    }
    
    @objc
    private func handleRegistrationButtonTap() {
        // ->r
        nameTextField.setBorderColor(nameTextField.isValid ? .systemGreen : .red)
        numberTextField.setBorderColor(numberTextField.isValid ? .systemGreen : .red)
        passwordTextField.setBorderColor(passwordTextField.isValid ? .systemGreen : .red)
        
        guard let userName = nameTextField.text,
              let phoneNumber = numberTextField.text,
              let userPassword = passwordTextField.text,
              !userName.isEmpty, !phoneNumber.isEmpty, !userPassword.isEmpty,   //?
              userName.isValid(validType: .name),
              phoneNumber.isValid(validType: .phoneNumber),
              userPassword.isValid(validType: .password) else {
            return
        }
        
        UserDefaultsManager.shared.saveLoginCredintails(login: userName, password: userPassword)    //+-
        
        handleSkipButtonTap()
        
        print("Имя: \(userName), \nНомер телефона: \(phoneNumber), \nВозраст: \(Int(ageSlider.value)), \nПол: \(genderSegmentControl.titleForSegment(at: genderSegmentControl.selectedSegmentIndex) ?? "")")
    }
    
    @objc
    private func handleSkipButtonTap() {
        navigationController?.pushViewController(AuthorizationViewController(), animated: true)
        view.endEditing(true)
    }
}

//MARK: - Embedding Views
private extension RegistrationViewController {
    func embeViews() {
        ageLabel = UILabel(text: "Возраст: \(Int(ageSlider.value))",
                           font: .systemFont(ofSize: 18))
        
        noticeStackView = UIStackView(arrangedSubviews: [noticeLabel, noticeSwitch],
                                      axis: .horizontal,
                                      spacing: 20)
        
        screenObjectsStackView = UIStackView(arrangedSubviews: [nameTextField,
                                                                numberTextField,
                                                                passwordTextField,
                                                                ageLabel,
                                                                ageSlider,
                                                                genderSegmentControl,
                                                                noticeStackView],
                                             axis: .vertical,
                                             spacing: 30)
        
        [titleLabel,
         screenObjectsStackView,
         registrationButton,
         skipButton
        ].forEach { view.addSubview($0) }
    }
}

//MARK: - UITextFieldDelegate
extension RegistrationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case nameTextField:
            nameTextField.setTextField(textField: nameTextField,
                                       validType: .name,
                                       validMessage: "Name is valid",
                                       wrongMessage: "Only A-Z characters annd min 1 character",
                                       string: string,
                                       range: range)
            
        case numberTextField:
            numberTextField.setTextField(textField: numberTextField,
                                         validType: .phoneNumber,
                                         validMessage: "Phone is valid",
                                         wrongMessage: "-",
                                         string: string,
                                         range: range)
            
        case passwordTextField:
            passwordTextField.setTextField(textField: passwordTextField,
                                           validType: .password,
                                           validMessage: "Password is valid",
                                           wrongMessage: "Password is not valid",
                                           string: string,
                                           range: range)
        default:
            break
        }
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        numberTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
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
    func setupKeyboardDismissalGestures() {
        //UITapGestureRecognizer
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        //UISwipeGestureRecognizer  //+--
        let swipeScreen = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
        swipeScreen.cancelsTouchesInView = false
        swipeScreen.direction = [.left, .right]
        view.addGestureRecognizer(swipeScreen)
    }
    
    @objc
    func hideKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - Setup Constraints
private extension RegistrationViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            screenObjectsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            screenObjectsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            screenObjectsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            registrationButton.topAnchor.constraint(equalTo: screenObjectsStackView.bottomAnchor, constant: 40),
            registrationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            skipButton.topAnchor.constraint(equalTo: registrationButton.bottomAnchor, constant: 30),
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

