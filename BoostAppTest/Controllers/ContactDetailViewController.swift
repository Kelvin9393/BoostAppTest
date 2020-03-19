//
//  ContactDetailViewController.swift
//  BoostAppTest
//
//  Created by 2.9mac256 on 18/03/2020.
//

import UIKit

protocol ContactDetailViewControllerDelegate: class {
    func contactDetailViewControllerDidCancel(_ controller: ContactDetailViewController)
    func contactDetailViewController(_ controller: ContactDetailViewController, didFinishAdding user: Contact)
    func contactDetailViewController(_ controller: ContactDetailViewController, didFinishEditing user: Contact)
}

class ContactDetailViewController: UITableViewController {
    
    weak var delegate: ContactDetailViewControllerDelegate?
    
    private let avatarView: AvatarView = {
        let view = AvatarView(frame: .zero)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK:- Helper methods
    
    @objc private func cancel() {
        delegate?.contactDetailViewControllerDidCancel(self)
    }
    
    @objc private func save() {
        print("save")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    // MARK:- Interface methods
    
    private func setupUI() {
        view.backgroundColor = .white
        setupLeftBarButtonItem()
        setupRightBarButtonItem()
    }
    
    private func setupLeftBarButtonItem() {
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = cancelBarButton
    }
    
    private func setupRightBarButtonItem() {
        let saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    deinit {
        print("deinit \(self)")
    }

}
