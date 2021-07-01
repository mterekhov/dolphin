//
//  DTimeSplitterService.swift
//  dolphin
//
//  Created by Mihail Terekhov on 01.07.2021.
//

import UIKit

fileprivate let TimeBase: Int = 60

protocol DTimeSplitterServiceProtocol {

    func seconds(lengthInSeconds: Int) -> Int
    func minutes(lengthInSeconds: Int) -> Int
    func hours(lengthInSeconds: Int) -> Int
    func timeString(lengthInSeconds: Int) -> String

}


class DTimeSplitterService: DTimeSplitterServiceProtocol {

    let SecondsInHour: Int = TimeBase * TimeBase
    
    func seconds(lengthInSeconds: Int) -> Int {
        var currentLength = lengthInSeconds
        let hours: CGFloat = CGFloat(lengthInSeconds) / CGFloat(SecondsInHour)
        if hours > 1 {
            currentLength -= SecondsInHour * Int(hours.rounded(.down))
        }
        
        let minutes: CGFloat = CGFloat(currentLength) / CGFloat(TimeBase)
        if minutes > 1 {
            currentLength -= TimeBase * Int(minutes.rounded(.down))
        }
        
        return currentLength
    }
    
    func minutes(lengthInSeconds: Int) -> Int {
        var currentLength = lengthInSeconds
        let hours: CGFloat = CGFloat(lengthInSeconds) / CGFloat(SecondsInHour)
        if hours > 1 {
            currentLength -= SecondsInHour * Int(hours.rounded(.down))
        }
        
        let minutes: CGFloat = CGFloat(currentLength) / CGFloat(TimeBase)
        return Int(minutes.rounded(.down))
    }
    
    func hours(lengthInSeconds: Int) -> Int {
        return Int(CGFloat(CGFloat(lengthInSeconds) / CGFloat(SecondsInHour)).rounded(.down))
    }
    
    func timeString(lengthInSeconds: Int) -> String {
        let secondsLength = seconds(lengthInSeconds: lengthInSeconds)
        var timeStringLength = String(format: "%02d", secondsLength)
        
        let minutesLength = minutes(lengthInSeconds: lengthInSeconds)
        timeStringLength = String(format: "%02d", minutesLength) + " : " + timeStringLength

        let hoursLength = hours(lengthInSeconds: lengthInSeconds)
        if hoursLength > 0 {
            timeStringLength = String(format: "%02d", hoursLength) + " : " + timeStringLength
        }

        return timeStringLength
    }
 
}
