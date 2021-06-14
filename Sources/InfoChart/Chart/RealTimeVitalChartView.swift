//
//  RealTimeVitalChartView.swift
//  iOSInfoChart
//
//  Created by Heo on 2021/03/30.
//

import Foundation
import CoreGraphics
import UIKit

open class RealTimeVitalChartView: UIView, VitalChartDataProvider {
    
    public let EMPTY_DATA = Double(-9999)
    
    /// 실시간 차트 스펙
    public var spec: Spec = Spec()
    
    /// 실시간 데이터
    public var realTimeData: [Double] = [Double]()
    
    /// 렌더링 스레드
    //
    
    /// 실시간 데이터 렌더링 객체
    public var realTimeVitalRenderer: RealTimeVitalRenderer?
    
    /// ViewPortHandler
    public var viewPortHandler: ViewPortHandler = ViewPortHandler()
    
    /// 서로 다른 좌포계에서 x, y value를 변환
    public var transformer: Transformer?
    
    /// 차트 선 색상
    public var lineColor: UIColor = UIColor()
    
    /// 차트 선 두께
    public var lineWidth: CGFloat = CGFloat()
    
    /// 현재 값 인디케이터 활성 여부
    public var isEnabledValueCircleIndicator: Bool = true
    
    /// 현재 값 인디케이터 크기
    public var valueCircleIndicatorRadius: Double = 1
    
    /// 현재 값 인디케이터 색상
    public var valueCircleIndicatorColor: UIColor = UIColor()
    
    /// 실시간 데이터 핸들러
    public var dataHandler: RealTimeDataHandler!
    
    // 스토리보드에서 호출할 초기화 메소드
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    // 프로그래밍 방식으로 호출할 초기화 메소드
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }

    private func initialize() {
        lineColor = UIColor.red
        lineWidth = CGFloat(1.5)
        
        isEnabledValueCircleIndicator = true
        valueCircleIndicatorColor = UIColor.red
        valueCircleIndicatorRadius = 3
        
        viewPortHandler.setChartDimens(width: bounds.size.width, height: bounds.size.height)
        transformer = Transformer(viewPortHandler: viewPortHandler)
        realTimeVitalRenderer = RealTimeVitalRenderer(dataProvider: self)
        dataHandler = RealTimeDataHandler(dataProvider: self)
        
        setRealTimeSpec(spec: spec)
        
        settingTransformer()
    }
    
    // 차트 사이즈 변경
    public func updateChartSize() {
        viewPortHandler.setChartDimens(width: bounds.size.width, height: bounds.size.height)
        settingTransformer()
    }
    
    open override func draw(_ rect: CGRect) {
        
        guard let renderer = realTimeVitalRenderer else { return }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        renderer.drawLinear(context: context)
    }
    
    open func setRealTimeSpec(spec: Spec) {
        
        guard let realTimeVitalRenderer = realTimeVitalRenderer else { return }
        
        self.spec = spec
        realTimeVitalRenderer.updateSetting()
        dataHandler.updateSetting()
        let dataCount = spec.oneSecondDataCount * spec.visibleSecondRange
        realTimeData = [Double](repeating: EMPTY_DATA, count: dataCount)
        resetRealTimeData()
    }
    
    public func addRealTimeData(value: Double) {
        
        guard let realTimeVitalRenderer = realTimeVitalRenderer else { return }
        
        realTimeVitalRenderer.readyForUpdateData()
        
        realTimeData[realTimeVitalRenderer.drawPointer] = value
        realTimeData[realTimeVitalRenderer.removePointer] = EMPTY_DATA
        
        setNeedsDisplay()
    }
    
    private func settingTransformer() {
        guard let transformer = transformer else { return }
        
        transformer.initValueMatrix(chartXMin: 0,
                                    deltaX: CGFloat(spec.oneSecondDataCount * spec.visibleSecondRange),
                                    deltaY: CGFloat(spec.vitalMaxValue - spec.vitalMinValue),
                                    chartYMin: spec.vitalMinValue)
        transformer.initOffsetMatrix()
    }
    
    private func resetRealTimeData() {
        for i in 0..<realTimeData.count {
            realTimeData[i] = EMPTY_DATA
        }
    }
    
    public func reset() {
        resetRealTimeData()
        dataHandler.stop()
        dataHandler.reset()
        dataHandler.updateSetting()
        realTimeVitalRenderer?.updateSetting()
    }
    
    // MARK: - Spec
    public func dequeueRealTimeData(value: Double) {
        addRealTimeData(value: value)
    }
    
    public lazy var oneSecondDataCount = spec.oneSecondDataCount
    
    public lazy var visibleSecondRange = spec.visibleSecondRange
    
    public lazy var totalRanageCount = oneSecondDataCount * visibleSecondRange
    
    public lazy var refreshGraphInterval = spec.refreshGraphInterval
    
    public lazy var vitalMaxValue = spec.vitalMaxValue
    
    public lazy var vitalMinValue = spec.vitalMinValue
}
