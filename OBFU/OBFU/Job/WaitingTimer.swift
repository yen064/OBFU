//
//  WaitingTimer.swift
//  OBFU
//
//  Created by Aaron Yen on 2024/3/18.
//

import Foundation

class WaitingTimer {
    
    var durationDescription: String {
        let begin = CLongLong(round(self.beginDate.timeIntervalSince1970 * 1000))
        let now = CLongLong(round(self.endDate.timeIntervalSince1970 * 1000))
        let diff = Double(now - begin) / 1000
        return "duration: \(diff) seconds. (begin = \(self.beginDate), end = \(self.endDate))"
    }
    
    public private(set) var beginDate: Date = Date()
    public private(set) var endDate: Date = Date()
    public private(set) var isRun: Bool = false
    func run() {
        if isRun {
            return
        }
        isRun = true
        self.beginDate = Date()
        print("waiting", terminator: "")
        Timer.scheduledTimer(withTimeInterval: 0.123, repeats: true) { t in
            if self.isRun {
                print(".", terminator: "")
            } else {
                t.invalidate()
            }
        }
    }
    func stop() {
        isRun = false
        self.endDate = Date()
        print("\n")
    }
}
