//
//  CustomTextField.swift
//  Registration
//
//  Created by KOДИ on 14.02.2024.
//

import UIKit

final class CustomTextField: UITextField {
    
    // MARK: - Subviews
    private let border = UIView()
    
    // MARK: - Initialization
    init(placeholder: String) {
        super.init(frame: .zero)
        
        setupAppearance(placeholder: placeholder)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupAppearance(placeholder: String) {
        self.placeholder = placeholder
        translatesAutoresizingMaskIntoConstraints = false
        
        border.backgroundColor = .gray
        border.isUserInteractionEnabled = false
        border.translatesAutoresizingMaskIntoConstraints = false
        addSubview(border)
    }
}

//MARK: - Setup Layout
private extension CustomTextField {
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            border.leadingAnchor.constraint(equalTo: leadingAnchor),
            border.trailingAnchor.constraint(equalTo: trailingAnchor),
            border.bottomAnchor.constraint(equalTo: bottomAnchor),
            border.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
