//
//  UserDefaultsManager.swift
//  Registration
//
//  Created by KOДИ on 20.02.2024.
//

import Foundation

struct  UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private init() { }
    
    private let defaults = UserDefaults.standard
    
    private let loginKey = "login"
    private let passwordKey = "password"
    private let isLoggedInKey = "isLoggedIn"
    
    func saveLoginCredintails(login: String, password: String) {
        defaults.set(login, forKey: loginKey)
        defaults.set(password, forKey: passwordKey)
        defaults.set(true, forKey: isLoggedInKey)
    }
    
    func getLogin() -> String? {
        defaults.string(forKey: loginKey)
    }
    
    func getPassword() -> String? {
        defaults.string(forKey: passwordKey)
    }
    
    func isLoggedIn() -> Bool {
        defaults.bool(forKey: isLoggedInKey)
    }
    
    func removeLoggedInStatus() {
        defaults.removeObject(forKey: isLoggedInKey)
    }
}
