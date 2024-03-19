//
//  Documentation.swift
//  OBFU
//
//  Created by aaron on 2024/1/23.
//

import Foundation

final class Documentation: NSObject {
    static func dump() {
        let documentation = Documentation()
        print(documentation)
    }
    override var description: String {
        var strArray: [String] = []
        strArray.append("OBFU 程式碼混淆器 v0.0.1\n")
        strArray.append("command/agurment list\n")
        strArray.append(String(format: " - workPath: [-%@/-%@], 指定路徑, 未指定則預設使用指令當前路徑 [./] \n",
                               Cmd.workPath.commandKey.longkey,
                               Cmd.workPath.commandKey.shortkey))
        strArray.append(String(format: " - printSelf: [-%@/-%@], 印出自己 (Obfuscator 物件) \n",
                               Cmd.printSelf.commandKey.longkey,
                               Cmd.printSelf.commandKey.shortkey))
        return strArray.joined()
    }
}
