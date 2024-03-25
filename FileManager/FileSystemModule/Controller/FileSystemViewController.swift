//
//  FileSystemViewController.swift
//  Registration
//
//  Created by KOДИ on 20.02.2024.
//

import UIKit

class FileSystemViewController: UIViewController {
    
    let fileManager = FileSystemManager.shared
    let usertManager = UserDefaultsManager.shared
    var contents: [URL] = []
    var currentDirectory: URL?
    
    private let fileSystemView = FileSystemView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupNavigationBar()
        showRootDirectoryContents()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Файловая система"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupViews() {
        view.addSubview(fileSystemView)
        fileSystemView.fileSystemViewControllerDelegate = self
        fileSystemView.fileSystemViewDataSource = self
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "folder"), style: .done, target: self, action: #selector(addFolderButtonTapped)),
            UIBarButtonItem(image: UIImage(systemName: "doc.text"), style: .done, target: self, action: #selector(addFileButtonTapped))
        ]
        
        updateLeftBarButtonItem()
    }
    
    private func showRootDirectoryContents() {
        currentDirectory = fileManager.showRootDirectoryContents()
        loadContents()
        print(currentDirectory)
    }
    
    private func loadContents() {
        guard let directory = currentDirectory else { return }
        contents = fileManager.loadContents(inDirectory: directory)
        fileSystemView.reloadData()
    }
    
    private func updateLeftBarButtonItem() {
        if let currentDirectory = currentDirectory, currentDirectory != fileManager.showRootDirectoryContents() {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(backButtonTapped))
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Выход", style: .plain, target: self, action: #selector(logoutButtonTapped))
        }
    }
    
    @objc
    private func addFolderButtonTapped() {
        showFolderCreationAlert() { folderName in
            guard let folderName = folderName,
                  !folderName.isEmpty,
                  let directory = self.currentDirectory else { return }
            let newFolderURL = directory.appendingPathComponent(folderName, 
                                                                isDirectory: true)
            do {
                try self.fileManager.createDirectory(at: newFolderURL)
                self.contents.sort(by: {
                    if $0.hasDirectoryPath && $1.hasDirectoryPath {
                        return $0.lastPathComponent.localizedStandardCompare($1.lastPathComponent) == .orderedAscending
                    } else if $0.hasDirectoryPath {
                        return true
                    } else if $1.hasDirectoryPath {
                        return false
                    } else {
                        return $0.lastPathComponent.localizedStandardCompare($1.lastPathComponent) == .orderedAscending
                    }
                })
                let indexForFolder = self.contents.firstIndex { $0.lastPathComponent > newFolderURL.lastPathComponent } ?? self.contents.endIndex
                self.contents.insert(newFolderURL, at: indexForFolder)
                let indexPath = IndexPath(row: indexForFolder, section: 0)
                self.fileSystemView.insertRows(at: [indexPath], with: .automatic)
            } catch {
                print("Error creating folder: \(error.localizedDescription)")
            }
        }
    }
    
    @objc
    private func addFileButtonTapped() {
        showFileCreationAlert { fileName in
            guard let fileName = fileName, !fileName.isEmpty, let directory = self.currentDirectory else { return }
            let newFileURL = directory.appendingPathComponent(fileName)
            let text = "".data(using: .utf8)
            self.fileManager.createFile(atPath: newFileURL.path, contents: text)
            self.fileManager.saveTextToFile(text: text!, at: newFileURL)
            self.contents.append(newFileURL)
            let indexPath = IndexPath(row: self.contents.count - 1, section: 0)
            self.fileSystemView.beginUpdates()
            self.fileSystemView.insertRows(at: [indexPath], with: .automatic)
            self.fileSystemView.endUpdates()
            print("Файл - \(fileName) создан")
        }
    }
    
    @objc
    private func logoutButtonTapped() {
        guard currentDirectory == fileManager.showRootDirectoryContents() else { return }
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc
    func backButtonTapped() {
        guard let currentDirectory = currentDirectory else { return }
        let parentDirectory = currentDirectory.deletingLastPathComponent()
        self.currentDirectory = parentDirectory
        contents = fileManager.loadContents(inDirectory: parentDirectory)
        fileSystemView.reloadData()
        updateLeftBarButtonItem()
    }
}

extension FileSystemViewController: FileSystemViewDelegate {
    func didSelectDirectory(at indexPath: IndexPath) {
        let selectedItem = contents[indexPath.row]
        currentDirectory = selectedItem
        loadContents()
        updateLeftBarButtonItem()
    }
    
    func deleteItem(at indexPath: IndexPath) {
        do {
            let item = contents[indexPath.row]
            try fileManager.removeItem(at: item)
            contents.remove(at: indexPath.row)
            fileSystemView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            print("Error deleting item: \(error.localizedDescription)")
        }
    }
    
    func didSelectFile(at url: URL) {
        let message = fileManager.loadTextFromFile(at: url)
        showTextInsideFileAlert(at: url, message: message) { [weak self] text in
            guard let text = text,
                  let self = self else {
                print("Text is nil")
                return
            }
            fileManager.saveTextToFile(text: text, at: url)
        }
    }
}

extension FileSystemViewController: FileSystemViewDataSource {
    func numberOfItems(inSection section: Int) -> Int {
        contents.count
    }
    
    func item(at indexPath: IndexPath) -> URL {
        contents[indexPath.row]
    }
    
    func directoryExists(at url: URL) -> Bool {
        fileManager.directoryExists(at: url)
    }
}

private extension FileSystemViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            fileSystemView.topAnchor.constraint(equalTo: view.topAnchor),
            fileSystemView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fileSystemView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fileSystemView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
