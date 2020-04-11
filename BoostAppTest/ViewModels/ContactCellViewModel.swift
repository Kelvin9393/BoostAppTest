//
//  ContactViewModel.swift
//  BoostAppTest
//
//  Created by 2.9mac256 on 19/03/2020.
//

import Foundation

class ContactCellViewModel: NSObject {
    
    private(set) var contact: Contact
    
    var fullName: String {
        return "\(contact.firstName) \(contact.lastName)"
    }
    
    init(contact: Contact) {
        self.contact = contact
    }
}
