//
//  Command.swift
//  OBFU
//
//  Created by aaron on 2024/1/22.
//

import Foundation

enum Command {
    
    static var isAnyCommandLineArg: Bool {
        return CommandLine.arguments.count > 1
    }
    
    case help
    case workPath
    case encryptKey
    case tag
    case printSelf
    case unknown
    
    var VALUE: String? {
        if let v = UserDefaults.standard.string(forKey: commandKey.longkey) {
            return v
        }
        if let v = UserDefaults.standard.string(forKey: commandKey.shortkey) {
            return v
        }
        return nil
    }
    var USE: Bool {
        if CommandLine.arguments.contains("-\(commandKey.longkey)") {
            return true
        }
        if CommandLine.arguments.contains("-\(commandKey.shortkey)") {
            return true
        }
        return false
    }
    
    var commandKey: (longkey: String, shortkey: String) {
        switch self {
        case .help:
            return (longkey: "help", shortkey: "h")
        case .workPath:
            return (longkey: "path", shortkey: "p")
        case .encryptKey:
            return (longkey: "key", shortkey: "k")
        case .tag:
            return (longkey: "tag", shortkey: "tag")
        case .printSelf:
            return (longkey: "printSelf", shortkey: "ps")
        default:
            return (longkey: "unknown", shortkey: "unknown")
        }
    }
    
}

typealias Cmd = Command
