//
//  Presenter.swift
//  DemoTest
//
//  Created by Syed Uzair Ahmed on 7/16/22.
//

import UIKit
import Combine



class Presenter {
    
    @Published private(set) var reloadView: Void = ()
    let navController: UINavigationController
    var contacts = [Contact]()
    var contactInEditing: Contact?
    
    init() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        navController = storyboard.instantiateViewController(withIdentifier: "MainNavController") as! UINavigationController
    }
    
    func configureView(with interactor: Interactor) {
        var vc = navController.viewControllers.first as? ViewType
        vc?.interactor = interactor
        vc?.presenter = self
        reloadView = ()
    }


    func moveToDetailsPage(contact: Contact) {
        contactInEditing = contact
        guard let firstView = navController.viewControllers.first as? ViewType else { return }
        let vc: DetailsViewController = DetailsViewController.instantiateFromStoryboard()
        vc.presenter = firstView.presenter
        vc.interactor = firstView.interactor
        navController.pushViewController(vc, animated: true)
    }
    
    func moveToAllContactsView() {
        navController.popViewController(animated: true)
    }
    
    func refreshMainView() {
        reloadView = ()
    }
    

    enum ContactDetailType {
        case firstName
        case lastName
        case phone
        case email
    }
}



