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
        
        setupAppearance()
        embeddingViews()
        setupConstraints()
    }
    
    //MARK: - Private Methods
    private func setupAppearance() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
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
        
        let fileSystemVC = FileSystemViewController()
        navigationController?.pushViewController(fileSystemVC, animated: true)
    }
}

//MARK: - Embedding Views
private extension AuthorizationViewController {
    func embeddingViews() {
        
        authorizationStackView = UIStackView(arrangedSubviews: [loginTextField, passwordTextField, loginButton],
                                             axis: .vertical,
                                             spacing: 30)
        
        [authorizationStackView].forEach { view.addSubview($0) }
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
