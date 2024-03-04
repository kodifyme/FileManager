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
    // 2. Capitalized name, hide password, Capitalization
//validation: 8(***)
// 3. wrong pass alert
// 4. nvc, vc builder
// 5. FileManager Manager
    // 6. animation cell updates
    // 7. back button
    // 8. few accounts, different contents
    // 9. replacingOccurrences
    // 10. setTextField -> restrict specific symbols
    
    private let registrationView = RegistrationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        setupViews()
        setupConstraints()
        registerKeyboardNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        registrationView.nameTextField.text = nil
        registrationView.numberTextField.text = nil
        registrationView.passwordTextField.text = nil
        
        registrationView.nameTextField.setBorderColor(.gray)
        registrationView.numberTextField.setBorderColor(.gray)
        registrationView.passwordTextField.setBorderColor(.gray)
    }
    
    //MARK: - Private Methods
    private func setupAppearance() {
        view.backgroundColor = .white
    }
    
    private func setupViews() {
        registrationView.delegate = self
        view.addSubview(registrationView)
    }
}

//MARK: - RegistrationViewDelegate
extension RegistrationViewController: RegistrationViewDelegate {
    func skipButtonTapped() {
        navigationController?.pushViewController(AuthorizationViewController(), animated: true)
        registrationView.endEditing(true)
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
        
        let registrationButtonFrame = registrationView.registrationButton.frame
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

//MARK: - Setup Constraints
private extension RegistrationViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            registrationView.topAnchor.constraint(equalTo: view.topAnchor),
            registrationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            registrationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            registrationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

