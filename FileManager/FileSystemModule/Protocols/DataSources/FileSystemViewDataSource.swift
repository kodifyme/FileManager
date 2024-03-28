//
//  FileSystemViewDataSource.swift
//  FileManager
//
//  Created by KOДИ on 28.03.2024.
//

import UIKit

protocol FileSystemViewDataSource: AnyObject {
    func item(at indexPath: IndexPath) -> URL
    func directoryExists(at url: URL) -> Bool
    func numberOfItems(inSection section: Int) -> Int
}
