//
//  FileSystemViewController.swift
//  Registration
//
//  Created by KOДИ on 20.02.2024.
//

import UIKit

class FileSystemViewController: UITableViewController {
    
    var contents: [URL] = []
    let fileManager = FileManager.default
    var currentDirectory: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBar()
        showRootDirectoryContents()
    }
    
    func showRootDirectoryContents() {
        currentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        loadContents()
    }
    
    func loadContents() {
        guard let directory = currentDirectory else { return }
        do {
            contents = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil).sorted(by: { $0.lastPathComponent < $1.lastPathComponent })
            tableView.reloadData()
        } catch {
            print("Error loading contents: \(error.localizedDescription)")
        }
    }
    
    func uniqueName(for baseName: String, in directory: URL) -> String {
        var name = baseName
        var count = 1
        while fileManager.fileExists(atPath: directory.appendingPathComponent(name).path) {
            count += 1
            name = "\(baseName) \(count)"
        }
        return name
    }
    
    //MARK: - Private Methods
    private func setupTableView() {
        self.tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "AddFolder"), style: .done, target: self, action: #selector(addFolderButtonTapped)),
            UIBarButtonItem(image: UIImage(named: "AddFile"), style: .done, target: self, action: #selector(addFileButtonTapped))
        ]
    }
    
    func showFileContent(at url: URL) {
        do {
            _ = try String(contentsOf: url)
            let alertController = UIAlertController(title: url.lastPathComponent,
                                                    message: String().generateRandomText(),
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        } catch {
            print("Error reading file content: \(error)")
        }
    }
    
    //MARK: - Creat Folders and Files
    @objc
    private func addFolderButtonTapped() {
        guard let directory = currentDirectory else { return }
        let newFolderName = uniqueName(for: "Папка", in: directory)
        let newFolderURL = directory.appendingPathComponent(newFolderName, isDirectory: true)
        do {
            try fileManager.createDirectory(at: newFolderURL, withIntermediateDirectories: false, attributes: nil)
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
        fileManager.createFile(atPath: newFileURL.path, contents: nil, attributes: nil)
        loadContents()
    }
    
    //MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = contents[indexPath.row]
        cell.textLabel?.text = item.lastPathComponent
        return cell
    }
    
    //MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = contents[indexPath.row]
        if fileManager.directoryExists(at: selectedItem) {
            currentDirectory = selectedItem
            loadContents()
        } else {
            showFileContent(at: selectedItem)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let indexPaths = [indexPath]
        let item = contents[indexPath.row]
        do {
            try fileManager.removeItem(at: item)
            contents.remove(at: indexPath.row)
            tableView.deleteRows(at: indexPaths, with: .automatic)
        } catch {
            print("Error deleting: \(error.localizedDescription)")
        }
    }
}


