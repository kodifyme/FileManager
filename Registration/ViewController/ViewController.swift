//
//  ViewController.swift
//  Registration
//
//  Created by KOДИ on 14.02.2024.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: - Subviews
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Регистрация"
        label.font = .systemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextField = CustomTextField(placeholder: "Имя")
    private let numberTextField = CustomTextField(placeholder: "Номер телефона")

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

}

//MARK: - Embed Views
private extension RegistrationViewController {
    
    func embedViews() {
        [
            titleLabel,
            nameTextField,
            numberTextField
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
            
        ])
    }
}
