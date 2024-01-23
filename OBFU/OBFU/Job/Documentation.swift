//
//  Documentation.swift
//  OBFU
//
//  Created by aaron on 2024/1/23.
//

import Foundation

final class Documentation: NSObject {
    override var description: String {
        var strArray: [String] = ["OBFU"]
        strArray.append("\n")
        strArray.append(String(format: "workPath: -%@ -%@",
                               Cmd.workPath.commandKey.longkey,
                               Cmd.workPath.commandKey.shortkey))
        return strArray.joined()
    }
}
