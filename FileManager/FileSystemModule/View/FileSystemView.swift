//
//  FileSystemView.swift
//  FileManager
//
//  Created by KOДИ on 18.03.2024.
//

import UIKit

class FileSystemView: UITableView {
    
    let cellIndetifier = "Cell"
    
    weak var fileSystemViewControllerDelegate: FileSystemViewDelegate?
    weak var fileSystemViewDataSource: FileSystemViewDataSource?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: .zero, style: .insetGrouped)
        
        setupTableView()
    }
    
    private func setupTableView() {
        translatesAutoresizingMaskIntoConstraints = false
        register(UITableViewCell.self, forCellReuseIdentifier: cellIndetifier)
        
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UITableViewDataSource
extension FileSystemView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fileSystemViewDataSource?.numberOfItems(inSection: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIndetifier, for: indexPath)
        guard let dataSource = fileSystemViewDataSource else { return cell }
        
        let item = dataSource.item(at: indexPath)
        let directory = dataSource.directoryExists(at: item)
        cell.imageView?.image = directory ? UIImage(systemName: "folder") : UIImage(systemName: "doc.text")
        cell.textLabel?.text = item.lastPathComponent
        return cell
    }
}

//MARK: - UITableViewDelegate
extension FileSystemView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectRow(at: indexPath, animated: true)
        
        guard let url = fileSystemViewDataSource?.item(at: indexPath) else { return }
        
        if fileSystemViewDataSource?.directoryExists(at: url) ?? false {
            fileSystemViewControllerDelegate?.didSelectDirectory(at: indexPath)
        } else {
            fileSystemViewControllerDelegate?.didSelectFile(at: url)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        fileSystemViewControllerDelegate?.deleteItem(at: indexPath)
    }
}
