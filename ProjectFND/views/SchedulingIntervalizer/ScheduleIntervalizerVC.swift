//
//  ScheduleIntervalizerVC.swift
//  ProjectFND
//
//  Created by Elly Richardson on 7/1/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit
import SwiftEntryKit

class ScheduleIntervalizerVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var hoursUiView: ItemInfoView!
    @IBOutlet weak var daysUiView: ItemInfoView!
    @IBOutlet weak var hoursPickerView: UIPickerView!
    @IBOutlet weak var daysTextField: UITextField!
    @IBOutlet weak var validImage: UIImageView!
    @IBOutlet weak var intervalizeButton: LongOvalButton!
    
    weak var detachedVCDelegate: DetachedVCDelegate?
    
    private var hoursSelection = [String]()
    
    // MARK: - Trackers
    
    private var selectedHour: String?
    
    // MARK: - UIPickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.hoursSelection.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //self.hoursSelection = hoursSelection[row]
        self.selectedHour = hoursSelection[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.hoursSelection[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configureNavigationBar()
        configureUiViews()
        setupHoursSelection()
        setupPickerViewDelegation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func configureUiViews() {
        self.hoursUiView.cornerRadius = 10
        self.daysUiView.cornerRadius = 10
    }
    
    func setupHoursSelection() {
        self.hoursSelection = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16"]
    }
    
    func setupPickerViewDelegation() {
        self.hoursPickerView.delegate = self
        self.hoursPickerView.dataSource = self
    }

    @IBAction func intervalizeButton(_ sender: LongOvalButton) {
        let daysValue = daysTextField.text
        detachedVCDelegate?.setIntervalHours(intervalHours: Int(self.selectedHour!)!)
        detachedVCDelegate?.setIntervalDays(intervalDays: Int(daysValue!)!)
        detachedVCDelegate?.transitionToNextVC()
        SwiftEntryKit.dismiss()
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
