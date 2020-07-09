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
    
    private let realm = try! Realm()
    private var data = [ToDoListItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = realm.objects(ToDoListItem.self).map({$0})
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.refresh()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = data[indexPath.row].item
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
    
    func refresh(){
        // update data variables on refresh
        data = realm.objects(ToDoListItem.self).map({$0})
        table.reloadData()
    }

}

