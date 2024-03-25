//
//  FileSystemProtocols.swift
//  FileManager
//
//  Created by KOДИ on 25.03.2024.
//

import Foundation

protocol FileSystemViewDelegate: AnyObject {
    func didSelectFile(at url: URL)
    func deleteItem(at indexPath: IndexPath)
    func didSelectDirectory(at indexPath: IndexPath)
}

protocol FileSystemViewDataSource: AnyObject {
    func item(at indexPath: IndexPath) -> URL
    func directoryExists(at url: URL) -> Bool
    func numberOfItems(inSection section: Int) -> Int
}
