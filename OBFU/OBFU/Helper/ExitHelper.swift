//
//  Exit.swift
//  OBFU
//
//  Created by aaron on 2024/1/22.
//

import Foundation

func printDuration() {
    let begin = OBFUManager.shared.time
    let now = Date()
    
    let diff = now.timeIntervalSince1970 - begin.timeIntervalSince1970
    print("duration = \(diff) (begin = \(begin), end = \(now))")
}

func exit(error: Error? = nil) -> Never {
    
    printDuration()
    
    sleep(1)
    if let err = error as? NSError {
        let code = Int32(err.code)
        log.write(String(format: "Error(%zd) occurred!", code))
        exit(code)
    } else {
        exit(0)
    }
}

//func exit(error: Bool = false) -> Never {
//    //Sleep shortly to prevent the terminal from eating the last log
//    sleep(1)
//    exit(error ? -1 : 0)
//}
