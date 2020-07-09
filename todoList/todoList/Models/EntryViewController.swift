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
    var toDoItem: ToDoListItem!
    
    // reference to db
    private let realm = try! Realm()
    
    // let list view controller know that an entry is added -> refresh
    // optional
    public var completionHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let toDoItem = toDoItem {
          title = "Edit \(toDoItem.item)"
              
          fillItemFields()
        } else {
          title = "Add New Item"
        }

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
    
    
    func fillItemFields() {
        textField.text = toDoItem.item
        datePicker.setDate(toDoItem.date, animated: false)
    }
    
    
    func updateToDoItem() {
        try! realm.write {
            toDoItem.item = textField.text!
            toDoItem.date = datePicker.date
        }
        
        completionHandler?()
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    @objc func didTapSaveButton() {
        if toDoItem != nil {
            updateToDoItem()
        } else {
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
    
}
