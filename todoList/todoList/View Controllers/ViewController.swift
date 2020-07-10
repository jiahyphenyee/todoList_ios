//
//  ViewController.swift
//  todoList
//
//  Created by Koe Jia-Yee on 27/6/20.
//  Copyright © 2020 Koe Jia-Yee. All rights reserved.
//

import RealmSwift
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //
    // MARK: - Variables And Properties
    //
    
    private let realm = try! Realm()
    private var data = try! Realm().objects(ToDoItems1.self).sorted(byKeyPath: "priority", ascending: true)
    var searchResults = try! Realm().objects(ToDoItems1.self)
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    //
    // MARK: - IBOutlets and IBActions
    //

    @IBOutlet var table: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
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
                searchResults = realm.objects(ToDoItems1.self).sorted(byKeyPath: "item", ascending: true)
            case 2:
                searchResults = realm.objects(ToDoItems1.self).sorted(byKeyPath: "date", ascending: true)
            default:
                searchResults = realm.objects(ToDoItems1.self).sorted(byKeyPath: "priority", ascending: true)
        }
          
        table.reloadData()
    }
    
    
    //
    // MARK: - View Controller
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        data = realm.objects(ToDoItems1.self).map({$0})
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
        
        searchBar.delegate = self
        searchResults = data
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.refresh()
    }
    
    //
    // MARK: - Table View
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        let prior = getPriorityLabel(index: searchResults[indexPath.row].priority)
    
        cell.textLabel?.text = prior + "  " + searchResults[indexPath.row].item
        cell.detailTextLabel?.text = Self.dateFormatter.string(from: searchResults[indexPath.row].date)
        
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
            let myItem = searchResults[indexPath.row]
            self.deleteItem(myItem: myItem)
        }
    }
    
    
    //
    // MARK: - Search Bar
    //
    
    func filterResultsWithSearchString(searchString: String) {
        let predicate = NSPredicate(format: "item BEGINSWITH [c]%@", searchString)
        let realm = try! Realm()
        searchResults = realm.objects(ToDoItems1.self).filter(predicate)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchResults = data
            table.reloadData()
            return
        }
        
        let searchString = searchBar.text!
            filterResultsWithSearchString(searchString: searchString)
            table.reloadData()
    }
    
    
    //
    // MARK: - Private Methods
    //
    
    func refresh(){
        // update data variables on refresh
        searchResults = try! Realm().objects(ToDoItems1.self).sorted(byKeyPath: "priority", ascending: true)
        table.reloadData()
    }
    
    
    func deleteItem(myItem: ToDoItems1){
        realm.beginWrite()
        realm.delete(myItem)
        try! realm.commitWrite()

        self.refresh()
    }
    
    
    func getPriorityLabel(index: Int) -> String {
        var priorityField: String
        
        switch index {
            case 0:
                priorityField = "‼️"
            case 1:
                priorityField = "❗️"
            case 2:
                priorityField = "⭕️"
            default:
                priorityField = "❗️"
        }
        
        return priorityField
    }
}


