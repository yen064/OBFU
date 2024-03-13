//
//  OBFUError.swift
//  OBFU
//
//  Created by aaron on 2024/1/23.
//

import Foundation

enum OBFUError: Error {
case workPathNotExist
case convertIssue
}

extension OBFUError: CustomStringConvertible {
    var description: String {
        var strArray: [String] = []
        strArray.append("OBFUError")
        return strArray.joined(separator: "\n")
    }
}
