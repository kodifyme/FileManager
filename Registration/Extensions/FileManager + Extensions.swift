//
//  FileManager + Extensions.swift
//  Registration
//
//  Created by KOДИ on 26.02.2024.
//

import UIKit

extension FileManager {
    func directoryExists(at url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        return fileExists(atPath: url.path, isDirectory: &isDirectory) && isDirectory.boolValue
    }
}
