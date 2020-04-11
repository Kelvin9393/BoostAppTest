//
//  ContactDetailViewModel.swift
//  BoostAppTest
//
//  Created by 2.9mac256 on 10/04/2020.
//

import Foundation

enum  ContactDetailConfiguration {
    case add
    case edit(Contact)
}

enum ContactDetailInputType {
    case firstName
    case lastName
    case email
    case phone
}

class ContactDetailViewModel {
    
    private let config: ContactDetailConfiguration
    
    var alert: (message: String, inputType: ContactDetailInputType)! {
        didSet {
            showAlertClosure?(alert.message, alert.inputType)
        }
    }
    
    var showAlertClosure: ((String, ContactDetailInputType) -> ())?
    var createNewContactClosure: ((Contact) -> ())?
    var editContactClosure: ((Contact) -> ())?
    
    var firstName = ""
    var lastName = ""
    var email = ""
    var phone = ""
    
    init(config: ContactDetailConfiguration) {
        self.config = config
        
        if case .edit(let contact) = config {
            firstName = contact.firstName
            lastName = contact.lastName
            email = contact.email ?? ""
            phone = contact.phone ?? ""
        }
    }
    
    func save(firstName: String?, lastName: String?, email: String?, phone: String?) {
        self.firstName = firstName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.lastName = lastName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.email = email?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.phone = phone?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        guard isFormValidate() else { return }
        
        switch config {
        case .add:
            createNewContact()
        case .edit(let contact):
            editContact(contactToEdit: contact)
        }
    }
    
    private func createNewContact() {
        let newContact = Contact(firstName: firstName, lastName: lastName)
        if !email.isEmpty { newContact.email = email }
        if !phone.isEmpty { newContact.phone = phone }
        
        createNewContactClosure?(newContact)
    }
    
    private func editContact(contactToEdit: Contact) {
        let contact = contactToEdit
        contact.firstName = firstName
        contact.lastName = lastName
        contact.email = email.isEmpty ? nil : email
        contact.phone = phone.isEmpty ? nil : phone
        
        editContactClosure?(contact)
    }
    
    private func isFormValidate() -> Bool {
        
        guard !firstName.isEmpty else {
            showAlertClosure?("First name is required", .firstName)
            return false
        }
        
        guard firstName.isValidName else {
            showAlertClosure?("First name must be characters", .firstName)
            return false
        }
        
        guard !lastName.isEmpty else {
            showAlertClosure?("Last name is required", .lastName)
            return false
        }
        
        guard lastName.isValidName else {
            showAlertClosure?("Last name must be characters", .lastName)
            return false
        }
        
        guard email.isEmpty || email.isValidEmail else {
            showAlertClosure?("Invalid email address format", .email)
            return false
        }
        
        guard phone.isEmpty || phone.isValidPhone else {
            showAlertClosure?("Invalid phone number format", .phone)
            return false
        }
        
        return true
    }
    
}
