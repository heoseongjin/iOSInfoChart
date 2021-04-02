//
//  Transformer.swift
//  iOSInfoChart
//
//  Created by Heo on 2021/03/29.
//

import Foundation
import CoreGraphics

open class Transformer: NSObject
{
    
    internal var offsetMatrix = CGAffineTransform.identity

    internal var valueMatrix = CGAffineTransform.identity

    internal var viewPortHandler: ViewPortHandler

    public init(viewPortHandler: ViewPortHandler)
    {
        self.viewPortHandler = viewPortHandler
    }
    
    open func valuesToPixel(_ points: inout [CGPoint])
    {
        points = points.map { $0.applying(valueToPixelMatrix) }
    }
    
    open func initValueMatrix(chartXMin: Double, deltaX: CGFloat, deltaY: CGFloat, chartYMin: Double)
    {
        let scaleX = (viewPortHandler.chartWidth / deltaX)
        let scaleY = (viewPortHandler.chartHeight / deltaY)

        // setup all matrixes
        valueMatrix.translatedBy(x: CGFloat(-chartXMin), y: CGFloat(-chartYMin))
        valueMatrix.scaledBy(x: scaleX, y: -scaleY)
    }
    
    open func initOffsetMatrix() {
        offsetMatrix.translatedBy(x: viewPortHandler.offsetLeft, y: viewPortHandler.chartHeight - viewPortHandler.offsetBottom)
    }
    
    open var valueToPixelMatrix: CGAffineTransform{
        return valueMatrix.concatenating(offsetMatrix)
    }
    
}

