//
//  FileSystemManager.swift
//  Registration
//
//  Created by KOДИ on 28.02.2024.
//

import Foundation

protocol FileSystemService {
    func createDirectory(at url: URL) throws
    func createDirectory(for user: User) throws
    func showRootDirectoryContents() -> URL?
    func loadContents(inDirectory directory: URL) -> [URL]
    func removeItem(at url: URL) throws
    func loadTextFromFile(at url: URL) -> String?
    func saveTextToFile(text: Data, at url: URL)
    func createFile(atPath: String, contents: Data?)
    func directoryExists(at url: URL) -> Bool
}

class FileManagerAdapter: FileSystemService {
    
    private let fileManager: FileManager
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    func createDirectory(at url: URL) throws {
        let createIntermediates = false
        let attributes: [FileAttributeKey : Any]? = nil
        try fileManager.createDirectory(at: url, withIntermediateDirectories: createIntermediates, attributes: attributes)
    }
    
    func createDirectory(for user: User) throws {
        let documentURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let userDirectoryURL = documentURL.appendingPathComponent(user.userID)
        if !fileManager.fileExists(atPath: userDirectoryURL.path) {
            try fileManager.createDirectory(at: userDirectoryURL, withIntermediateDirectories: true)
        }
    }
    
    func showRootDirectoryContents() -> URL? {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    func loadContents(inDirectory directory: URL) -> [URL] {
        do {
            let contents = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            return contents
        } catch {
            print("Error loading contents: \(error.localizedDescription)")
            return []
        }
    }
    
    func removeItem(at url: URL) throws {
        try fileManager.removeItem(at: url)
    }
    
    func loadTextFromFile(at url: URL) -> String? {
        do {
            let text = try String(contentsOf: url, encoding: .utf8)
            return text
        } catch {
            print("Ошибка при загрузке текста: \(error.localizedDescription)")
            return nil
        }
    }
    
    func saveTextToFile(text: Data, at url: URL) {
        do {
            try text.write(to: url, options: .atomic)
            print("Текст записан")
        } catch {
            print("Ошибка при записи текста: \(error.localizedDescription)")
        }
    }
    
    func createFile(atPath: String, contents: Data?) {
        fileManager.createFile(atPath: atPath, contents: contents)
    }
    
    func directoryExists(at url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        if fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) {
            return isDirectory.boolValue
        } else {
            return false
        }
    }
}

class FileSystemManager {   //FileService
    
    static let shared = FileSystemManager()
    private let fileSystemService: FileSystemService
    
    private init() {
        self.fileSystemService = FileManagerAdapter()
    }
    
    //MARK: - Create Directory
    func createDirectory(at url: URL) throws {
        try fileSystemService.createDirectory(at: url)
    }
    
    func createDirectory(for user: User) throws {
        try fileSystemService.createDirectory(for: user)
    }
    
    func showRootDirectoryContents() -> URL? {
        fileSystemService.showRootDirectoryContents()
    }
    
    //MARK: - Load Contents
    func loadContents(inDirectory directory: URL) -> [URL] {
        fileSystemService.loadContents(inDirectory: directory)
    }
    
    //MARK: - Remove
    func removeItem(at url: URL) throws {
        try fileSystemService.removeItem(at: url)
    }
    
    //MARK: - Load Text From File
    func loadTextFromFile(at url: URL) -> String? {
        fileSystemService.loadTextFromFile(at: url)
    }
    
    //MARK: - Save Text To File
    func saveTextToFile(text: Data, at url: URL) {
        fileSystemService.saveTextToFile(text: text, at: url)
    }
    
    func createFile(atPath: String, contents: Data?) {
        fileSystemService.createFile(atPath: atPath, contents: contents)
    }
    
    func directoryExists(at url: URL) -> Bool {
        fileSystemService.directoryExists(at: url)
    }
//    //MARK: - Unique Name
//    func uniqueName(for baseName: String, in directory: URL) -> String {
//        var name = baseName
//        var count = 1
//        let allFiles = try? FileSystemManager.shared.fileManager.contentsOfDirectory(atPath: directory.path)
//        while allFiles?.contains("\(name)") ?? false {
//            count += 1
//            name = "\(baseName) \(count)"
//        }
//        return name
//    }
}
