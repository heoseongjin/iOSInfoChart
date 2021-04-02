//
//  ViewController.swift
//  iOSInfoChart
//
//  Created by Heo on 2021/03/29.
//

import UIKit

class ViewController: UIViewController {

//    let ecgDummy1 = DummyData.ecgDummy1
    let ecgDummy1 = [0.01, 0.02, 0.03]
    
    @IBOutlet var chartView: RealTimeVitalChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initChart()
        chartRun()
    }
    
    func chartRun() {
        for i in ecgDummy1 {
            chartView.addRealTimeData(value: i)
            print("i : \(i)")
        }
    }
    
    func initChart() {
        let spec = Spec()
        chartView.setRealTimeSpec(spec: spec)
    }
}

