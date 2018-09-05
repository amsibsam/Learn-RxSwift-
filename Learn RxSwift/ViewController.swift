//
//  ViewController.swift
//  Learn RxSwift
//
//  Created by MTMAC16 on 03/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    lazy var textField: UITextField! = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "type something here.."
        tf.borderStyle = .roundedRect
        tf.textAlignment = .natural
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        tf.leftViewMode = .always
        
        return tf
    }()
    
    lazy var btnLogin: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("login", for: .normal)
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.blue.cgColor
        btn.layer.cornerRadius = 8
        
        return btn
    }()
    
    let disposeBag = DisposeBag()
    
    enum SubscriptionError: Error {
        case OhNooo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let requestParams = [
            "idpropinsi": "73",
        ]
//        URLSession.shared.request(url: Constant.getKabupaten, method: .get, parameters: requestParams) { (data, urlResponse, error) in
//            if let responseData = data {
//                do {
//                    let responseJson = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String : Any]
//                    print("response \(responseJson)")
//                } catch let error as NSError {
//                    print("error parse response \(error), \(error.userInfo)")
//                }
//            }
//        }
        
        URLSession.shared.request(url: Constant.getKabupaten, method: .get, parameters: requestParams)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (userInfo) in
                print("response \(userInfo)")
            }, onError: { (error) in
                print("error \(error),")
            }).disposed(by: disposeBag)
        
        let searchString = BehaviorRelay(value: "")
        
        searchString
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .map({ (value) -> String in
                print("mapping in mainThread \(Thread.isMainThread)")
                return value.lowercased()
            })
            .filter({ (value) -> Bool in
                return value.count > 2
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { value in
                print("\(value) is mainThread \(Thread.isMainThread)")
            })
            .disposed(by: disposeBag)
        
        searchString.accept("main")
        DispatchQueue.global(qos: .background).async {
            searchString.accept("background")
        }
        
        textField.rx.text.orEmpty.debounce(2, scheduler: MainScheduler.instance).subscribe(onNext: { text in
            print("text \(text)")
        }).disposed(by: disposeBag)
        
        btnLogin.rx.tap.subscribe(onNext: { _ in
            self.navigationController?.pushViewController(ListViewController(), animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(textField)
        view.addSubview(btnLogin)
        
        NSLayoutConstraint.activate([
            textField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            textField.heightAnchor.constraint(equalToConstant: 40),
            textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            btnLogin.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            btnLogin.widthAnchor.constraint(equalToConstant: 100),
            btnLogin.heightAnchor.constraint(equalToConstant: 40),
            btnLogin.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10)
            ])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

