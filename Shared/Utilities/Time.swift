//
//  ExandedRoutineToTime.swift
//  breathe-swiftui
//

import Foundation

func expandedRoutineToTime(routine: [(String, Int)]) -> String {
    let totalTime = routine.reduce(0) { $0 + $1.1 }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    let (hours, minutes, seconds) = secondsToHoursMinutesSeconds(totalTime)
    
    var timeComponents: [String] = []
    
    if hours > 0 {
        timeComponents.append("\(hours) \(hours == 1 ? "hour" : "hours")")
    }
    if minutes > 0 {
        timeComponents.append("\(minutes) \(minutes == 1 ? "minute" : "minutes")")
    }
    if seconds > 0 {
        timeComponents.append("\(seconds) \(seconds == 1 ? "second" : "seconds")")
    }
    
    return timeComponents.joined(separator: ", ")
}
