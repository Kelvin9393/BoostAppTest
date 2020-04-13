//
//  BoostAppTestTests.swift
//  BoostAppTestTests
//
//  Created by 2.9mac256 on 13/04/2020.
//

import XCTest
@testable import BoostAppTest

class BoostAppTestTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testContactCellViewModel() {
        let contact = Contact(firstName: "Phoebe", lastName: "Monroe")
        let contactCellViewModel = ContactCellViewModel(contact: contact)
        
        XCTAssertEqual("\(contact.firstName) \(contact.lastName)", contactCellViewModel.fullName)
    }

}
