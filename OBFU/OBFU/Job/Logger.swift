//
//  Logger.swift
//  OBFU
//
//  Created by aaron on 2024/1/22.
//      從 gwpay 搬過來, 反正是自己寫的.
//

import Foundation

internal struct Logger {
    public var isPrint: Bool {
        if let isDebugPrint = _isDebugPrint {
            return isDebugPrint
        }
        return true // MARK: 預設印出 debug
    }
    private var _isDebugPrint: Bool?
    
    public init(_ any: Any, isDebugPrint: Bool?=nil) {
        _isDebugPrint = isDebugPrint
        if isPrint {
            print(any)
        }
    }
}

// MARK: -
extension Logger {
    
    private static func isDetail() -> Bool {
        return true
    }
    
    static func write(_ any: Any,
                             isDebugPrint: Bool?=nil,
                             file_: String=#file,
                             line_: Int=#line) -> Void {
        
        var str = any
        if isDetail() {
//            let pattern = "%@ [%@][line: %d]"
//            let datetimeStr = String(format: "%@ %@", Date().shortDate, Date().longTime)
//            let prefixStr = String(format: pattern
//                                   , datetimeStr
//                                   , (file_ as NSString).lastPathComponent
//                                   , line_
//            )
            let prefixStr = currentPositionInCodes(file_: file_, line_: line_)
            str = "\(prefixStr) \(any)"
        }
        
        let _ = Logger(str, isDebugPrint: isDebugPrint)
    }
    
    public static func currentPositionInCodes(file_: String=#file
                                              , line_: Int=#line) -> String {
        let pattern = "%@ [%@][line: %d]"
        let datetimeStr = String(format: "%@ %@", Date().shortDate, Date().longTime)
        return String(format: pattern
                      , datetimeStr
                      , (file_ as NSString).lastPathComponent
                      , line_)
    }
}
typealias log = Logger
