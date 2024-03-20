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
        let beginDateStr = beginDate.localizedDescription(date: .short, time: .long)
        let endDateStr = endDate.localizedDescription(date: .short, time: .long)
        return "duration: \(diff) seconds. (from: \(beginDateStr), to: \(endDateStr))"
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
        output("Wait for obfuscating", isLineBreak: false)
        Timer.scheduledTimer(withTimeInterval: 0.123, repeats: true) { t in
            if self.isRun {
                self.output(".", isLineBreak: false)
            } else {
                t.invalidate()
            }
        }
    }
    func stop() {
        isRun = false
        self.endDate = Date()
        output("\n", isLineBreak: true)
    }
    fileprivate func output(_ str: String, isLineBreak: Bool) {
        if OBFUManager.shared.isDocumentationPrintOnly() {
            return
        }
        if isLineBreak {
            print(str)
        } else {
            print(str, terminator: "")
        }
    }
}
