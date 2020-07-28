//
//  TagsSegueProcess.swift
//  ProjectFND
//
//  Created by Elly Richardson on 7/27/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit
import SwiftEntryKit
import os.log

class TagsSegueProcess  {
    private var observableTagsController = ObservableTagsController()
    private var taskItem: ToDo?
    private var tagSelectorAccessed: Bool
    private var currentSelectedTag: String
    
    init?(taskItem: ToDo?, tagSelectorAccessed: Bool, currentSelectedTag: String, observerVCs: [Observer]) {
        self.taskItem = taskItem
        self.tagSelectorAccessed = tagSelectorAccessed
        self.currentSelectedTag = currentSelectedTag
        
        observableTagsController.setupData()
        observableTagsController.setObservers(observers: observerVCs)
    }
    
    func segueToTagsTVC(segue: UIStoryboardSegue) {
        guard let toDoTagsTVC = segue.destination as? TagsTableViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        toDoTagsTVC.setObservableTagsController(observableTagsController: observableTagsController)
        // This tracker gets assigned if there is new ToDo and the selected in the selection for the first time, or if editing an existing ToDo
        if taskItem?.getTaskTag() != "" && taskItem != nil {
            // If already chosen something from tag selection, then always use the last selected tag when going back to selection after closing out
            if self.tagSelectorAccessed {
                toDoTagsTVC.setAssignedTag(tagName: (currentSelectedTag))
            }
            else {
                toDoTagsTVC.setAssignedTag(tagName: (taskItem!.getTaskTag()))
            }
        }
        else {
            if tagSelectorAccessed {
                toDoTagsTVC.setAssignedTag(tagName: (currentSelectedTag))
            }
        }
    }
}
