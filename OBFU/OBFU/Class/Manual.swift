//
//  ManualHelper.swift
//  OBFU
//
//  Created by aaron on 2024/1/23.
//

import Foundation

final class Manual: NSObject {
    override var description: String {
        var strArray: [String] = [super.description]
        strArray.append("some shit")
        return strArray.joined()
    }
}
