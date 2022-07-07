//
//  HomeCollectionViewCell.swift
//  R-MLM
//
//  Created by GTMAC15 on 3.07.2022.
//

import Foundation
import UIKit


import UIKit

protocol ReusableView: AnyObject {
    static var identifier: String { get }
}

final class HomeCollectionViewCell: UICollectionViewCell {
    let name: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()



    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        
    }

    private func setupViews() {
        contentView.clipsToBounds = true
        
        contentView.layer.cornerRadius = CGFloat(10.0)
        name.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(name)
        
        NSLayoutConstraint.activate([
            name.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            name.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(with names : String) {
        name.text = names
    }
}


extension HomeCollectionViewCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}

