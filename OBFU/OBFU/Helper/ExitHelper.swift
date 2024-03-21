//
//  Exit.swift
//  OBFU
//
//  Created by aaron on 2024/1/22.
//

import Foundation

func exit(error: Error? = nil) -> Never {
    sleep(1)
    if let err = error as? NSError {
        let code = Int32(err.code)
        exit(code)
    } else {
        exit(0)
    }
}
