//
//  MacawChartView.swift
//  DukeRewards
//
//  Created by codeplus on 6/9/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import Foundation
import Macaw

class MacawChartView: MacawView {
    
    static let eventsAttendedData = eventData()
    static let maxValue = 100
    static let maxValueLineHeight = 180
    static let lineWidth: Double = 275
    
    static let dataDivisor = Double(maxValue/maxValueLineHeight)
    static let adjustedData: [Double] = eventsAttendedData.map({ $0.eventsAttended/dataDivisor })
    static var animations: [Animation] = []
    
    required init?(coder aDecoder: NSCoder){
        super.init(node: MacawChartView.createChart(), coder: aDecoder)
        backgroundColor = .white
    }
    
    private static func createChart() -> Group {
        var items: [Node] = addYAxisItems() + addXAxisItems()
        items.append(createBars())
        
        return Group(contents: items, place: .identity)
    }
    
    private static func addYAxisItems() -> [Node] {
        let maxLines = 6
        let lineInterval = Int(maxValue/maxLines)
        let yAxisHeight: Double = 200
        let lineSpacing: Double = 30
        
        var newNodes: [Node] = []
        for i in 1...maxLines {
            let y = yAxisHeight - (Double(i) * lineSpacing)
            
            let valueLine = Line(x1: -5, y1: y, x2: lineWidth, y2: y).stroke(fill: Color.blue.with(a: 0.10))
            let valueText = Text(text: "\(i * lineInterval)", align: .max, baseline: .mid, place: .move(dx: -10, dy: y))
            valueText.fill = Color.blue
            
            newNodes.append(valueLine)
            newNodes.append(valueText)
        }
        let yAxis = Line(x1: 0, y1: 0, x2: 0, y2: yAxisHeight).stroke(fill: Color.blue.with(a: 0.25))
        newNodes.append(yAxis)
        
        return newNodes
    }
    
    private static func addXAxisItems() -> [Node] {
        let chartBaseY: Double = 200
        var newNodes: [Node] = []
        
        for i in 1...adjustedData.count {
            let x = (Double(i) * 50)
            let valueText = Text(text: eventsAttendedData[i-1].eventType, align: .max, baseline: .mid, place: .move(dx: x, dy: chartBaseY + 15))
            valueText.fill = Color.blue
            newNodes.append(valueText)
        }
        
        let xAxis = Line(x1: 0, y1: chartBaseY, x2: lineWidth, y2: chartBaseY).stroke(fill: Color.blue.with(a: 0.25))
        newNodes.append(xAxis)
        
        return newNodes
    }

    private static func createBars() -> Group {
        let fill = LinearGradient(degree: 90, from: Color(val: 0x0000ff), to: Color(val: 0x0000ff).with(a: 0.33))
        let items = adjustedData.map { _ in Group() }
        
        animations = items.enumerated().map { (i: Int, item: Group) in
            item.contentsVar.animation(delay: Double(i) * 0.1) { t in
                let height = adjustedData[i] * t
                let rect = Rect(x: Double(i) * 50 + 25, y: 200 - height, w: 30, h: height)
                return [rect.fill(with: fill)]
            }
        }
        return items.group()
    }
    
    static func playAnimations() {
        animations.combine().play()
    }
    
    private static func eventData() -> [EventTypes] {
        let one = EventTypes(eventType: "ATHLETICS", eventsAttended: 50)
        let two = EventTypes(eventType: "DINING", eventsAttended: 35)
        let three = EventTypes(eventType: "OTHER", eventsAttended: 15)
        
        return [one, two, three]
    }
    
}
