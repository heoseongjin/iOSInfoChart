//
//  RealTimeVitalChartViewController.swift
//  InfoChartDemo-iOS
//
//  Created by Heo on 2021/06/15.
//

import UIKit
import InfoChart

class RealTimeVitalChartViewController: UIViewController {

    let ecgDemoData = DemoData.ecgDemo1
    
    @IBOutlet var chartView: RealTimeVitalChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "RealTime Vital Chart"
        
        initChart()
    }
    
    @IBAction func pressStartButton(_ sender: Any) {
        chartView.dataHandler.run()
    }
    
    @IBAction func pressStopButton(_ sender: Any) {
        chartView.dataHandler.stop()
    }
    
    @IBAction func pressInsertButton(_ sender: Any) {
        for i in ecgDemoData {
            chartView.dataHandler.enqueue(value: i)
        }
    }
    
    @IBAction func pressResetButton(_ sender: Any) {
        chartView.reset()
    }
    
    func initChart() {
        let spec = Spec(oneSecondDataCount: 500,
                        visibleSecondRange: 5,
                        refreshGraphInterval: 0.1,
                        vitalMaxValue: 1.5,
                        vitalMinValue: -0.5)
        chartView.setRealTimeSpec(spec: spec)
    }
    
    
    // 화면 변화시 차트 사이즈 변경
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        chartView.updateChartSize()
    }
    
    // 화면 이동 시 타이머 해제
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        chartView.dataHandler.stop()
    }
}
