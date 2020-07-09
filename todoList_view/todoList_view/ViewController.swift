//
//  ViewController.swift
//  todoList_view
//
//  Created by Koe Jia-Yee on 9/7/20.
//  Copyright © 2020 Koe Jia-Yee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var listView: ListView!
    var vview: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        vview = ListView()
        
    }
    
    override func loadView() {
        super.loadView()
        lv = ListView()
        self.view = lv
    }


}

