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
        case phoneNumber = "^\\+7\\d{10}$"
        case password = "(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{6,}"
    }
    
    func isValid(validType: ValidTypes) -> Bool {
        let format = "SELF MATCHES %@"
        var regex = ""
        
        switch validType {
        case .name:
            regex = Regex.name.rawValue
        case .phoneNumber:
            regex = Regex.phoneNumber.rawValue
        case .password:
            regex = Regex.password.rawValue
        }
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
    
    //MARK: - Random Text
    func generateRandomText() -> String {
        let words = ["Lorem", "ipsum", "dolor", "sit", "amet", "consectetur", "adipiscing", "elit"]
        
        var randomText = ""
        for _ in 0..<10 {
            let randomIndex = Int.random(in: 0..<words.count)
            let word = words[randomIndex]
            randomText += word + " "
        }
        return randomText
    }
}
