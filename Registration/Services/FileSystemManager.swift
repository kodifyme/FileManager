//
//  FileSystemManager.swift
//  Registration
//
//  Created by KOДИ on 28.02.2024.
//

import Foundation

class FileSystemManager {
    
    static let shared = FileSystemManager()
    
    private init() { }
    
    let fileManager = FileManager.default
    
    //MARK: - Create Directory
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?) throws {
        try fileManager.createDirectory(at: url, withIntermediateDirectories: createIntermediates, attributes: attributes)
    }
    
    func createDirectory(for user: User) {
        do {
            let documentURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let userDirectoryURL = documentURL.appendingPathComponent(user.name)
            let uniqueUserDirectoryURL = userDirectoryURL.appendingPathComponent(user.userID)
            if !fileManager.fileExists(atPath: uniqueUserDirectoryURL.path) {
                try fileManager.createDirectory(at: uniqueUserDirectoryURL, withIntermediateDirectories: true)
            }
        } catch {
            print("Error creating directory: \(error)")
        }
    }
    
    //MARK: - Load Contents
    func loadContents(inDirectory directory: URL) -> [URL] {
        do {
            let contents = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            return contents
                .sorted(by: { $0.lastPathComponent.localizedStandardCompare($1.lastPathComponent) == .orderedAscending })
        } catch {
            print("Error loading contents: \(error.localizedDescription)")
            return []
        }
    }
    
    //MARK: - Remove
    func removeItem(at url: URL) throws {
        try fileManager.removeItem(at: url)
    }
    
    //MARK: - Unique Name
    func uniqueName(for baseName: String, in directory: URL) -> String {
        var name = baseName
        var count = 1
        let allFiles = try? FileSystemManager.shared.fileManager.contentsOfDirectory(atPath: directory.path)
        while allFiles?.contains("\(name)") ?? false {
            count += 1
            name = "\(baseName) \(count)"
        }
        return name
    }
    
    //MARK: - Load Text From File
    static func loadTextFromFile(at url: URL) -> String? {
        do {
            let text = try String(contentsOf: url, encoding: .utf8)
            return text
        } catch {
            print("Ошибка при загрузке текста: \(error.localizedDescription)")
            return nil
        }
    }
    
    //MARK: - Save Text To File
    func saveTextToFile(text: Data, at url: URL) {
        do {
            try text.write(to: url, options: .atomic)
            print("Текст записан")
        } catch {
            print("Ошибка при записи текста: \(error.localizedDescription)")
        }
    }
}

extension FileManager {
    func directoryExists(at url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        return fileExists(atPath: url.path, isDirectory: &isDirectory) && isDirectory.boolValue
    }
}
