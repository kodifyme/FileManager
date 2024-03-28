//
//  CustomTextField.swift
//  Registration
//
//  Created by KOДИ on 14.02.2024.
//

import UIKit

protocol TextFieldDelegate: AnyObject {
    func setText(to text: String?)
    func setBorderColor(_ color: UIColor)
}

final class CustomTextField: UITextField {
    
    //MARK: - Properties
    var isValid: Bool = false
    
    var isSecureText: Bool = false {
        didSet {
            self.isSecureTextEntry = isSecureText
        }
    }
    
    //MARK: - Subviews
    let border: UIView = {
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
    
    
    func setTextField(textField: UITextField, validType: String.ValidTypes, validMessage: String, wrongMessage: String, string: String, range: NSRange) {
        let text = (textField.text ?? "") + string
        var result = text
        
        // Not Allowed Characters
//        let notAllowedCharacters = CharacterSet(charactersIn: "!@#$%^&*()_-+=|")
//        for char in string.unicodeScalars {
//            if notAllowedCharacters.contains(char) {
//                return
//            }
//        }
        
        // use for shorting code / refactoring
//        let allowedCharacters = CharacterSet.letters
//        return result.rangeOfCharacter(from: allowedCharacters.inverted) == nil

        if range.length == 1 {
            let endIndex = text.index(text.startIndex, offsetBy: text.count - 1) //endIndex
            result = String(text[text.startIndex..<endIndex])
        } else {
            result = text
        }
        
        //First Index is uppercased
        if let firstChar = result.first, firstChar.isLowercase {
            let uppercaseFirstChar = String(firstChar).uppercased()
            result = uppercaseFirstChar + String(result.dropLast())
        }
        
        
        //text.replacingOccurrences(of: <#T##StringProtocol#>, with: <#T##StringProtocol#>, range: <#T##Range<String.Index>?#>) //use for code shorting (refactoring)
        
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

//MARK: - TextFieldDataSource
extension CustomTextField: TextFieldDelegate {
    
    func setText(to text: String?) {
        self.text = text
    }
    
    func setBorderColor(_ color: UIColor) {
        border.backgroundColor = color
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
