//
//  Interactor.swift
//  DemoTest
//
//  Created by Syed Uzair Ahmed on 7/16/22.
//

import Foundation

enum ValidationError: Error {
    case emailNotCorrect
    case wrongPhoneNumber
}


class Interactor {
    
    let repository: ContactsRepository
    private let presenter: Presenter
    
    init(presenter: Presenter) {
        self.presenter = presenter
        self.repository = ContactsRepository()
    
        presenter.contacts = repository.allContacts
    }

    func contactSelected(_ contact: Contact) {
        presenter.moveToDetailsPage(contact: contact)
    }
    
    func saveEditedContact(_ contact: Contact) {
        repository.updateContactDetails(for: contact)
        presenter.contacts = repository.allContacts
        presenter.refreshMainView()
        presenter.moveToAllContactsView()
    }
    
}
