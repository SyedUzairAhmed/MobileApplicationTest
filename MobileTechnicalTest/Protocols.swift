//
//  Protocols.swift
//  DemoTest
//
//  Created by Syed Uzair Ahmed on 7/16/22.
//

import Foundation

protocol ViewType {
    var presenter: Presenter! { get set}
    var interactor: Interactor! { get set}
}
