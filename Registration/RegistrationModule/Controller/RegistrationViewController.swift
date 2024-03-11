//
//  RegistrationViewController.swift
//  Registration
//
//  Created by KOДИ on 14.02.2024.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    // hw
    /* // 2. Capitalization chekhing
       // 9. replacingOccurrences
       // 10. setTextField -> restrict specific symbols
      // 1. stored random text
     */
    
// 3. wrong pass alert +?
    
// 6. cell ordering
    

//    different contents -> different roots by user name
// 11. file/folders user naming
    
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
        registrationView.setBorderColor(.gray)
        registrationView.clearText()
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
        
        let registrationButtonFrame = registrationView.getButtonFrame()
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

