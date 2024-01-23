//
//  StringExt.swift
//  OBFU
//
//  Migrated by aaron on 2024/1/23.
//
//  Created by Bruno Rocha on 1/18/17.
//  Copyright © 2017 Bruno Rocha. All rights reserved.

import Foundation
import CommonCrypto

typealias RegexClosure = ((NSTextCheckingResult) -> String?)

func firstMatch(for regex: String, in text: String) -> String? {
    return matches(for: regex, in: text).first
}

func matches(for regex: String, in text: String) -> [String] {
    do {
        let regex = try NSRegularExpression(pattern: regex)
        let nsString = text as NSString
        let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
        return results.map { nsString.substring(with: $0.range)}
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}

extension String {
    func match(regex: String) -> [NSTextCheckingResult] {
        let regex = try! NSRegularExpression(pattern: regex, options: [.caseInsensitive])
        let nsString = self as NSString
        return regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
    }

    static func random(length: Int, excluding: Set<String>) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let numbers : NSString = "0123456789"
        var randomString = ""
        for i in 0 ..< length {
            let characters: NSString = i == 0 ? letters : letters.appending(numbers as String) as NSString
            let rand = arc4random_uniform(UInt32(characters.length))
            var nextChar = characters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return excluding.contains(randomString) ? random(length: length, excluding: excluding) : randomString
    }
    
    static func random(length: Int, excluding: Set<String>, generator:seededGenerator) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let numbers : NSString = "0123456789"
        var randomString = ""
        var seed = generator
        for i in 0 ..< length {
            let characters: NSString = i == 0 ? letters : letters.appending(numbers as String) as NSString
            let rand = Int.random(in: 0..<characters.length, using: &seed)
            var nextChar = characters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return excluding.contains(randomString) ? random(length: length, excluding: excluding) : randomString
    }
}

extension String {
    static var storyboardClassNameRegex: String {
        return "((?<=customClass=\").*?(?=\" customModule)|(?<=action selector=\").*?(?=:\"))"
    }
}

extension String {
    var trueName: String {
        return components(separatedBy: "(").first ?? self
    }
}

extension String {
    private var spacedFolderPlaceholder: String {
        return "\u{0}"
    }

    var replacingEscapedSpaces: String {
        return replacingOccurrences(of: "\\ ", with: spacedFolderPlaceholder)
    }

    var removingPlaceholder: String {
        return replacingOccurrences(of: spacedFolderPlaceholder, with: " ")
    }
}

extension String {
    var sha256: String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CC_SHA256(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02x", $1) }
    }
    
    var sha1: String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CC_SHA1(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02x", $1) }
    }
}

class seededGenerator : RandomNumberGenerator {
    init(seed:Int){
        srand48(seed)
    }
    
    func next() -> UInt64 {
        return UInt64(drand48() * Double(UInt64.max))
    }
}
