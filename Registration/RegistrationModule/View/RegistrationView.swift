//
//  RegistrationView.swift
//  Registration
//
//  Created by KOДИ on 29.02.2024.
//

import UIKit

protocol RegistrationViewDelegate: AnyObject {
    func skipButtonTapped()
}

class RegistrationView: UIView {
    
    weak var delegate: RegistrationViewDelegate?
    
    public var user: User? {
        guard let name = nameTextField.text,
              let phoneNumber = numberTextField.text,
              let password = passwordTextField.text else { return nil }
        return User(name: name, phoneNumber: phoneNumber, password: password)
    }
    
    //MARK: - Subviews
    private let titleLabel = UILabel(text: "Регистрация",
                                     font: .systemFont(ofSize: 30))
    
    let nameTextField = CustomTextField(placeholder: "Имя",
                                        keyBoardType: .default)
    let numberTextField = CustomTextField(placeholder: "Номер телефона",
                                          keyBoardType: .phonePad)
    let passwordTextField = CustomTextField(placeholder: "Пароль",
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
    
    lazy var registrationButton: UIButton = {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAppearance()
        setupViews()
        setDelegate()
        setupConstraints()
        setupKeyboardDismissalGestures()
    }
    
    //MARK: - Private Methods
    private func setupAppearance() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
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
        
        guard let user = user,
              user.name.isValid(validType: .name),
              user.phoneNumber.isValid(validType: .phoneNumber),
              user.password.isValid(validType: .password) else {
            return
        }
        
        UserDefaultsManager.shared.saveLoginCredintails(login: user.name, password: user.password)    //+-
        
        handleSkipButtonTap()
        
        print("Имя: \(user.name),\nПароль: \(user.password) \nНомер телефона: \(user.phoneNumber)")
    }
    
    @objc
    private func handleSkipButtonTap() {
        delegate?.skipButtonTapped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setup Views
private extension RegistrationView {
    func setupViews() {
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
        ].forEach { addSubview($0) }
    }
}

//MARK: - UITextFieldDelegate
extension RegistrationView: UITextFieldDelegate {
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

private extension RegistrationView {
    func setupKeyboardDismissalGestures() {
        //UITapGestureRecognizer
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        //UISwipeGestureRecognizer  //+--
        let swipeScreen = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
        swipeScreen.cancelsTouchesInView = false
        swipeScreen.direction = [.left, .right]
        addGestureRecognizer(swipeScreen)
    }
    
    @objc
    func hideKeyboard() {
        endEditing(true)
    }
}

//MARK: - Setup Constraints
private extension RegistrationView {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            
            screenObjectsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            screenObjectsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            screenObjectsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            registrationButton.topAnchor.constraint(equalTo: screenObjectsStackView.bottomAnchor, constant: 40),
            registrationButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            skipButton.topAnchor.constraint(equalTo: registrationButton.bottomAnchor, constant: 30),
            skipButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}