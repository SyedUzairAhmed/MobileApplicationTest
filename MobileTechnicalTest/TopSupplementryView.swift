//
//  TopSupplementryView.swift
//  DemoTest
//
//  Created by Syed Uzair Ahmed on 7/16/22.
//

import UIKit

class TopSupplementaryView: UICollectionReusableView {
    let bgView = UIView()
    let imageView = UIImageView()
    static let reuseIdentifier = "top-supplementary-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension TopSupplementaryView {
    func configure() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = .white
        addSubview(bgView)
        addSubview(imageView)
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            bgView.topAnchor.constraint(equalTo: topAnchor),
            bgView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bgView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

