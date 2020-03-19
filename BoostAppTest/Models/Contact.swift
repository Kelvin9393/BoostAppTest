//
//  Contact.swift
//  BoostAppTest
//
//  Created by 2.9mac256 on 18/03/2020.
//

import Foundation

struct UserArray: Decodable {
    var users = [Contact]()
}

struct Contact: Decodable {
    var id: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var email: String?
    var phone: String?
}
