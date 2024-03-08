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
    private let usersKey = "users"
    private let userID = "userID"
    
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
    
    func getUserID() -> String? {
        defaults.string(forKey: userID)
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
}
