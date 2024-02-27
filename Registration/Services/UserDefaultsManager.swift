//
//  UserDefaultsManager.swift
//  Registration
//
//  Created by KOДИ on 20.02.2024.
//

import Foundation

struct  UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    private init() { }  //!
    
    private let defaults = UserDefaults.standard
    
    func saveLoginCredintails(login: String, password: String) {
        defaults.set(login, forKey: "login")    //constants!
        defaults.set(password, forKey: "password")
        defaults.set(true, forKey: "isLoggedIn")
    }
    
    func getLogin() -> String? {
        defaults.string(forKey: "login")
    }
    
    func getPassword() -> String? {
        defaults.string(forKey: "password")
    }
    
    func isLoggedIn() -> Bool {
        defaults.bool(forKey: "isLoggedIn")
    }
    
    func removeLoggedInStatus() {
        defaults.removeObject(forKey: "isLoggedIn")
    }
}
