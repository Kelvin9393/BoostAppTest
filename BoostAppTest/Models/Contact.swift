//
//  Contact.swift
//  BoostAppTest
//
//  Created by 2.9mac256 on 18/03/2020.
//

import Foundation

class Contact: NSObject, Codable {
    let id: String
    var firstName: String
    var lastName: String
    var email: String?
    var phone: String?
    
    init(firstName: String, lastName: String) {
        self.id = "5c8a80f5\(String.randomAlphaNumericString(length: 16))"
        self.firstName = firstName
        self.lastName = lastName
    }
}
