//
//  Cell.swift
//  Learn RxSwift
//
//  Created by MTMAC16 on 07/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import UIKit

class Cell: UICollectionViewCell {
    lazy var label: UILabel! = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            label.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            label.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
