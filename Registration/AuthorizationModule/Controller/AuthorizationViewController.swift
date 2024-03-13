//
//  AuthorizationViewController.swift
//  Registration
//
//  Created by KOДИ on 19.02.2024.
//

import UIKit

class AuthorizationViewController: UIViewController {
    
    private let authorizationView = AuthorizationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
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
    
    private func setupViews() {
        authorizationView.delegate = self
        view.addSubview(authorizationView)
    }
}

extension AuthorizationViewController: AuthorizationViewDelegate {
    
    func loginButtonTapped(login: String?, password: String?) {
        guard let login = login,
              let password = password,
              let user = UserDefaultsManager.shared.getUser(for: login, password: password) else {
            failedLogin(title: "Неверные данные", message: "")
            return
        }

        FileSystemManager.shared.createDirectory(for: user)
        let fileVC = FileSystemViewController()
        fileVC.setUser(user)
        navigationController?.pushViewController(fileVC, animated: true)
    }
}

//MARK: - Setup Constraints
private extension AuthorizationViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            authorizationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            authorizationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            authorizationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            authorizationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
