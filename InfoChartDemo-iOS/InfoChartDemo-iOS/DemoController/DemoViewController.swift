//
//  ViewController.swift
//  InfoChartDemo-iOS
//
//  Created by Heo on 2021/06/14.
//

import UIKit
import InfoChart

class DemoViewController: UIViewController {

    let ecgDemoData = DemoData.ecgDemo1
    
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
        for i in ecgDemoData {
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

