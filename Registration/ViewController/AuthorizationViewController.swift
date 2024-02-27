//
//  AuthorizationViewController.swift
//  Registration
//
//  Created by KOДИ on 19.02.2024.
//

import UIKit

class AuthorizationViewController: UIViewController {
    
    //MARK: - Subviews
    private let loginTextField = CustomTextField(placeholder: "Логин", keyBoardType: .default)
    private let passwordTextField = CustomTextField(placeholder: "Пароль", keyBoardType: .default)
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вход", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 19)
        button.addTarget(self, action: #selector(handleLoginButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var authorizationStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        embeViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupAppearance()
    }
    
    //MARK: - Private Methods
    private func setupAppearance() {
        view.backgroundColor = .white
        navigationItem.title = "Авторизация"
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc
    private func handleLoginButtonTap() {
        guard let login = loginTextField.text,
              let password = passwordTextField.text,
              UserDefaultsManager.shared.getLogin() == login,
              UserDefaultsManager.shared.getPassword() == password else {
            print("Неверные данные")
            return
        }
        navigationController?.pushViewController(FileSystemViewController(), animated: true)
    }
}

//MARK: - Embedding Views
private extension AuthorizationViewController {
    func embeViews() {
        
        authorizationStackView = UIStackView(arrangedSubviews: [loginTextField, passwordTextField, loginButton],
                                             axis: .vertical,
                                             spacing: 30)
        
        view.addSubview(authorizationStackView)
    }
}

//MARK: - Setup Constraints
private extension AuthorizationViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            authorizationStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            authorizationStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            authorizationStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
