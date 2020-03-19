//
//  ContactsViewController.swift
//  BoostAppTest
//
//  Created by 2.9mac256 on 18/03/2020.
//

import UIKit

class ContactsViewController: BaseViewController {
    
    private let cellID = "ContactCell"
    
    private var contactViewModels = [ContactViewModel]()
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl(frame: .zero)
        refreshControl.addTarget(self, action: #selector(fetchContacts), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.tableFooterView = .init(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellID)
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        endRefreshing()
    }
    
    // MARK:- Helper methods
    
    @objc private func addButtonPressed() {
        let userDetailVC = ContactDetailViewController(style: .grouped)
        userDetailVC.delegate = self
        navigationController?.pushViewController(userDetailVC, animated: true)
    }
    
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("data.json")
    }
    
    @objc private func fetchContacts() {
//        let path = dataFilePath()
        guard let mainUrl = Bundle.main.url(forResource: "data", withExtension: "json") else { return }
//        do {
//            let text2 = try String(contentsOf: path, encoding: .utf8)
//
//        }
//        catch {/* error handling here */}
        if let data = try? Data.init(contentsOf: mainUrl) {
            do {
                let decoder = JSONDecoder()
                let contacts = try decoder.decode([Contact].self, from: data)
                contactViewModels = contacts.map({ return ContactViewModel(contact: $0) })
            } catch {
                print("Error decoding user array: \(error.localizedDescription)")
            }
        }
        endRefreshing()
    }
    
    @objc private func endRefreshing() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        [tableView].forEach { view.addSubview($0) }
        
        tableView.fillSuperView()
    }
    
    override func setupUI() {
        super.setupUI()
        
        title = "Contacts"
        
        setupRightBarItem()
        
        fetchContacts()
    }
    
    private func setupRightBarItem() {
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addBarButton
    }

    
}

extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ContactCell
        cell.contactViewModel = contactViewModels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ContactsViewController: ContactDetailViewControllerDelegate {
    func contactDetailViewControllerDidCancel(_ controller: ContactDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func contactDetailViewController(_ controller: ContactDetailViewController, didFinishAdding user: Contact) {
        
    }
    
    func contactDetailViewController(_ controller: ContactDetailViewController, didFinishEditing user: Contact) {
        
    }
}
