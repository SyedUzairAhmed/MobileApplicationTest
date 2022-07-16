//
//  ContactDetailsViewController.swift
//  DemoTest
//
//  Created by Syed Uzair Ahmed on 7/16/22.
//

import UIKit
import Combine

class DetailsViewController: UIViewController, ViewType {
    
    typealias Row = Presenter.ContactDetailType
    let topSupplementryKind = "MainTopHeader"
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    weak var presenter: Presenter!
    weak var interactor: Interactor!
    var cancellables: Set<AnyCancellable> = []
    
    enum Section: Int, CaseIterable, CustomStringConvertible {
        case mainInfo = 0
        case subInfo
        
        var description: String {
            switch self {
            case .mainInfo:
                return "Main Information"
            case .subInfo:
                return "Sub Information"
            }
        }
    }
    
    var allItems = [Section.mainInfo:[Row.firstName, Row.lastName],
                    Section.subInfo:[Row.email,Row.phone]]
    var dataSource: UICollectionViewDiffableDataSource<Section, Presenter.ContactDetailType>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = createLayout()
        collectionView.allowsSelection = false
        configureDataSource()
        loadInitialData()
    }
    
    func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { section, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.headerMode = .supplementary
            let layoutSection = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
            if section == 0 {
                let topHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                           heightDimension: .absolute(100))
                let topHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: topHeaderSize,
                    elementKind: self.topSupplementryKind, alignment: .top)
                topHeader.pinToVisibleBounds = true
                layoutSection.boundarySupplementaryItems = [topHeader]
            }
            return layoutSection
        }
    }
    
    func configureDataSource() {
        
        let sectionHeaderReg = UICollectionView.SupplementaryRegistration<UICollectionViewCell>(elementKind: UICollectionView.elementKindSectionHeader) { cell, kind, ip in
            let section = Section(rawValue: ip.section)!
            var config = UIListContentConfiguration.cell()
            config.text = section.description
            config.textProperties.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            cell.contentConfiguration = config
            var back = UIBackgroundConfiguration.listPlainHeaderFooter()
            back.backgroundColor = .systemGroupedBackground
            cell.backgroundConfiguration = back
        }
        
        let topHeaderReg = UICollectionView.SupplementaryRegistration<TopSupplementaryView>(elementKind: topSupplementryKind) { view, kind, ip in
            view.imageView.image = UIColor.appColor.image(CGSize(width: 70, height: 70))
        }
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Row> { [weak self] (cell, indexPath, rowType) in
            guard let _ = self?.presenter.contactInEditing else { return }
            var contentConfig = TextFieldContentConfiguration()
            switch rowType {
            case .phone:
                contentConfig.title = "Phone"
                contentConfig.text = self!.presenter.contactInEditing!.phone
                contentConfig.textChanged = { newText in self!.presenter.contactInEditing!.phone = newText }
            case .email:
                contentConfig.title = "Email"
                contentConfig.text = self!.presenter.contactInEditing!.email
                contentConfig.textChanged = { newText in self!.presenter.contactInEditing!.email = newText }
            case .firstName:
                contentConfig.title = "First Name"
                contentConfig.text = self!.presenter.contactInEditing!.firstName
                contentConfig.textChanged = { newText in self!.presenter.contactInEditing!.firstName = newText ?? "" }
            case .lastName:
                contentConfig.title = "Last Name"
                contentConfig.text = self!.presenter.contactInEditing!.lastName
                contentConfig.textChanged = { newText in self!.presenter.contactInEditing!.lastName = newText ?? "" }
            }
            cell.contentConfiguration = contentConfig
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Row>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        dataSource.supplementaryViewProvider = { cv, kind, ip in
            if kind == UICollectionView.elementKindSectionHeader {
                return cv.dequeueConfiguredReusableSupplementary(using: sectionHeaderReg, for: ip)
            } else {
                return cv.dequeueConfiguredReusableSupplementary(using: topHeaderReg, for: ip)
            }
        }
        
    }
    
    func loadInitialData() {
        for section in Section.allCases {
            let items = allItems[section] ?? []
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Row>()
            sectionSnapshot.append(items)
            dataSource.apply(sectionSnapshot, to: section, animatingDifferences: false)
        }
    }
    
    @IBAction func saveButtonPressed(_ button: UIBarButtonItem) {
        interactor.saveEditedContact(presenter.contactInEditing!)
    }
    
    @IBAction func cancelButtonPressed(_ button: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
}

