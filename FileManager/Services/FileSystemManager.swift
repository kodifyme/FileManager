//
//  FileSystemManager.swift
//  Registration
//
//  Created by KOДИ on 28.02.2024.
//

import Foundation

protocol FileSystemService {
    func createDirectory(at url: URL) throws
    func loadContents(inDirectory directory: URL) -> [URL]
    func removeItem(at url: URL) throws
    func loadTextFromFile(at url: URL) -> String?
    func saveTextToFile(text: Data, at url: URL)
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
    
    func directoryExists(at url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        return fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory)
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
    
//    func createDirectory(for user: User) {
//        do {
//            let documentURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) // duplicating -> to computed property
//            let userDirectoryURL = documentURL.appendingPathComponent(user.name)
//            if !fileManager.fileExists(atPath: userDirectoryURL.path) {
//                try fileManager.createDirectory(at: userDirectoryURL, withIntermediateDirectories: true)
//                //fileManager.createFile(atPath: <#T##String#>, contents: <#T##Data?#>)
//            }
//        } catch {
//            print("Error creating directory: \(error)")
//        }
//    }
    
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
