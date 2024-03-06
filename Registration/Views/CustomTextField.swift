//
//  CustomTextField.swift
//  Registration
//
//  Created by KOДИ on 14.02.2024.
//

import UIKit

final class CustomTextField: UITextField {
    
    //MARK: - Properties
    var isValid: Bool = false
    
    var isSecureText: Bool = false {
        didSet {
            self.isSecureTextEntry = isSecureText
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
        
        setupView()
        configureBorderConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    private func setupView() {
        addSubview(border)
    }
    
    func setBorderColor(_ color: UIColor) {
        border.backgroundColor = color
    }
    
    func setTextField(textField: UITextField, validType: String.ValidTypes, validMessage: String, wrongMessage: String, string: String, range: NSRange) {
        let text = (textField.text ?? "") + string
        let result: String
        
        if range.length == 1 {
            let endIndex = text.index(text.startIndex, offsetBy: text.count - 1) //endIndex
            result = String(text[text.startIndex..<endIndex])
        } else {
            result = text
        }
        
        //text.replacingOccurrences(of: <#T##StringProtocol#>, with: <#T##StringProtocol#>, range: <#T##Range<String.Index>?#>)
        
        textField.text = result
        
        //MARK: - Set border color
        if result.isEmpty {
            border.backgroundColor = .gray
        } else {
            isValid = result.isValid(validType: validType)
            border.backgroundColor = isValid ? .systemGreen : .red
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
