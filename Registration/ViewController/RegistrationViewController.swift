//
//  RegistrationViewController.swift
//  Registration
//
//  Created by KOДИ on 14.02.2024.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: - Subviews
    private let titleLabel = UILabel(text: "Регистрация",
                                     font: .systemFont(ofSize: 30))
    
    private let nameTextField = CustomTextField(placeholder: "Имя")
    private let numberTextField = CustomTextField(placeholder: "Номер телефона")
    
    private let ageLabel = UILabel(text: "Возраст:", 
                                   font: .systemFont(ofSize: 18))
    
    private let ageSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.minimumValue = 100
        slider.value = 6
        slider.minimumTrackTintColor = .blue
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
    
    private let noticeLabel = UILabel(text: "Получать уведомление по смс", font: .italicSystemFont(ofSize: 17))
    
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
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        embedViews()
        setupLayout()
    }
    
    // MARK: - Private Methods
    private func setupAppearance() {
        view.backgroundColor = .white
    }
    
    @objc
    private func didTap() {
        print("Oke")
    }
}

//MARK: - Embed Views
private extension RegistrationViewController {
    
    func embedViews() {
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

//MARK: - Setup Layout
private extension RegistrationViewController {
    
    func setupLayout() {
        NSLayoutConstraint.activate([
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
