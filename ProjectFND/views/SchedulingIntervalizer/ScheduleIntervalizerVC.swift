//
//  ScheduleIntervalizerVC.swift
//  ProjectFND
//
//  Created by Elly Richardson on 7/1/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

class ScheduleIntervalizerVC: UIViewController {

    @IBOutlet weak var hoursUiView: ItemInfoView!
    @IBOutlet weak var daysUiView: ItemInfoView!
    @IBOutlet weak var hoursPickerView: UIPickerView!
    @IBOutlet weak var daysTextField: UITextField!
    @IBOutlet weak var validImage: UIImageView!
    @IBOutlet weak var intervalizeButton: LongOvalButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUiViews()
    }
    
    func configureUiViews() {
        self.hoursUiView.cornerRadius = 10
        self.daysUiView.cornerRadius = 10
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
