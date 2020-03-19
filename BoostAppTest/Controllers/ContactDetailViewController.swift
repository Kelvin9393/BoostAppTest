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
    
    private var cellArr = [[UITableViewCell]]()
    
    private let avatarCell: CustomInputFieldCell = {
        let cell = CustomInputFieldCell(frame: .zero)
        cell.selectionStyle = .none
        return cell
    }()
    
    private let firstNameCell: CustomInputFieldCell = {
        let cell = CustomInputFieldCell(frame: .zero)
        cell.selectionStyle = .none
        return cell
    }()
    
    private let lastNameCell: CustomInputFieldCell = {
        let cell = CustomInputFieldCell(frame: .zero)
        cell.selectionStyle = .none
        return cell
    }()
    
    private let emailCell: CustomInputFieldCell = {
        let cell = CustomInputFieldCell(frame: .zero)
        cell.selectionStyle = .none
        return cell
    }()
    
    private let phoneCell: UITableViewCell = {
        let cell = UITableViewCell(frame: .zero)
        cell.separatorInset = .init(top: 0, left: 15, bottom: 0, right: 0)
        cell.selectionStyle = .none
        return cell
    }()
    
    private let avatarView: AvatarView = {
        let view = AvatarView(frame: .zero)
        return view
    }()
    
    private let firstNameTF: CustomTextField = {
        let textfield = CustomTextField(frame: .zero)
        textfield.returnKeyType = .next
        textfield.enablesReturnKeyAutomatically = true
        return textfield
    }()
    
    private let lastNameTF: CustomTextField = {
        let textfield = CustomTextField(frame: .zero)
        textfield.enablesReturnKeyAutomatically = true
        textfield.returnKeyType = .next
        return textfield
    }()
    
    private let emailTF: CustomTextField = {
        let textfield = CustomTextField(frame: .zero)
        textfield.returnKeyType = .next
        return textfield
    }()
    
    private let phoneTF: CustomTextField = {
        let textfield = CustomTextField(frame: .zero)
        textfield.returnKeyType = .done
        return textfield
    }()
    
    override func loadView() {
        super.loadView()
        
        setupLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK:- Helper methods
    
    @objc private func cancel() {
        delegate?.contactDetailViewControllerDidCancel(self)
    }
    
    @objc private func save() {
        performFormValidation()
    }
    
    private func performFormValidation() {
        guard !firstNameTF.text!.isEmpty else {
            showValidationAlert(for: firstNameTF, alertMessage: "First name is required")
            return
        }
        
        guard !lastNameTF.text!.isEmpty else {
            showValidationAlert(for: lastNameTF, alertMessage: "Last name is required")
            return
        }
        
    }
    
    private func showValidationAlert(for textField: UITextField, alertMessage: String) {
        let alertController = UIAlertController(title: "Oops!", message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
            textField.becomeFirstResponder()
        }
        alertController.addAction(action)
        present(alertController, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return avatarCell
        case 1:
            if indexPath.row == 0 {
                return firstNameCell
            } else {
                return lastNameCell
            }
        default:
            if indexPath.row == 0 {
                return emailCell
            } else {
                return phoneCell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 30
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ContactDetailSectionHeader.cellID) as? ContactDetailSectionHeader else { return nil }
        
        switch section {
        case 0:
            return nil
        case 1:
            header.title = "Main Information"
        default:
            header.title = "Sub Information"
        }
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return .init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    // MARK:- Interface methods
    
    private func setupLayout() {
        setupAvatarView()
        setupFields()
    }
    
    private func setupAvatarView() {
        avatarCell.addSubview(avatarView)
        
        let avatarViewDimension = view.frame.width * 0.27
        avatarView.anchor(top: avatarCell.topAnchor, bottom: avatarCell.bottomAnchor, padding: .init(top: view.frame.width * 0.04, left: 0, bottom: view.frame.width * 0.08, right: 0), size: .init(width: avatarViewDimension, height: avatarViewDimension), centerX: avatarCell.centerXAnchor)
    }
    
    private func setupFields() {
        
        let cells = [firstNameCell, lastNameCell, emailCell, phoneCell]
        let textFields = [firstNameTF, lastNameTF, emailTF, phoneTF]
        let labelTitles = ["First Name", "Last Name", "Email", "Phone"]
        
        for i in 0 ..< cells.count {
            let label = UILabel(frame: .zero)
            label.text = labelTitles[i]
            label.font = UIFont.systemFont(ofSize: 16)
            let cell = cells[i]
            let textField = textFields[i]
            textField.delegate = self
            let stackView = UIStackView(arrangedSubviews: [label, textField])
            cell.addSubview(stackView)
            stackView.anchor(leading: cell.leadingAnchor, trailing: cell.trailingAnchor, padding: .init(top: 0, left: 15, bottom: 0, right: 15), centerY: cell.centerYAnchor)
            label.anchor(size: .init(width: 90, height: 0))
            textField.anchor(size: .init(width: 0, height: 32))
        }
        
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        hideKeyboardWhenTappedAround()
        setupLeftBarButtonItem()
        setupRightBarButtonItem()
        tableView.register(ContactDetailSectionHeader.self, forHeaderFooterViewReuseIdentifier: ContactDetailSectionHeader.cellID)
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

extension ContactDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTF:
            lastNameTF.becomeFirstResponder()
        case lastNameTF:
            emailTF.becomeFirstResponder()
        case emailTF:
            phoneTF.becomeFirstResponder()
        default:
            phoneTF.resignFirstResponder()
        }
        return true
    }
}
