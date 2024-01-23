//
//  Obfuscator.swift
//  OBFU
//
//  Created by aaron on 2024/1/22.
//

import Foundation

final class Obfuscator: NSObject {
    var workPath: String = COMMAND.workPath.VALUE ?? defaultWorkPath()
    var encryptKey: String = COMMAND.encryptKey.VALUE ?? defaultEncryptKey()
    var prefixMark: String = COMMAND.prefixMark.VALUE ?? defaultPrefixMark()
    var suffixMark: String = COMMAND.suffixMark.VALUE ?? defaultSuffixMark()
    override var description: String {
        var strArray: [String] = [super.description]
        strArray.append(String(format: "> workPath: %@", workPath))
        strArray.append(String(format: "> encryptKey: %@", encryptKey))
        strArray.append(String(format: "> prefixMark: %@", prefixMark))
        strArray.append(String(format: "> suffixMark: %@", suffixMark))
        strArray.append(String(format: "> printSelf: %@", COMMAND.printSelf.USE ? "YES" : "NO"))
        strArray.append(String(format: "> encryptKey: %@", encryptKey))
        strArray.append("")
        return strArray.joined(separator: "\n")
    }
    override init() {
        super.init()
        printSelf()
        printHelpAutomatically()
    }
}

extension Obfuscator {
    private func printHelpAutomatically() {
        if COMMAND.isAnyCOMMAND {
            return
        }
        // TODO:
        //  印些什麼
        log.write(Manual())
    }
    private func printSelf() {
        if !COMMAND.printSelf.USE {
            return
        }
        log.write(description)
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
}
