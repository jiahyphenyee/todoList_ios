//
//  ViewViewController.swift
//  todoList
//
//  Created by Koe Jia-Yee on 30/6/20.
//  Copyright © 2020 Koe Jia-Yee. All rights reserved.
//

import RealmSwift
import UIKit

class ItemDetailsViewController: UIViewController {
    
    //
    // MARK: - Variables And Properties
    //
    
    private let realm = try! Realm()
    public var item: ToDoItems1?
    
    // refresh when item is deleted
    public var deletionHandler: (() -> Void)?
    
    //
    // MARK: - IBOutlet
    //
    
    @IBOutlet var itemLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var detailLabel: UITextView!
    @IBOutlet var priorityLabel: UILabel!
    @IBOutlet var labelLabel: UILabel!
    
    
    // format date object to string
    // static because expensive to create in memory - only created once
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    //
    // MARK: - View Controller
    //

    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemLabel.text = item?.item
        dateLabel.text = Self.dateFormatter.string(from: item!.date)
        detailLabel.text = item?.details
        labelLabel.text = item?.label
        
        switch item?.priority {
        case 0:
            priorityLabel.text = "‼️"
        case 1:
            priorityLabel.text = "❗️"
        case 2:
            priorityLabel.text = "⭕️"
        default:
            break
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDelete))
        
        let editButton = UIButton(frame: CGRect(x: 100, y: 400, width: 200, height: 50))
        editButton.backgroundColor = self.view.tintColor
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        editButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        editButton.layer.cornerRadius = 5
        editButton.center = self.view.center
        editButton.addTarget(self, action: #selector(didTapEdit), for: .touchUpInside)
        self.view.addSubview(editButton)

    }
    
    //
    // MARK: - Private Functions
    //
    
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
    
    
    @objc private func didTapEdit(){
        guard let vc = storyboard?.instantiateViewController(identifier: "enter") as? EntryViewController else { return }
        
        vc.title = "Edit Item"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.toDoItem = item
        navigationController?.pushViewController(vc, animated: true)
        
    }
    

}
