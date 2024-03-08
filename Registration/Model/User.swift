//
//  User.swift
//  Registration
//
//  Created by KOДИ on 01.03.2024.
//

import UIKit

struct User: Codable, Equatable {
    let name: String
    let phoneNumber: String
    let password: String
    let userID: String
    
    static func ==(lhs: User, rhs: User) -> Bool {
        lhs.name == rhs.name && lhs.password == rhs.password
    }
}
