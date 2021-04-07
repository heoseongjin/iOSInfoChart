//
//  ViewController.swift
//  iOSInfoChart
//
//  Created by Heo on 2021/03/29.
//

import UIKit

class ViewController: UIViewController {

    let ecgDummy1 = DummyData.ecgDummy1
//    let ecgDummy1 = [10, 20, 0.5, 100]
    
    var i = 1
    
    @IBOutlet var chartView: RealTimeVitalChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initChart()
//        chartRun()
    }
    
    func chartRun() {
        for i in 0..<ecgDummy1.count {
            self.chartView.addRealTimeData(value: self.ecgDummy1[i])
        }
    }
    
    @IBAction func addDataButton(_ sender: Any) {
        i += 1
        self.chartView.addRealTimeData(value: self.ecgDummy1[self.i])
    }
    
    
    func initChart() {
        let spec = Spec()
        chartView.setRealTimeSpec(spec: spec)
    }
}

