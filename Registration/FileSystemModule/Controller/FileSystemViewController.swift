//
//  FileSystemViewController.swift
//  Registration
//
//  Created by KOДИ on 20.02.2024.
//

import UIKit

class FileSystemViewController: UITableViewController {
    
    let cellIndetifier = "Cell"
    
    var contents: [URL] = []
    var currentDirectory: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBar()
        showRootDirectoryContents()
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
            UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .done, target: self, action: #selector(addFolderButtonTapped)),
            UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.button.angledtop.vertical.right"), style: .done, target: self, action: #selector(addFileButtonTapped))
        ]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Выход", style: .done, target: self, action: #selector(logoutButtonTapped))
    }
    
    private func showRootDirectoryContents() {
        currentDirectory = FileSystemManager.shared.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        print(currentDirectory)
        loadContents()
    }
    
    private func updateLeftBarButtonItem() {
        if currentDirectory == FileSystemManager.shared.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Выход", style: .done, target: self, action: #selector(logoutButtonTapped))
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(backButtonTapped))
        }
    }
    
    //MARK: - Creat Folders and Files and Logout
    @objc
    private func addFolderButtonTapped() {
        guard let directory = currentDirectory else { return }
        let newFolderName = uniqueName(for: "Папка", in: directory)
        let newFolderURL = directory.appendingPathComponent(newFolderName, isDirectory: true)
        do {
            try FileSystemManager.shared.createDirectory(at: newFolderURL, withIntermediateDirectories: false, attributes: nil)
            loadContents()
        } catch {
            print("Error creating folder: \(error.localizedDescription)")
        }
    }
    
    @objc
    private func addFileButtonTapped() {
        guard let directory = currentDirectory else { return }
        let newFileName = uniqueName(for: "Файл", in: directory)
        let newFileURL = directory.appendingPathComponent(newFileName)
        let text = String().generateRandomText()    //.data(using: .utf8) to contents
        do {
            try text.write(to: newFileURL, atomically: true, encoding: .utf8)
            print("Текст записан")
        } catch {
            print("Ошибка при записи текста \(error.localizedDescription)")
        }
        loadContents()
    }
    
    @objc
    private func logoutButtonTapped() {
        UserDefaultsManager.shared.removeLoggedInStatus()   //+-
        navigationController?.popToRootViewController(animated: true)
    }
    
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
        contents = FileSystemManager.shared.loadContents(inDirectory: directory)
        tableView.reloadData()
    }
    
    //MARK: - Generate unique name
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
    
    //MARK: - Alert
    func showFileContent(at url: URL) {
        let alertController = UIAlertController(title: url.lastPathComponent,
                                                message: String().generateRandomText(),
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
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
        cell.textLabel?.text = item.lastPathComponent
        return cell
    }
}

//MARK: - UITableViewDelegate
extension FileSystemViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = contents[indexPath.row]
        if FileSystemManager.shared.fileManager.directoryExists(at: selectedItem) {
            currentDirectory = selectedItem
            loadContents()
            updateLeftBarButtonItem()
        } else {
            showFileContent(at: selectedItem)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = contents[indexPath.row]
        do {
            try FileSystemManager.shared.removeItem(at: item)
            contents.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            print("Error deleting: \(error.localizedDescription)")
        }
    }
}
