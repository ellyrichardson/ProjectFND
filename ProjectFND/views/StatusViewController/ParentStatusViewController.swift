//
//  StatusViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 3/17/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

class ParentStatusViewController: UIViewController, Observer {
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

    @IBOutlet weak var statusDeadlineSegment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        // Do any additional setup after loading the view.
    }
    
    func setToDosController(toDosController: ToDosController) {
        self.toDosController = toDosController
    }
    
    func getToDosController() -> ToDosController {
        return self.toDosController
    }
    
    func getObserverId() -> Int {
        return self.observerId
    }
    
    private func setupView() {
        setupSegmentedControl()
        setupSegmentedControlWidth()
        updateView()
    }
    
    private func setupSegmentedControlWidth() {
        self.statusDeadlineSegment.setWidth(100.0, forSegmentAt: 0)
        self.statusDeadlineSegment.setWidth(100.0, forSegmentAt: 1)
    }
    
    private func setupSegmentedControl() {
        // Configure Segmented Control
        statusDeadlineSegment.removeAllSegments()
        statusDeadlineSegment.insertSegment(withTitle: "Non-Repeating", at: 0, animated: true)
        statusDeadlineSegment.insertSegment(withTitle: "Repeating", at: 1, animated: true)
        statusDeadlineSegment.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        
        // Select First Segment
        statusDeadlineSegment.selectedSegmentIndex = 0
    }
    
    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }

    // MARK: - Child View Controllers Instantiation
    
    private lazy var statusViewController: StatusViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "StatusViewController") as! StatusViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    // Non Repating Deadlines ( from DeadlinesViewController )
    private lazy var nonRepeatingDeadlinesViewController: NonRepeatingDeadlinesViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "NonRepeatingDeadlinesView") as! NonRepeatingDeadlinesViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    private func updateView() {
        if statusDeadlineSegment.selectedSegmentIndex == 0 {
            remove(asChildViewController: statusViewController)
            add(asChildViewController: nonRepeatingDeadlinesViewController)
        } else {
            remove(asChildViewController: nonRepeatingDeadlinesViewController)
            add(asChildViewController: statusViewController)
        }
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
