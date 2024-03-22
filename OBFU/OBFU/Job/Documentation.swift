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
        log.write(documentation)
    }
    override var description: String {
        var strArray: [String] = []
        strArray.append("OBFU v0.0.1\n")
        strArray.append("command/agurment list\n")
        strArray.append(String(format: " - work path: [-%@/-%@], 指定混淆的路徑, 未指定則預設使用指令當前路徑 [./] \n",
                               Cmd.workPath.commandKey.longkey,
                               Cmd.workPath.commandKey.shortkey))
        strArray.append(String(format: " - report path: [-%@/-%@], 產出混淆後的對應資訊報告檔案路徑, 未指定則為當前 OBFU 執行路徑 \n",
                               Cmd.reportPath.commandKey.longkey,
                               Cmd.reportPath.commandKey.shortkey))
        strArray.append(String(format: " - encrypt key: [-%@/-%@], 混淆的 key, 未指定則預設為 1.0.0 \n",
                               Cmd.encryptKey.commandKey.longkey,
                               Cmd.encryptKey.commandKey.shortkey))
        strArray.append(String(format: " - tag: [-%@/-%@], 混淆搜尋的後綴詞, 把你要混淆的 class name 的後面加上此後綴詞, OBFU 會幫你搜尋出來並且變成亂碼. 未指定則 tag 預設為 __obfu \n",
                               Cmd.tag.commandKey.longkey,
                               Cmd.tag.commandKey.shortkey))
        //        strArray.append(String(format: " - printSelf: [-%@/-%@], 印出自己 (Obfuscator 物件) \n",
        //                               Cmd.printSelf.commandKey.longkey,
        //                               Cmd.printSelf.commandKey.shortkey))
        return strArray.joined()
    }
}
