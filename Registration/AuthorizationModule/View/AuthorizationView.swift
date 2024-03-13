//
//  AuthorizationView.swift
//  Registration
//
//  Created by KOДИ on 04.03.2024.
//

import UIKit

protocol AuthorizationViewDelegate: AnyObject {
    func loginButtonTapped(login: String?, password: String?)
}

class AuthorizationView: UIView {
    
    weak var delegate: AuthorizationViewDelegate?

    //MARK: - Subviews
    let loginTextField = CustomTextField(placeholder: "Логин", keyBoardType: .default)
    let passwordTextField = CustomTextField(placeholder: "Пароль", keyBoardType: .default)
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAppearance()
        setupViews()
        setupConstraints()
    }
    
    //MARK: - Private Methods
    private func setupAppearance() {
        backgroundColor = .white
        passwordTextField.isSecureText = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc
    private func handleLoginButtonTap() {
        delegate?.loginButtonTapped(login: loginTextField.text, password: passwordTextField.text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setup Views
private extension AuthorizationView {
    func setupViews() {
        authorizationStackView = UIStackView(arrangedSubviews: [loginTextField, passwordTextField, loginButton],
                                             axis: .vertical,
                                             spacing: 30)
        
        addSubview(authorizationStackView)
    }
}

//MARK: - Setup Constraints
private extension AuthorizationView {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            authorizationStackView.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            authorizationStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            authorizationStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
