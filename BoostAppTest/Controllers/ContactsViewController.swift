//
//  ContactListViewController.swift
//  BoostAppTest
//
//  Created by 2.9mac256 on 18/03/2020.
//

import UIKit

class ContactListViewController: BaseViewController {
    
    // MARK:- Properties
    
    private let cellID = "ContactCell"
    
    private var viewModel: ContactsViewModel = {
        return ContactsViewModel()
    }()
    
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
    
    // MARK:- Lifecycle
    
    override func viewWillDisappear(_ animated: Bool) {
        endRefreshing()
    }
    
    // MARK:- Helpers
    
    @objc private func fetchContacts() {
        viewModel.fetchData()
    }
    
    @objc private func addButtonPressed() {
        navigateToContactDetail()
    }
    
    @objc private func handleSavingData() {
        viewModel.saveData()
    }
    
    private func navigateToContactDetail(contactViewModel: ContactViewModel? = nil) {
        let contactDetailVC = ContactDetailViewController(style: .grouped)
        contactDetailVC.delegate = self
        contactDetailVC.contactViewModelToEdit = contactViewModel
        navigationController?.pushViewController(contactDetailVC, animated: true)
    }
    
    @objc private func endRefreshing() {
        refreshControl.endRefreshing()
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
        initViewModel()
        fetchContacts()
    }
    
    private func setupRightBarItem() {
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addBarButton
    }

    private func initViewModel() {
        
        viewModel.updateFetchingStatus = {[weak self] in
            DispatchQueue.main.async {
                if let weakSelf = self {
                    if weakSelf.viewModel.isFetching {
                        weakSelf.refreshControl.beginRefreshing()
                    } else {
                        weakSelf.refreshControl.perform(#selector(weakSelf.endRefreshing), with: nil, afterDelay: 0)
                    }
                }
            }
        }
        
        viewModel.reloadTableViewClosure = {[weak self] indexPaths in
            DispatchQueue.main.async {
                if let weakSelf = self {
                    if let indexPaths = indexPaths {
                        weakSelf.tableView.reloadRows(at: indexPaths, with: .automatic)
                    } else {
                        weakSelf.tableView.reloadData()
                    }
                }
            }
        }
        
        viewModel.deleteRowsClosure = { [weak self] indexPaths in
            DispatchQueue.main.async {
                if let weakSelf = self {
                    weakSelf.tableView.deleteRows(at: indexPaths, with: .automatic)
                }
            }
        }
    }
    
}

extension ContactListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ContactCell
        cell.contactViewModel = viewModel.getItem(atIndexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigateToContactDetail(contactViewModel: viewModel.getItem(atIndexPath: indexPath))
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.deleteItem(atIndexPath: indexPath)
    }
}

extension ContactListViewController: ContactDetailViewControllerDelegate {
    
    func contactDetailViewControllerDidCancel(_ controller: ContactDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func contactDetailViewController(_ controller: ContactDetailViewController, didFinishAdding contactVM: ContactViewModel) {
        viewModel.didAddNewItem(contactViewModel: contactVM)
        navigationController?.popViewController(animated: true)
    }
    
    func contactDetailViewController(_ controller: ContactDetailViewController, didFinishEditing contactVM: ContactViewModel) {
        viewModel.didEditItem(contactViewModel: contactVM)
        navigationController?.popViewController(animated: true)
    }
    
}
