//
//  ListViewController.swift
//  Learn RxSwift
//
//  Created by MTMAC16 on 03/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

struct AnimatedSectionModel {
    var header: String
    var items: [Item]
}

struct User: Equatable {
    var id: TimeInterval
    var name: String
    var address: String
}

extension User: IdentifiableType {
    var identity: TimeInterval {
        return id
    }
    
    typealias Identity = TimeInterval
    
    
}

extension AnimatedSectionModel : AnimatableSectionModelType {
    typealias Item = User
    
    var identity: String {
        return header
    }
    
    init(original: AnimatedSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

class ListViewController: UIViewController {
    lazy var collectionView: UICollectionView! = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.scrollDirection = .vertical
        flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        let tableView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: flowLayout)
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    lazy var btnPlus: UIBarButtonItem! = {
        let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: nil)
       return barButton
    }()
    
    let disposeBag = DisposeBag()
    
    let dataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatedSectionModel>(configureCell: {_, collectionView, indexPath, title in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.backgroundColor = .black
        cell.label.text = title.name
        return cell
    }, configureSupplementaryView: {dataSource, collectionView, kind, indexPath in
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! Header
        header.title.text = dataSource.sectionModels[indexPath.section].header
        return header
    })
    
    let data = Variable([
        AnimatedSectionModel(header: "section: 0", items: [User(id: Date().timeIntervalSince1970, name: "halo", address: "disini"), User(id: Date().timeIntervalSince1970 + 5, name: "halo", address: "disini")])
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
        configureCollectionView()
    }
    
    fileprivate func setupUI() {
        title = "list of item"
        self.navigationItem.rightBarButtonItem = btnPlus
        view.backgroundColor = .white
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
            ])
    
    }
    
    fileprivate func configureCollectionView() {
        dataSource.canMoveItemAtIndexPath = { collectionView, indexPath in
            return true
        }
        collectionView.register(Cell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(Header.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        data.asObservable().bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        btnPlus.rx.tap.bind(onNext: { [unowned self] in
            let section = self.data.value.count
            
            self.data.value[0].items.append(User(id: Date().timeIntervalSince1970, name: "tambah row", address: "ok"))
            self.data.value.append(AnimatedSectionModel(header: "section \(section)", items: [User(id: Date().timeIntervalSince1970, name: "halo", address: "disini"), User(id: Date().timeIntervalSince1970 + 5, name: "halo", address: "disini")]))
        }).disposed(by: disposeBag)
        
        //MARK setup drag n drop
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: nil)
        collectionView.addGestureRecognizer(longPressGesture)
        
        longPressGesture.rx.event.bind { [unowned self] (gesture) in
            if gesture.state == .began {
                guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else { return }
                self.collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            } else if gesture.state == .changed {
                self.collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: self.collectionView))
            } else if gesture.state == .ended {
                self.collectionView.endInteractiveMovement()
            } else {
                self.collectionView.cancelInteractiveMovement()
            }
        }.disposed(by: disposeBag)
        collectionView.addGestureRecognizer(longPressGesture)
        
        
    }
    
}
