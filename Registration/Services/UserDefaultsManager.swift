//
//  UserDefaultsManager.swift
//  Registration
//
//  Created by KOДИ on 20.02.2024.
//

import Foundation

struct  UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard
    
    func saveLoginCredintails(login: String, password: String) {
        defaults.set(login, forKey: "login")
        defaults.set(password, forKey: "password")
    }
    
    func getLogin() -> String? {
        defaults.string(forKey: "login")
    }
    
    func getPassword() -> String? {
        defaults.string(forKey: "password")
    }
}