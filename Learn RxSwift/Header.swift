//
//  Header.swift
//  Learn RxSwift
//
//  Created by MTMAC16 on 07/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import UIKit

class Header: UICollectionReusableView {
    lazy var title: UILabel! = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        addSubview(title)
        
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            title.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            title.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
