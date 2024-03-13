//
//  FileSystemViewController.swift
//  Registration
//
//  Created by KOДИ on 20.02.2024.
//

import UIKit

class FileSystemViewController: UITableViewController {
    
    let cellIndetifier = "Cell"
    
    let fileManagerShared = FileSystemManager.shared
    var contents: [URL] = []
    var currentDirectory: URL?
    var user: User?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBar()
        showRootDirectoryContents(user: user)
        setUser(user!)
    }
    
    func setUser(_ user: User) {
        self.user = user
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Файловая система"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //MARK: - Private Methods
    private func setupTableView() {
        self.tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIndetifier)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "folder"), style: .done, target: self, action: #selector(addFolderButtonTapped)),
            UIBarButtonItem(image: UIImage(systemName: "doc.text"), style: .done, target: self, action: #selector(addFileButtonTapped))
        ]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Выход", style: .done, target: self, action: #selector(logoutButtonTapped))
    }
    
    private func showRootDirectoryContents(user: User?) {
        if let user = user {
            let documentURL = fileManagerShared.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
            currentDirectory = documentURL?.appendingPathComponent(user.name)
            print(currentDirectory)
            loadContents()
        } else {
            print("error by identify user")
        }
    }
    
    private func updateLeftBarButtonItem() {
        if let documentDiretoryURL = fileManagerShared.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first,
           let userDirectoryURL = currentDirectory, userDirectoryURL == documentDiretoryURL.appendingPathComponent(user?.name ?? "") {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Выход", style: .done, target: self, action: #selector(logoutButtonTapped))
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(backButtonTapped))
        }
    }
    
    //MARK: - Creat Folders and Files and Logout
    @objc private func addFolderButtonTapped() {
        let alertController = UIAlertController(title: "Новая папка", message: "Введите имя папки", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Имя папки"
        }
        
        let createAction = UIAlertAction(title: "Создать", style: .default) { [weak self] _ in
            guard let self = self,
                  let folderName = alertController.textFields?.first?.text,
                  !folderName.isEmpty,
                  let directory = currentDirectory else { return }
            
            let newFolderURL = directory.appendingPathComponent(folderName, isDirectory: true)
            do {
                try fileManagerShared.createDirectory(at: newFolderURL, withIntermediateDirectories: false, attributes: nil)
                let firstFileIndex = self.contents.firstIndex(where: { !$0.hasDirectoryPath }) ?? self.contents.endIndex
                self.contents.insert(newFolderURL, at: firstFileIndex)
                let indexPath = IndexPath(row: firstFileIndex, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            } catch {
                print("Error creating folder: \(error.localizedDescription)")
            }
        }
        let cancelAction = UIAlertAction(title: "Выйти", style: .cancel)
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    @objc
    private func addFileButtonTapped() {
        let alertController = UIAlertController(title: "Создание файла", message: "Введите имя файла", preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "Имя файла"
        }

        let createAction = UIAlertAction(title: "Создать", style: .default) { [weak self] _ in
            guard let self = self,
                  let fileName = alertController.textFields?.first?.text,
                  !fileName.isEmpty,
                  let directory = currentDirectory else { return }
            let newFileURL = directory.appendingPathComponent(fileName)
            let text = "".data(using: .utf8)
            self.fileManagerShared.saveTextToFile(text: text!, at: newFileURL)
            let firstFileIndex = self.contents.endIndex
            self.contents.insert(newFileURL, at: firstFileIndex)
            let indexPath = IndexPath(row: firstFileIndex, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc
    private func logoutButtonTapped() {
        UserDefaultsManager.shared.removeLoggedInStatus()   //+-
        navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - Return to main directory
    @objc
    private func backButtonTapped() {
        guard let currentDirectory = currentDirectory else { return }
        let parentDirectory = currentDirectory.deletingLastPathComponent()
        self.currentDirectory = parentDirectory
        loadContents()
        updateLeftBarButtonItem()
    }
}

private extension FileSystemViewController {
    //MARK: - Directory contents
    func loadContents() {
        guard let directory = currentDirectory else { return }
        contents = fileManagerShared.loadContents(inDirectory: directory)
        tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource
extension FileSystemViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIndetifier, for: indexPath)
        let item = contents[indexPath.row]
        let directory = fileManagerShared.fileManager.directoryExists(at: item)
        cell.imageView?.image = directory ? UIImage(systemName: "folder") : UIImage(systemName: "doc.text")
        cell.textLabel?.text = item.lastPathComponent
        return cell
    }
}

//MARK: - UITableViewDelegate
extension FileSystemViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = contents[indexPath.row]
        if fileManagerShared.fileManager.directoryExists(at: selectedItem) {
            currentDirectory = selectedItem
            loadContents()
            updateLeftBarButtonItem()
        } else {
            showTextInsideFileAlert(at: selectedItem,
                                    message: FileSystemManager.loadTextFromFile(at: selectedItem)) { [self] text in
                guard let text = text else {
                    print("Text is nil")
                    return
                }
                fileManagerShared.saveTextToFile(text: text, at: selectedItem)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = contents[indexPath.row]
        do {
            try fileManagerShared.removeItem(at: item)
            contents.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            print("Error deleting: \(error.localizedDescription)")
        }
    }
}
