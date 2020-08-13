//
//  TimeSlotsAssignmentVC.swift
//  ProjectFNDTests
//
//  Created by Elly Richardson on 8/12/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import Quick
import Nimble
@testable import ProjectFND

class TimeSlotsAssignmentVCSpecs: QuickSpec {
    
    var dateUtils = DateUtils()
    
    override func spec() {
        var timeSlotAssignmentVC: TimeSlotsAssignmentViewController!
        
        let date1 = dateUtils.createDate(dateString: "2020/01/15 09:30")
        let date2 = dateUtils.createDate(dateString: "2020/01/15 11:00")
        
        describe("TimeSlotsAssignmentVC") {
            
            /*
            context("When VC loads") {
                
                beforeEach {
                    timeSlotAssignmentVC = (Bundle.main.loadNibNamed("TimeSlotsAssignmentViewController",
                                                                     owner: nil,
                                                                     options: nil)?.first as! TimeSlotsAssignmentViewController)
                    timeSlotAssignmentVC.setObservableOterController(observableOterController: ObservableOterController())
                }
                
                it("uses configures time pickers") {
                    // Configuring time pickers
                    timeSlotAssignmentVC.setMinTime(minTime: date1)
                    timeSlotAssignmentVC.setMaxTime(maxTime: date2)
                    timeSlotAssignmentVC.configureTimePickers()
                    expect(timeSlotAssignmentVC.getStartTimePicker().datePickerMode).to(be(UIDatePicker.Mode.time))
                    expect(timeSlotAssignmentVC.getEndTimePicker().datePickerMode).to(be(UIDatePicker.Mode.time))
                    expect(timeSlotAssignmentVC.getStartTimePicker().date).to(be(date1))
                    expect(timeSlotAssignmentVC.getStartTimePicker().minimumDate).to(be(date1))
                    expect(timeSlotAssignmentVC.getStartTimePicker().maximumDate).to(be(date2))
                    expect(timeSlotAssignmentVC.getEndTimePicker().date).to(be(date2))
                }
            }*/
        }
    }
}
