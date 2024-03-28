//
//  UserDefaultsManager.swift
//  Registration
//
//  Created by KOДИ on 20.02.2024.
//

import Foundation

struct  UserDefaultsManager {
    
    struct RegistrationResult {
        var success: Bool
        var error: String?
    }
    
    static let shared = UserDefaultsManager()
    
    private init() { }
    
    private let defaults = UserDefaults.standard

    private let isLoggedInKey = "isLoggedIn"
    private let usersKey = "users"
    private let userID = "userID"
    private let usernameKey = "username"
    
    func isLoggedIn() -> Bool {
        defaults.bool(forKey: isLoggedInKey)
    }
    
    func setLoginStatus(isLoggedIn: Bool) {
        defaults.set(isLoggedIn, forKey: isLoggedInKey)
    }
    
    func saveUser(user: User) { //check existing here
        var users = getUsers()
        users.append(user)
        saveUsers(users)
    }
    
    func getUsers() -> [User] {
        if let data = defaults.data(forKey: usersKey),
           let users = try? JSONDecoder().decode([User].self, from: data) {
            return users
        }
        return []
    }
    
    func saveUsers(_ users: [User]) {
        if let data = try? JSONEncoder().encode(users) {
            defaults.set(data, forKey: usersKey)
        }
    }
    
    func userExists(name: String) -> Bool {
        let users = getUsers()
        return users.contains { $0.name == name }
    }
    
    func getUser(for login: String, password: String) -> User? {
        let users = getUsers()
        return users.first { $0.name == login && $0.password == password }
    }
    
    func saveCurrentUsername(_ username: String) {
        defaults.set(username, forKey: usernameKey)
    }
    
    func getUsername() -> String? {
        defaults.string(forKey: usernameKey)
    }
    
    func removeAllUsers() {
        defaults.removeObject(forKey: usersKey)
    }
}

extension UserDefaultsManager {
    
    func registerUser(_ user: User) -> RegistrationResult {
        if userExists(name: user.name) {
            return RegistrationResult(success: false, error: "User already registered")
        } else {
            saveUser(user: user)
            return RegistrationResult(success: true, error: nil)
        }
    }
}
