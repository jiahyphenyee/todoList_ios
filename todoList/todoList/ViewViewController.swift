//
//  ViewViewController.swift
//  todoList
//
//  Created by Koe Jia-Yee on 30/6/20.
//  Copyright © 2020 Koe Jia-Yee. All rights reserved.
//

import RealmSwift
import UIKit

class ViewViewController: UIViewController {
    
    private let realm = try! Realm()
    public var item: ToDoListItem?
    
    // refresh when item is deleted
    public var deletionHandler: (() -> Void)?
    
    @IBOutlet var itemLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    // format date object to string
    // static because expensive to create in memory - only created once
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemLabel.text = item?.item
        dateLabel.text = Self.dateFormatter.string(from: item!.date)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDelete))

    }
    
    @objc private func didTapDelete(){
        // unwrap item property on this controller
        guard let myItem = self.item else {
            return
        }
        realm.beginWrite()
        realm.delete(myItem)
        try! realm.commitWrite()
        
        deletionHandler?()
        navigationController?.popToRootViewController(animated: true)
        
    }
    

}
