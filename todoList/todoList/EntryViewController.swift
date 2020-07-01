//
//  EntryViewController.swift
//  todoList
//
//  Created by Koe Jia-Yee on 30/6/20.
//  Copyright © 2020 Koe Jia-Yee. All rights reserved.
//

import RealmSwift
import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    // reference to db
    private let realm = try! Realm()
    
    // let list view controller know that an entry is added -> refresh
    // optional
    public var completionHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.becomeFirstResponder()
        textField.delegate = self
        
        // set date to today by default
        datePicker.setDate(Date(), animated: true)
        
        // programmatically add 'Save' right barbutton
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func didTapSaveButton() {
        if let text = textField.text, !text.isEmpty {
            let date = datePicker.date
            
            // create item
            realm.beginWrite()
            let newItem = ToDoListItem()
            newItem.date = date
            newItem.item = text
            realm.add(newItem)
            try! realm.commitWrite()
            
            completionHandler?()
            
            // dismiss view controller
            navigationController?.popToRootViewController(animated: true)
            
        } else {
            print("Add something")
        }
        
    }
    
}
