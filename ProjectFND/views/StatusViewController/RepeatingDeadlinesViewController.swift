//
//  StatusViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 3/17/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController, Observer {
    private var _observerId: Int = 1
    private var toDosController: ToDosController!
    
    var observerId: Int {
        get {
            return self._observerId
        }
    }
    
    func update<T>(with newValue: T) {
        //setToDoItems(toDoItems: newValue as! [ToDo])
        print("ToDo Items for ScheduleViewController has been updated")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("Status View Controller Will Appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("Status View Controller Will Disappear")
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
