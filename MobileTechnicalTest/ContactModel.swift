//
//  ContactModel.swift
//  DemoTest
//
//  Created by Syed Uzair Ahmed on 7/16/22.
//

import Foundation

struct Contact: Codable, Identifiable {
    let id: String
    var firstName: String
    var lastName: String
    var email: String?
    var phone: String?
}

extension Contact: Hashable, Equatable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(firstName)
        hasher.combine(lastName)
        hasher.combine(email)
        hasher.combine(phone)
    }
    
}
