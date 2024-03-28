//
//  FileSystemViewDelegate.swift
//  FileManager
//
//  Created by KOДИ on 28.03.2024.
//

import UIKit

protocol FileSystemViewDelegate: AnyObject {
    func didSelectFile(at url: URL)
    func deleteItem(at indexPath: IndexPath)
    func didSelectDirectory(at indexPath: IndexPath)
}
