//
//  ContactViewModel.swift
//  BoostAppTest
//
//  Created by 2.9mac256 on 19/03/2020.
//

import Foundation

class ContactViewModel {
    private let contact: Contact
    
    init(contact: Contact) {
        self.contact = contact
    }
    
    var firstName: String {
        return contact.firstName
    }
    
    var lastName: String {
        return contact.lastName
    }
    
    var email: String {
        return contact.email ?? ""
    }
    
    var phone: String {
        return contact.phone ?? ""
    }
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}
