//
//  ManualHelper.swift
//  OBFU
//
//  Created by aaron on 2024/1/23.
//

import Foundation

final class Manual: NSObject {
    override var description: String {
        var strArray: [String] = ["OBFU"]
        strArray.append("\n")
        strArray.append(String(format: "workPath: -%@ -%@",
                               COMMAND.workPath.commandKey.longkey,
                               COMMAND.workPath.commandKey.shortkey))
        return strArray.joined()
    }
}
