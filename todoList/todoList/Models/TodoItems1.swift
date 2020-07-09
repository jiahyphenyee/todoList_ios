//
//  TodoItems1.swift
//  todoList
//
//  Created by Koe Jia-Yee on 10/7/20.
//  Copyright © 2020 Koe Jia-Yee. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoItems1: Object {
    @objc dynamic var item: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var details: String = ""
    @objc dynamic var priority: Int = 0
    @objc dynamic var label: String = ""
    
}
