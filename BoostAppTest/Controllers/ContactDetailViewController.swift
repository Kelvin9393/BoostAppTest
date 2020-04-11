//
//  ContactDetailViewController.swift
//  BoostAppTest
//
//  Created by 2.9mac256 on 18/03/2020.
//

import UIKit

protocol ContactDetailViewControllerDelegate: class {
    func contactDetailViewControllerDidCancel(_ controller: ContactDetailViewController)
    func contactDetailViewController(_ controller: ContactDetailViewController, didFinishAdding contact: Contact)
    func contactDetailViewController(_ controller: ContactDetailViewController, didFinishEditing contact: Contact)
}

class ContactDetailViewController: UITableViewController {
    
    // MARK:- Properties
    
    enum ContactDetailSection: Int, CaseIterable {
        case Avatar = 0
        case Main
        case Sub
    }
    
    private let viewModel: ContactDetailViewModel
    weak var delegate: ContactDetailViewControllerDelegate?
    
    private var cellArr = [[UITableViewCell]]()
    
    private let avatarCell: CustomInputFieldCell = {
        let cell = CustomInputFieldCell(frame: .zero)
        cell.selectionStyle = .none
        return cell
    }()
    
    private let firstNameCell: CustomInputFieldCell = {
        let cell = CustomInputFieldCell(frame: .zero)
        return cell
    }()
    
    private let lastNameCell: CustomInputFieldCell = {
        let cell = CustomInputFieldCell(frame: .zero)
        return cell
    }()
    
    private let emailCell: CustomInputFieldCell = {
        let cell = CustomInputFieldCell(frame: .zero)
        return cell
    }()
    
    private let phoneCell: UITableViewCell = {
        let cell = UITableViewCell(frame: .zero)
        cell.separatorInset = .init(top: 0, left: 15, bottom: 0, right: 0)
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
        textfield.autocapitalizationType = .words
        textfield.autocorrectionType = .no
        textfield.keyboardType = .alphabet
        return textfield
    }()
    
    private let lastNameTF: CustomTextField = {
        let textfield = CustomTextField(frame: .zero)
        textfield.enablesReturnKeyAutomatically = true
        textfield.returnKeyType = .next
        textfield.autocapitalizationType = .words
        textfield.autocorrectionType = .no
        textfield.keyboardType = .alphabet
        return textfield
    }()
    
    private let emailTF: CustomTextField = {
        let textfield = CustomTextField(frame: .zero)
        textfield.returnKeyType = .next
        textfield.autocapitalizationType = .none
        textfield.keyboardType = .emailAddress
        textfield.autocorrectionType = .no
        return textfield
    }()
    
    private let phoneTF: CustomTextField = {
        let textfield = CustomTextField(frame: .zero)
        textfield.returnKeyType = .done
        textfield.keyboardType = .numberPad
        return textfield
    }()
    
    // MARK:- Lifecycle
    
    init(config: ContactDetailConfiguration) {
        viewModel = ContactDetailViewModel(config: config)
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        viewModel.save(
            firstName: firstNameTF.text,
            lastName: lastNameTF.text,
            email: emailTF.text,
            phone: phoneTF.text)
    }
    
    private func showValidationAlert(for textField: UITextField, alertMessage: String) {
        let alertController = UIAlertController(title: "Whoops!", message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
            textField.becomeFirstResponder()
        }
        alertController.addAction(action)
        present(alertController, animated: true)
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
            cell.selectionStyle = .none
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
        initViewModel()
    }
    
    private func initViewModel() {
        firstNameTF.text = viewModel.firstName
        lastNameTF.text = viewModel.lastName
        emailTF.text = viewModel.email
        phoneTF.text = viewModel.phone
        
        viewModel.showAlertClosure = { [weak self] (message, inputType) in
            guard let weakSelf = self else { return }
            
            let textFieldToFocus: UITextField
            
            switch inputType {
            case .firstName:
                textFieldToFocus = weakSelf.firstNameTF
            case .lastName:
                textFieldToFocus = weakSelf.lastNameTF
            case .email:
                textFieldToFocus = weakSelf.emailTF
            case .phone:
                textFieldToFocus = weakSelf.phoneTF
            }
            
            weakSelf.showValidationAlert(for: textFieldToFocus, alertMessage: message)
        }
        
        viewModel.createNewContactClosure = { [weak self] (contact) in
            guard let weakSelf = self else { return }
            weakSelf.delegate?.contactDetailViewController(weakSelf, didFinishAdding: contact)
        }
        
        viewModel.editContactClosure = { [weak self] (contact) in
            guard let weakSelf = self else { return }
            weakSelf.delegate?.contactDetailViewController(weakSelf, didFinishEditing: contact)
        }
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

extension ContactDetailViewController {

    // MARK: - TableViewDataSource / TableViewDelegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return ContactDetailSection.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case ContactDetailSection.Avatar.rawValue:
            return avatarCell
        case ContactDetailSection.Main.rawValue:
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
        case ContactDetailSection.Avatar.rawValue:
            return nil
        case ContactDetailSection.Main.rawValue:
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == phoneTF, let currentText = textField.text else { return true }
        if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil { return false }
        let newCount = currentText.count + string.count - range.length
        let addingCharacter = range.length <= 0

        if newCount == 1 {
            textField.text = addingCharacter ? currentText + "(\(string)" : String(currentText.dropLast(2))
            return false
        } else if newCount == 5 {
            textField.text = addingCharacter ? currentText + ") \(string)" : String(currentText.dropLast(2))
            return false
        } else if newCount == 10 {
            textField.text = addingCharacter ? currentText + "-\(string)" : String(currentText.dropLast(2))
            return false
        }

        if newCount > 14 {
            return false
        }

        return true
    }
}
