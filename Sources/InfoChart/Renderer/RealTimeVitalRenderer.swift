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
    
    /// Alpha 그라데이션 비율(지워지는 영역에서 그라데이션이 차지하는 비율
    public let gradient_ratio = Double(0.2)
    
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
        removePointer = dataProvider.totalRanageCount - Int((Double(dataProvider.totalRanageCount) * (1.0 - dataProvider.refreshGraphInterval)))
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
        defer { context.restoreGState() }
        
        context.setLineWidth(dataProvider.lineWidth)
        
        let valueToPixelMatrix = trans.valueToPixelMatrix
        
        let lineColor = dataProvider.lineColor.cgColor
        var alphaCount: Int = 0
        var alphaValue: CGFloat = 0
        
        var firstY: Double
        var secondY: Double
        
        var rect = CGRect()
        
        removeRangeCount = (drawPointer < removePointer) ? removePointer - drawPointer : removePointer
        
        for x in stride(from: 1, to: dataProvider.totalRanageCount, by: 1) {
            firstY = dataProvider.realTimeData[x == 0 ? 0 : x - 1]
            secondY = dataProvider.realTimeData[x]
//            removeRangeCount = (drawPointer < removePointer) ? removePointer - drawPointer : removePointer
            
            // change to empty data
            if (firstY == -9999 || secondY == -9999){
                continue
            }
            
            DispatchQueue.global(qos: .userInteractive).sync{
                
            }

            let path = CGMutablePath()
            
            // 선의 시작점
            let startPoint =
                CGPoint(x: CGFloat(x == 0 ? 0 : x - 1),
                        y: CGFloat(firstY))
                .applying(valueToPixelMatrix)
            path.move(to: startPoint)
            
            // 선의 종료점
            let endPoint =
                CGPoint(
                    x: CGFloat(x),
                    y: CGFloat(secondY))
                .applying(valueToPixelMatrix)
            path.addLine(to: endPoint)
            
            context.addPath(path)
            
            // 그라데이션 처리
            if (x >= removePointer) && (alphaCount < removeRangeCount) {
                alphaValue = calculateAlphaRatio(totalCount: removeRangeCount, count: alphaCount)
                context.setAlpha(alphaValue)
                alphaCount += 1
            } else {
                context.setAlpha(1)
            }

            context.setStrokeColor(lineColor)
            context.strokePath()
        }
        
        
        
        // draw Circle Indicator
        if dataProvider.isEnabledValueCircleIndicator {
            let circlePoint =
                CGPoint(x: CGFloat(drawPointer),
                        y: CGFloat(dataProvider.realTimeData[drawPointer]))
                .applying(valueToPixelMatrix)
            
            let circleRadius = dataProvider.valueCircleIndicatorRadius
            let circleDiameter = circleRadius * 2.0
            
            rect.origin.x = circlePoint.x - CGFloat(circleRadius)
            rect.origin.y = circlePoint.y - CGFloat(circleRadius)
            rect.size.width = CGFloat(circleDiameter)
            rect.size.height = CGFloat(circleDiameter)
            
            context.setAlpha(1)
            context.setFillColor(dataProvider.valueCircleIndicatorColor.cgColor)
            context.fillEllipse(in: rect)
        }
    }
    
    private func calculateAlphaRatio(totalCount: Int, count: Int) -> CGFloat {
        let ratio = Double(count) / Double(totalCount)
        return CGFloat(ratio)
    }
    
}
