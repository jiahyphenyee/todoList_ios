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
    
    //
    // MARK: - Variables And Properties
    //
    
    var toDoItem: ToDoItems1!
    // reference to db
    private let realm = try! Realm()
    // let list view controller know that an entry is added -> refresh
    public var completionHandler: (() -> Void)?
    
    
    //
    // MARK: - IBActions and IBOutlets
    //
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var detailsField: UITextView!
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBAction func priorityDidChange(sender: Any) {
        let scopeBar = sender as! UISegmentedControl
        switch scopeBar.selectedSegmentIndex {
            case 0:
                toDoItem.priority = 0
            case 1:
                toDoItem.priority = 1
            case 2:
                toDoItem.priority = 2
            default:
                break
        }
    }
    
    @IBAction func labelDidChange(sender: Any) {
        let scopeBar = sender as! UISegmentedControl
        switch scopeBar.selectedSegmentIndex {
            case 0:
                toDoItem.label = "👩🏻"   // personal
            case 1:
                toDoItem.label = "💻"   // work
            case 2:
                toDoItem.label = "🛒"   // shopping
            case 3:
                toDoItem.label = "🏋🏽‍♀️"   // fitness
            case 4:
                toDoItem.label = "📚"   // reading
            default:
                break
        }
    }
    
    //
    // MARK: - View Controller
    //

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let toDoItem = toDoItem {
            title = "Edit \(toDoItem.item)"
            fillItemFields()
        } else {
            title = "Add New Item"
            detailsField.text = "Description"
            detailsField.textColor = UIColor.lightGray
        }

        textField.becomeFirstResponder()
        textField.delegate = self

        // customise details field
        detailsField.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        detailsField.layer.borderWidth = 1.0;
        detailsField.layer.cornerRadius = 5.0;
        
        // set date to today by default
        datePicker.setDate(Date(), animated: true)
        datePicker.minimumDate = Date()
        
        // save button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
        
    }
    
    
    //
    // MARK: - Text Field Functions
    //
    
    private func detailsFieldDidBeginEditing(_ detailsField: UITextView) {
        if detailsField.textColor == UIColor.lightGray {
            detailsField.text = nil
            detailsField.textColor = UIColor.black
        }
    }
    
    func detailsFieldDidEndEditing(_ detailsField: UITextView) {
        if detailsField.text.isEmpty {
            detailsField.text = "Placeholder"
            detailsField.textColor = UIColor.lightGray
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //
    // MARK: - Functions: New Item
    //
    
    // create new item
    func createToDoItem() {
        let date = datePicker.date
        realm.beginWrite()
        let newItem = ToDoItems1()
        newItem.date = date
        newItem.item = textField.text!
        newItem.details = detailsField.text ?? ""
        realm.add(newItem)
        try! realm.commitWrite()
        
        completionHandler?()
        // dismiss view controller
        navigationController?.popToRootViewController(animated: true)
    }
    
    //
    // MARK: - Functions: Edit Item
    //
    
    // fill fields with existing data
    func fillItemFields() {
        textField.text = toDoItem.item
        detailsField.text = toDoItem.details
        datePicker.setDate(toDoItem.date, animated: false)
    }
    
    // update database
    func updateToDoItem() {
        try! realm.write {
            toDoItem.item = textField.text!
            toDoItem.date = datePicker.date
            toDoItem.details = detailsField.text!
        }
        
        completionHandler?()
        navigationController?.popToRootViewController(animated: true)
    }
    
    //
    // MARK: - Functions
    //
    
    @objc func didTapSaveButton() {
        if toDoItem != nil {
            updateToDoItem()
        } else {
            if let text = textField.text, !text.isEmpty {
                createToDoItem()
            } else {
                print("Add something")
                emptyInputAlert()
            }
            
        }
        
    }
    
    
    func emptyInputAlert() {
        // Create new Alert
        let dialogMessage = UIAlertController(title: "Error", message: "Please type something", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
         })
        
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
}
