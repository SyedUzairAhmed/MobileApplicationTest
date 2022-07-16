//
//  Repository.swift
//  DemoTest
//
//  Created by Syed Uzair Ahmed on 7/16/22.
//

import Foundation


class ContactsRepository {
    
    private(set) var allContacts: [Contact] = []
    
    init() {
        if let url = Bundle.main.url(forResource: "data", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let contacts = try? JSONDecoder().decode([Contact].self, from: data), contacts.count>0 {
            allContacts = contacts
        } else {
            preconditionFailure("'data.json' doesnt contain correct data")
        }
    }
    
    
    
    func updateContactDetails(for contact: Contact) {
        if let index = allContacts.firstIndex(where: { $0.id == contact.id }) {
            allContacts[index] = contact
        }
    }
    
    func addNewContact(_ contact: Contact) {
        allContacts.append(contact)
    }
    
    
}

