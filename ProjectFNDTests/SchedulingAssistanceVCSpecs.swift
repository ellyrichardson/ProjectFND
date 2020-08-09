//
//  SchedulingAssistanceVC.swift
//  ProjectFNDTests
//
//  Created by Elly Richardson on 8/7/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import Quick
import Nimble
@testable import ProjectFND

class SchedulingAssistanceVCSpecs: QuickSpec {
    override func spec() {
        var schedulingAssistanceVC: SchedulingAssistanceViewController!
        
        describe("SchedulingAssistanceVC") {
            
            context("When VC loads") {
                
                beforeEach {
                    schedulingAssistanceVC = SchedulingAssistanceViewController()
                    schedulingAssistanceVC.setObservableOterController(observableOterController: ObservableOterController())
                }
                
                it("uses configureObserversAndObservables") {
                    schedulingAssistanceVC.configureObserversAndObservables()
                    expect(schedulingAssistanceVC.getObservableOterController().getObservers()[0]).to(be(schedulingAssistanceVC))
                }
                
                it("uses configureTaskItemsValues - with targetTaskJustCreated") {
                    let dummyTask = ToDo()
                    dummyTask.taskId = "SOME_ID1"
                    schedulingAssistanceVC.setTargetTask(taskItem: dummyTask)
                    schedulingAssistanceVC.setTargetTaskJustCreated(targetTaskJustCreated: true)
                    schedulingAssistanceVC.configureTaskItemsValues()
                    
                    expect(schedulingAssistanceVC.getTaskItems()[dummyTask.taskId]).to(beNil())
                }
                
                it("uses configureTaskItemsValues - without targetTaskJustCreated") {
                    let dummyTask = ToDo()
                    dummyTask.taskId = "SOME_ID1"
                    schedulingAssistanceVC.setTargetTask(taskItem: dummyTask)
                    schedulingAssistanceVC.setTargetTaskJustCreated(targetTaskJustCreated: false)
                    schedulingAssistanceVC.configureTaskItemsValues()
                    
                    expect(schedulingAssistanceVC.getTaskItems()[dummyTask.taskId]).to(be(dummyTask))
                }
                
                it("tableView() With NumberOfRowsInSection") {
                    let tsveResultPackager = TsveResultPackager()
                    let tsveResult = tsveResultPackager.packageTsveResultsWithOneOccupied()
                    schedulingAssistanceVC.setTsveResult(tsveResult: tsveResult)
                    
                    expect(schedulingAssistanceVC.tableView(UITableView(), numberOfRowsInSection: 0)).to(be(tsveResult.count))
                }
                
                it("tableView heightForRowAt - height restrictors should work") {
                    let tsveResultPackager = TsveResultPackager()
                    let tsveResult = tsveResultPackager.packageTsveResultsWithOneOccupied()
                    schedulingAssistanceVC.setTsveResult(tsveResult: tsveResult)
                    
                    let expectedResult1 = 680.0
                    let expectedResult2 = 85.0
                    
                    expect(schedulingAssistanceVC.tableView(UITableView(), heightForRowAt: IndexPath(item: 0, section: 0))).to(be(expectedResult1))
                    expect(schedulingAssistanceVC.tableView(UITableView(), heightForRowAt: IndexPath(item: 1, section: 0))).to(be(expectedResult2))
                    expect(schedulingAssistanceVC.tableView(UITableView(), heightForRowAt: IndexPath(item: 2, section: 0))).to(be(expectedResult1))
                }
                
                it("tableView heightForRowAt - non restricted height should work") {
                    let tsveResultPackager = TsveResultPackager()
                    let tsveResult = tsveResultPackager.packageTsveResultsWithThreeHoursOccupied()
                    schedulingAssistanceVC.setTsveResult(tsveResult: tsveResult)
                    
                    let expectedResult1 = 680.0
                    let expectedResult2 = self.rowHeightCalculator(oter: tsveResult[1])
                    
                    expect(schedulingAssistanceVC.tableView(UITableView(), heightForRowAt: IndexPath(item: 0, section: 0))).to(be(expectedResult1))
                    expect(schedulingAssistanceVC.tableView(UITableView(), heightForRowAt: IndexPath(item: 1, section: 0))).to(be(expectedResult2))
                    expect(schedulingAssistanceVC.tableView(UITableView(), heightForRowAt: IndexPath(item: 2, section: 0))).to(be(expectedResult1))
                }
            }
        }
    }
    
    private func rowHeightCalculator(oter: Oter) -> CGFloat {
        let dateUtil = DateUtils()
        return CGFloat(85 * dateUtil.hoursBetweenTwoDates(earlyDate: oter.startDate, laterDate: oter.endDate))
    }
}

