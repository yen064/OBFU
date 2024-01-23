//
//  OBFUError.swift
//  OBFU
//
//  Created by aaron on 2024/1/23.
//

import Foundation

enum OBFUError {
case workPathNotExist
}

extension OBFUError: CustomStringConvertible {
    var description: String {
        var strArray: [String] = []
        return strArray.joined(separator: "\n")
    }
}
