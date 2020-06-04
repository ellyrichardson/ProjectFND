//
//  SchedulingAssistanceViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 6/3/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

class SchedulingAssistanceViewController: UIViewController {
    
    let timeStringList: [String] = ["12:00 AM", "1:00 AM", "2:00 AM", "3:00 AM", "4:00 AM", "5:00 AM", "6:00 AM", "7:00 AM", "8:00 AM", "9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM", "6:00 PM", "7:00 PM", "8:00 PM", "9:00 PM", "10:00 PM", "11:00 PM"]

    override func viewDidLoad() {
        super.viewDidLoad()
        let screensize: CGRect = UIScreen.main.bounds
        let scrollView = createScrollView()
        
        
        addTimeLabelsToScrollView(scrollView: scrollView, timeStringList: self.timeStringList)

        scrollView.contentSize = CGSize(width: screensize.width, height: 2000)
        view.addSubview(scrollView)
        
    }
    
    private func drawLineFromPoint(start : CGPoint, toPoint end:CGPoint, ofColor lineColor: UIColor, inView view:UIView) {

        //design the path
        var path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)

        //design path in layer
        var shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = 1.0

        //return shapeLayer
        
        view.layer.addSublayer(shapeLayer)
    }
    
    private func createScrollView() -> UIScrollView {
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        return UIScrollView(frame: CGRect(x: 0, y: 120, width: screenWidth, height: screenHeight))
    }
    
    private func createTimeUILabel(timeString: String) -> UILabel {
        let label = UILabel()
        label.text = timeString
        //label.backgroundColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func addTimeLabelsToScrollView(scrollView: UIScrollView, timeStringList: [String]) {
        var indexCounter = 0
        for timeString in timeStringList {
            let timeUILabel = createTimeUILabel(timeString: timeString)
            scrollView.addSubview(timeUILabel)
            NSLayoutConstraint(item: timeUILabel, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leadingMargin, multiplier: 1, constant: 10).isActive = true
            NSLayoutConstraint(item: timeUILabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200).isActive = true
            NSLayoutConstraint(item: timeUILabel, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .topMargin, multiplier: 1, constant: CGFloat(indexCounter * 60)).isActive = true
            NSLayoutConstraint(item: timeUILabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
            
            drawLineFromPoint(start: CGPoint(x: 100,y: indexCounter * 150), toPoint: CGPoint(x: 500,y: indexCounter * 150), ofColor: UIColor.green, inView: scrollView)
            indexCounter += 1
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
