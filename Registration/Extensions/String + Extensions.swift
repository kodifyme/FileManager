//
//  String + Extensions.swift
//  Registration
//
//  Created by KOДИ on 16.02.2024.
//

import UIKit

extension String {
    
    enum ValidTypes {
        case name
        case phoneNumber
        case password
    }
    
    enum Regex: String {
        case name = "[a-zA-Z]{1,}"
        case phoneNumber = ""
        case password = "d"
    }
    
    func isValid(validType: ValidTypes) -> Bool {
        let format = "SELF MATCHES %@"
        var regex = ""
        
        switch validType {
        case .name:
            regex = Regex.name.rawValue
        case .phoneNumber:
            break
        case .password:
            break
        }
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
}
