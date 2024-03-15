//
//  Obfuscator.swift
//  OBFU
//
//  Created by aaron on 2024/1/22.
//

import Foundation
enum ObfuscateMode: String {
    case reflect = "reflect"
    case file = "file"
    static var defaultRawValue: String {
        return ObfuscateMode.reflect.rawValue
    }
}
final class Obfuscator: NSObject {
    var workPath: String = Cmd.workPath.VALUE ?? defaultWorkPath()
    var encryptKey: String = Cmd.encryptKey.VALUE ?? defaultEncryptKey()
    var prefixMark: String = Cmd.prefixMark.VALUE ?? defaultPrefixMark()
    var suffixMark: String = Cmd.suffixMark.VALUE ?? defaultSuffixMark()
    var mode: ObfuscateMode = getObfuscateMode()
    
    // MARK: - override
    override var description: String {
        var strArray: [String] = [super.description]
        strArray.append(String(format: "> workPath: %@", workPath))
        strArray.append(String(format: "> encryptKey: %@", encryptKey))
        strArray.append(String(format: "> prefixMark: %@", prefixMark))
        strArray.append(String(format: "> suffixMark: %@", suffixMark))
        strArray.append(String(format: "> printSelf: %@", Cmd.printSelf.USE ? "YES" : "NO"))
        strArray.append(String(format: "> mode: %@", mode.rawValue))
        strArray.append("")
        return strArray.joined(separator: "\n")
    }
    override init() {
        super.init()
        printDocumentationAutomatically()
        printSelf()
    }
    deinit {
        
    }
}

// MARK: -
extension Obfuscator {
    func run() {
        
        CryptoHelper.test()
        TextMiner.test()
        
        if mode == .reflect {
            
        }
        if mode == .file {
            
            let a = "abcdefg"
//            let b = a.randomElement(using: &<#T##RandomNumberGenerator#>)  // .random(length: <#T##Int#>, excluding: <#T##Set<String>#>)
            
        }
    }
}

// MARK: - private
extension Obfuscator {
    private func printDocumentationAutomatically() {
        if Cmd.isAnyCommandLineArg && !Cmd.help.USE {
            return
        }
        // TODO:
        //  印些什麼
        Documentation.dump()
    }
    private func printSelf() {
        if !Cmd.printSelf.USE {
            return
        }
        log.write(self)
    }
}

// MARK: - default (static)
extension Obfuscator {
    static func defaultEncryptKey() -> String {
        return "1.0.0"
    }
    static func defaultWorkPath() -> String {
        return FileManager.default.currentDirectoryPath
    }
    static func defaultPrefixMark() -> String {
        return "OB__"
    }
    static func defaultSuffixMark() -> String {
        return "__FU"
    }
    static func defaultMode() -> ObfuscateMode {
//        return .reflect
        return .file
    }
    static func getObfuscateMode() -> ObfuscateMode {
        guard
            let VALUE = Cmd.mode.VALUE,
            let MODE = ObfuscateMode(rawValue: VALUE)
        else {
            return defaultMode()
        }
        return MODE
    }
}
