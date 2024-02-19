//
//  CustomTextField.swift
//  Registration
//
//  Created by KOДИ on 14.02.2024.
//

import UIKit

final class CustomTextField: UITextField {
    
    //MARK: - Properties
    var isValid: Bool = false {
        didSet {
            border.backgroundColor = isValid ? .systemGreen : .red
        }
    }
    
    //MARK: - Subviews
    private let border: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Initialization
    init(placeholder: String, keyBoardType: UIKeyboardType) {
        super.init(frame: .zero)
        self.keyboardType = keyBoardType
        self.placeholder = placeholder
        translatesAutoresizingMaskIntoConstraints = false
        
        embeddingViews()
        configureBorderConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    private func embeddingViews() {
        addSubview(border)
    }
    
    func setBorderColor(_ color: UIColor) {
        border.backgroundColor = color
    }
    
    func setTextField(textField: UITextField, validType: String.ValidTypes, validMessage: String, wrongMessage: String, string: String, range: NSRange) {
        let text = (textField.text ?? "") + string
        let result: String
        
        if range.length == 1 {
            let end = text.index(text.startIndex, offsetBy: text.count - 1)
            result = String(text[text.startIndex..<end])
        } else {
            result = text
        }
        
        textField.text = result
        
        isValid = result.isValid(validType: validType)
        
        if isValid {
            print(validMessage)
        } else {
            print(wrongMessage)
        }
    }
}

//MARK: - Configure Border Constraints
private extension CustomTextField {
    func configureBorderConstraints() {
        NSLayoutConstraint.activate([
            border.leadingAnchor.constraint(equalTo: leadingAnchor),
            border.trailingAnchor.constraint(equalTo: trailingAnchor),
            border.bottomAnchor.constraint(equalTo: bottomAnchor),
            border.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
