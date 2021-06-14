//
//  VitalChartDataProvider.swift
//  iOSInfoChart
//
//  Created by Heo on 2021/03/30.
//

import Foundation
import CoreGraphics
import UIKit

public protocol VitalChartDataProvider {

    var oneSecondDataCount: Int { get set }

    var visibleSecondRange: Int { get set }

    var totalRanageCount: Int { get set }
    
    var refreshGraphInterval: Double { get set }
    
    var realTimeData: [Double] { get set }
    
    var lineColor: UIColor { get set }
    
    var lineWidth: CGFloat { get set }

//    RealTimeVitalChart.LineMode getLineMode();

    var isEnabledValueCircleIndicator: Bool { get set }
    
    var valueCircleIndicatorRadius: Double { get set }

    var valueCircleIndicatorColor: UIColor { get set }
    
    var vitalMaxValue: Double { get set }

    var vitalMinValue: Double { get set }
    
    var transformer: Transformer? { get set }
    
    func dequeueRealTimeData(value: Double)
}
