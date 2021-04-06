////
////  RealTimeDataHandler.swift
////  iOSInfoChart
////
////  Created by Heo on 2021/04/05.
////
//
//import Foundation
//
//open class RealTimeDataHandler {
//
//    /// 메인 큐 Queue
//    open var mainQueue = Queue<Double>()
//
//    /// 차트 데이터 프로바이더
//    open var dataProvider: VitalChartDataProvider?
//
//    /// 변수
//    var defaultValue: Double = 0
//    var dequeueValue: Double = 0
//
//    /// 스케쥴러
//
//    /// Task
//
//    /// Task Flag
//    var isRunning: Bool = false
//
//    public init(dataProvider: VitalChartDataProvider) {
//        self.dataProvider = dataProvider
//        updateSetting()
//    }
//
//    public func updateSetting() {
//        guard let dataProvider = dataProvider else { return }
//        self.defaultValue = ((dataProvider.vitalMaxValue - dataProvider.vitalMinValue / 2) + dataProvider.vitalMinValue)
//    }
//
//    public func enqueue(value: Double) {
//        run()
//        mainQueue.enqueue(value)
//    }
//
//    public func dequeue(value: Double) {
//        dequeueValue = mainQueue.dequeue() ?? defaultValue
//        dataProvider?.dequeueRealTimeData(value: dequeueValue)
//    }
//}
