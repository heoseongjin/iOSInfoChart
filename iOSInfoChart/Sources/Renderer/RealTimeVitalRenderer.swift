//
//  RealTimeVitalRenderer.swift
//  iOSInfoChart
//
//  Created by Heo on 2021/03/30.
//

import Foundation
import CoreGraphics


open class RealTimeVitalRenderer {
    
    /// 차트 데이터 프로바이더
    open var dataProvider: VitalChartDataProvider?
    
    /// 차트 draw Pointer (index)
    open var drawPointer: Int = 0
    
    /// 차트 remove pointer (index)
    open var removePointer: Int = 0
    
    /// Transformer
    open var trans: Transformer
    
    /// Draw Paint
    // ????
    
    /// Alpha 그라데이션 비율(지워지는 영역에서 그라데이션이 차지하는 비율
    public let gradient_ratio = Double(0.1)
    
    /// 전체 중 지워지는 부분의 개수
    open var removeRangeCount: Int = 0
    
    
    public init(dataProvider: VitalChartDataProvider) {
        self.dataProvider = dataProvider
        self.trans = dataProvider.transformer!
        
        updateSetting()
    }
    
    
    open func updateSetting() {
        guard let dataProvider = dataProvider else { return }
        
        drawPointer = 0
        removePointer = dataProvider.totalRanageCount - (dataProvider.totalRanageCount * (1 - Int(dataProvider.refreshGraphInterval)))
    }
    
    
    open func readyForUpdateData() {
        guard let dataProvider = dataProvider else { return }
        
        drawPointer += 1
        removePointer += 1
        
        if drawPointer >= dataProvider.totalRanageCount {
            drawPointer = 0
        }
        if removePointer >= dataProvider.totalRanageCount {
            removePointer = 0
        }
    }
    
    open func drawLinear(context: CGContext) {
        guard let dataProvider = dataProvider else { return }
        
        context.saveGState()
        
        let valueToPixelMatrix = trans.valueToPixelMatrix
        
        var alphaCount = 0
        
        var firstY: Double
        var secondY: Double
        
        var firstPoint = true
        
        let path = CGMutablePath()
        for x in stride(from: 1, to: dataProvider.totalRanageCount, by: 1) {
            firstY = dataProvider.realTimeData[x == 0 ? 0 : x - 1]
            secondY = dataProvider.realTimeData[x]
            removeRangeCount = (drawPointer < removePointer) ? removePointer - drawPointer : removePointer
            
            // change to empty data
            if (firstY == -9999 || secondY == -9999){ continue }
            
            let startPoint =
                CGPoint(x: CGFloat(x == 0 ? 0 : x - 1),
                        y: CGFloat(firstY))
                .applying(valueToPixelMatrix)
            
            if firstPoint {
                path.move(to: startPoint)
                firstPoint = false
            } else {
                path.addLine(to: startPoint)
            }
            
            let endPoint =
                CGPoint(
                    x: CGFloat(x),
                    y: CGFloat(secondY))
                .applying(valueToPixelMatrix)
            path.addLine(to: endPoint)
            
            
        }
        if !firstPoint
        {
            print(path)
            context.beginPath()
            context.addPath(path)
            context.setStrokeColor(CGColor(red: 1.0, green: 0, blue: 0, alpha: 1))
            context.strokePath()
        }
    }
}
