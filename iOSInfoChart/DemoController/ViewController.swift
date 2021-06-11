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
    
    @IBOutlet var chartView: RealTimeVitalChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initChart()
    }
    
    @IBAction func pressStartButton(_ sender: Any) {
        chartView.dataHandler.run()
    }
    
    @IBAction func pressStopButton(_ sender: Any) {
        chartView.dataHandler.stop()
    }
    
    @IBAction func pressAddButton(_ sender: Any) {
        for i in ecgDummy1 {
            chartView.dataHandler.enqueue(value: i)
        }
    }
    
    @IBAction func pressResetButton(_ sender: Any) {
        chartView.reset()
    }
    
    func initChart() {
        let spec = Spec()
        chartView.setRealTimeSpec(spec: spec)
    }
    
    // 화면 변화 대응
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        chartView.updateChartSize()
    }
}

