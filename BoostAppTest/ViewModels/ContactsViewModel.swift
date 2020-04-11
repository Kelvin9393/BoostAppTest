//
//  ContactListViewModel.swift
//  BoostAppTest
//
//  Created by 2.9mac256 on 24/03/2020.
//

import Foundation

class ContactListViewModel {
    
    private var contactViewModels = [ContactViewModel]()
    
    var isFetching = false {
        didSet {
            updateFetchingStatus?()
        }
    }
    
    var updateFetchingStatus: (() -> ())?
    var reloadTableViewClosure: (([IndexPath]?) -> ())?
    var deleteRowsClosure: (([IndexPath]) -> ())?
    
    var numberOfRows: Int {
        return contactViewModels.count
    }
    
    func fetchData() {
        isFetching = true
        DataService.shared.fetchContacts { (result) in
            self.isFetching = false
            switch result {
            case .success(let contacts):
                self.contactViewModels = contacts.map { return ContactViewModel(contact: $0) }
                self.reloadTableViewClosure?(nil)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func saveData() {
        let contacts = contactViewModels.map{ $0.contact }
        DataService.shared.saveContacts(contacts: contacts)
    }
    
    func getItem(atIndexPath indexPath: IndexPath) -> ContactViewModel {
        return contactViewModels[indexPath.row]
    }
    
    func didAddNewItem(contactViewModel: ContactViewModel) {
        contactViewModels.insert(contactViewModel, at: 0)
        self.reloadTableViewClosure?(nil)
        saveData()
    }
    
    func didEditItem(contactViewModel: ContactViewModel) {
        let index = contactViewModels.firstIndex { (contactVM) -> Bool in
            return contactVM.contact.id == contactViewModel.contact.id
        }
        guard let unwrappedIndex = index else { return }
        self.reloadTableViewClosure?([IndexPath(row: unwrappedIndex, section: 0)])
        saveData()
    }
    
    func deleteItem(atIndexPath indexPath: IndexPath) {
        contactViewModels.remove(at: indexPath.row)
        deleteRowsClosure?([indexPath])
        saveData()
    }
        
//    private func sortContactViewModels(contactViewModels: [ContactViewModel]) -> [ContactViewModel] {
//        var contactViewModels = contactViewModels
//        contactViewModels.sort { (contactViewModel1, contactViewModel2) -> Bool in
//            return contactViewModel1.fullName.localizedStandardCompare(contactViewModel2.fullName) == .orderedAscending
//        }
//        return contactViewModels
//    }
}
