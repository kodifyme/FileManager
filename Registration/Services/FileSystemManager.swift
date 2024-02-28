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
}

extension FileManager {
    func directoryExists(at url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        return fileExists(atPath: url.path, isDirectory: &isDirectory) && isDirectory.boolValue
    }
}
