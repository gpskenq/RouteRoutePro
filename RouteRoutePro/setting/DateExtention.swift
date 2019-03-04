//
//  DateExtention.swift
//  RouteRoutePro
//
//  Created by 安齋洸也 on 2018/11/22.
//  Copyright © 2018年 安齋洸也. All rights reserved.
//

import Foundation


extension Date {
    
    func yearsFrom() -> Int {
        return Calendar.current.dateComponents([.year], from: Date(), to: self).year ?? 0
    }
    func monthsFrom() -> Int {
        return Calendar.current.dateComponents([.month], from: Date(), to: self).month ?? 0
    }
    func weeksFrom() -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: Date(), to: self).weekOfYear ?? 0
    }
    func daysFrom() -> Int {
        return Calendar.current.dateComponents([.day], from: Date(), to: self).day ?? 0
    }
    func hoursFrom() -> Int {
        return Calendar.current.dateComponents([.hour], from: Date(), to: self).hour ?? 0
    }
    func minutesFrom() -> Int {
        return Calendar.current.dateComponents([.minute], from: Date(), to: self).minute ?? 0
    }
    func secondsFrom() -> Int {
        return Calendar.current.dateComponents([.second], from: Date(), to: self).second ?? 0
    }
    
    var timeStamp : Int {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }
    
    var milliStamp : Int64 {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return millisecond
    }
    
    func hoursDiff(time: Int64) -> Int {
        let timeInterval:TimeInterval = TimeInterval(time/1000)
        let date = Date(timeIntervalSince1970: timeInterval)
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    func minutesDiff(time: Int64) -> Int {
        let timeInterval:TimeInterval = TimeInterval(time/1000)
        let date = Date(timeIntervalSince1970: timeInterval)
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    func hoursDiff(date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    func minutesDiff(date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
}
