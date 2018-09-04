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

class ListViewController: UIViewController, UITableViewDelegate {
    lazy var tableView: UITableView! = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    let disposeBag = DisposeBag()
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>(
        configureCell: { (_, tableView, indexPath, element) -> UITableViewCell in
            let cell = UITableViewCell()
            cell.textLabel?.text = element
            
            return cell
    }, titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
    })

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "list of item"
        // Do any additional setup after loading the view.
        let items = Observable.just([
            SectionModel(model: "First Section", items: [
                "a",
                "b",
                "c"
            ]),
            SectionModel(model: "Second Section", items: [
                "d",
                "e",
                "f"
            ]),
            SectionModel(model: "Third Section", items: [
                "g",
                "h",
                "i"
            ])
        ])
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(String.self).subscribe(onNext: { (item) in
                print("selected item \(item)")
            }).disposed(by: disposeBag)
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
            ])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 10))
        label.textColor = .white
        label.text = self.dataSource.tableView(tableView, titleForHeaderInSection: section)
        view.addSubview(label)
        view.backgroundColor = .black
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
}
