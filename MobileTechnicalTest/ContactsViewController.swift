//
//  ViewController.swift
//  DemoTest
//
//  Created by Syed Uzair Ahmed on 7/16/22.
//

import UIKit
import Combine

class ContactsViewController: UIViewController, ViewType, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    weak var presenter: Presenter!
    weak var interactor: Interactor!
    var cancellables: Set<AnyCancellable> = []
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Contact>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.delegate = self
        configureDataSource()
        reloadData()
        
        presenter.$reloadView
            .receive(on: RunLoop.main)
            .sink { [unowned self] _ in
                self.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Contact> { (cell, indexPath, rowItem) in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = "\(rowItem.firstName) \(rowItem.lastName)"
            contentConfiguration.image = UIColor.appColor.image(CGSize(width: 40, height: 40))
            contentConfiguration.imageProperties.tintColor = .appColor
            contentConfiguration.imageProperties.cornerRadius = 20
            contentConfiguration.imageProperties.maximumSize = CGSize(width: 40, height: 40)
            cell.contentConfiguration = contentConfiguration
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Contact>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
    }
    
    func reloadData() {
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Contact>()
        sectionSnapshot.append(presenter.contacts)
        dataSource.apply(sectionSnapshot, to: 0, animatingDifferences: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let contact = presenter.contacts[indexPath.row]
        interactor.contactSelected(contact)
    }

}

