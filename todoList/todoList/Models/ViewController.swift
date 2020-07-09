//
//  ViewController.swift
//  todoList
//
//  Created by Koe Jia-Yee on 27/6/20.
//  Copyright © 2020 Koe Jia-Yee. All rights reserved.
//

import RealmSwift
import UIKit

class ToDoListItem: Object {
    @objc dynamic var item: String = ""
    @objc dynamic var date: Date = Date()
    
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //
    // MARK: - Variables And Properties
    //
    
    private let realm = try! Realm()
    private var data = try! Realm().objects(ToDoListItem.self).sorted(byKeyPath: "item", ascending: true)
    
    //
    // MARK: - IBOutlets and IBActions
    //

    @IBOutlet var table: UITableView!
    
    @IBAction func didTapAddButton () {
        guard let vc = storyboard?.instantiateViewController(identifier: "enter") as? EntryViewController else { return }
        
        vc.completionHandler = {[weak self] in
            self?.refresh()
        }
        vc.title = "New Item"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sortSegment(sender: Any) {
      let scopeBar = sender as! UISegmentedControl
      let realm = try! Realm()
      
      switch scopeBar.selectedSegmentIndex {
      case 1:
        data = realm.objects(ToDoListItem.self).sorted(byKeyPath: "date", ascending: true)
      default:
        data = realm.objects(ToDoListItem.self).sorted(byKeyPath: "item", ascending: true)
      }
      
      table.reloadData()
    }
    
    
    //
    // MARK: - View Controller
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        data = realm.objects(ToDoListItem.self).map({$0})
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.refresh()
    }
    
    //
    // MARK: - Table View
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = data[indexPath.row].item
        cell.detailTextLabel?.text = Self.dateFormatter.string(from: data[indexPath.row].date)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // open item to view details
        let item = data[indexPath.row]
        guard let vc = storyboard?.instantiateViewController(identifier: "view") as? ViewViewController else { return }
        
        vc.item = item
        vc.deletionHandler = {[weak self] in self?.refresh()}
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = item.item
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let myItem = data[indexPath.row]
            self.deleteItem(myItem: myItem)
        }
    }
    
    //
    // MARK: - Private Methods
    //
    
    func refresh(){
        // update data variables on refresh
        data = try! Realm().objects(ToDoListItem.self).sorted(byKeyPath: "item", ascending: true)
        table.reloadData()
    }
    
    func deleteItem(myItem: ToDoListItem){
        realm.beginWrite()
        realm.delete(myItem)
        try! realm.commitWrite()

        self.refresh()
    }
    
    static let dateFormatter: DateFormatter = {
           let dateFormatter = DateFormatter()
           dateFormatter.dateStyle = .medium
           return dateFormatter
       }()

}
