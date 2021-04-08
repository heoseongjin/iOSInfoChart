//
//  RealTimeDataHandler.swift
//  iOSInfoChart
//
//  Created by Heo on 2021/04/05.
//

import Foundation

/// 실시간 데이터를 관리하는 핸들러
/// 균일하지 못하거나 무작위로 들어오는 데이터를 Queue에 담아 일정 시간 간격으로 출력하여 위상이 지연되거나 겹치는 현상을 없애고 의도된 대로 균일하게 출력할 수 있도록 구체화한 객체
open class RealTimeDataHandler {

    /// 메인 큐 Queue
    open var mainQueue = Queue<Double>()

    /// 차트 데이터 프로바이더
    open var dataProvider: VitalChartDataProvider?

    /// 기본 값. 스펙에서 Max와 Min의 중간 값, Queue에 데이터가 없을 경우 출력되는 값
    var defaultValue: Double = 0
    
    /// 출력될 값을 담는 임시 변수
    var dequeueValue: Double = 0

    /// 스케쥴러(타이머)
    var timer: Timer?
    
    /// Task Flag
    var isRunning: Bool = false

    public init(dataProvider: VitalChartDataProvider) {
        self.dataProvider = dataProvider
        updateSetting()
    }

    /// 핸들러 설정값 업데이트
    /// 차트의 스펙이 변경될 경우 호출됨
    public func updateSetting() {
        guard let dataProvider = dataProvider else { return }
        self.defaultValue = ((dataProvider.vitalMaxValue - dataProvider.vitalMinValue / 2) + dataProvider.vitalMinValue)
    }

    /// Queue Enqueue
    public func enqueue(value: Double) {
        DispatchQueue(label: "iOSInfoChart.app.enqueue").sync {
            self.run()
            self.mainQueue.enqueue(value)
        }
    }

    /// Queue Dequeue
    public func dequeue() {
        DispatchQueue(label: "iOSInfoChart.app.dequeue").sync {
            self.dequeueValue = self.mainQueue.dequeue() ?? self.defaultValue
            self.dataProvider!.dequeueRealTimeData(value: self.dequeueValue)
        }
    }
    
    /// 스케쥴러 실행
    /// ex)  1초에 500개의 데이터를 그리는 경우, 0.02초 간격으로 데이터를 내보내는 스케쥴러가 생성됨.
    public func run() {
        
        let time = max(1/dataProvider!.oneSecondDataCount, 1) / 2
        timer = Timer(timeInterval: TimeInterval(time), target: self, selector: #selector(fetch(_:)), userInfo: nil, repeats: true)
        
        if(!isRunning) {
            RunLoop.main.add(timer!, forMode: .common) // don't forget to add `timer` to `RunLoop`
        }
        isRunning = true
    }
    
    /// 스케쥴러 정지
    public func stop() {
        if(isRunning) {
            timer?.invalidate()
            if timer! != nil {
                RunLoop.main.add(timer!, forMode: .common)
            }
            isRunning = false
        }
    }
    
    /// Queue Reset
    public func reset() {
        mainQueue.clear()
    }
    
    
    /// 핸들러 자원 해제.
    /// ( * 핸들러가 포함된 차트의 자원이 해제되거나 더 이상 핸들러를 사용하지 않을 경우 필히 이 메소드를 호출하여야 함. 앱 성능 저하의 원인이 될 수 있음.)
    public func destroy() {
        stop()
        //shutdown??
    }
    
    
    @objc fileprivate func fetch(_ timer: Timer!) {
        dequeue()
        print(isRunning)
    }
}


