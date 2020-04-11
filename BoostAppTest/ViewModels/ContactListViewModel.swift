//
//  ContactListViewModel.swift
//  BoostAppTest
//
//  Created by 2.9mac256 on 24/03/2020.
//

import Foundation

class ContactListViewModel {
    
    private var contacts = [Contact]()
    private var contactCellViewModels = [ContactCellViewModel]()
    
    private var isFetching = false {
        didSet {
            updateRefreshControl?(isFetching)
        }
    }
    
    var updateRefreshControl: ((Bool) -> ())?
    var reloadTableViewClosure: (([IndexPath]?) -> ())?
    var insertRowsClosure: (([IndexPath]) -> ())?
    var deleteRowsClosure: (([IndexPath]) -> ())?
    
    var numberOfRows: Int {
        return contactCellViewModels.count
    }
    
    func fetchData() {
        isFetching = true
        DataService.shared.fetchContacts { (result) in
            self.isFetching = false
            switch result {
            case .success(let contacts):
                self.processContactCell(contacts: contacts)
                self.reloadTableViewClosure?(nil)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func saveData() {
        let contacts = contactCellViewModels.map{ $0.contact }
        DataService.shared.saveContacts(contacts: contacts)
    }
    
    func getCellViewModel(atIndexPath indexPath: IndexPath) -> ContactCellViewModel {
        return contactCellViewModels[indexPath.row]
    }
    
    func didAddItem(contact: Contact) {
        let newContactViewModel = ContactCellViewModel(contact: contact)
        contacts.insert(contact, at: 0)
        contactCellViewModels.insert(newContactViewModel, at: 0)
        self.insertRowsClosure?([IndexPath(row: 0, section: 0)])
        saveData()
    }
    
    func didEditItem(contact: Contact) {
        if let index = contacts.firstIndex(of: contact) {
            self.reloadTableViewClosure?([IndexPath(row: index, section: 0)])
            saveData()
        }
    }
    
    func deleteItem(atIndexPath indexPath: IndexPath) {
        contacts.remove(at: indexPath.row)
        contactCellViewModels.remove(at: indexPath.row)
        deleteRowsClosure?([indexPath])
        saveData()
    }
    
    func processContactCell(contacts: [Contact]) {
        self.contacts = contacts
        self.contactCellViewModels = contacts.map { return ContactCellViewModel(contact: $0) }
    }
        
//    private func sortContactViewModels(contactViewModels: [ContactViewModel]) -> [ContactViewModel] {
//        var contactViewModels = contactViewModels
//        contactViewModels.sort { (contactViewModel1, contactViewModel2) -> Bool in
//            return contactViewModel1.fullName.localizedStandardCompare(contactViewModel2.fullName) == .orderedAscending
//        }
//        return contactViewModels
//    }
}
