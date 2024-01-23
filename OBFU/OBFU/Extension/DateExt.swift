//
//  DateExt.swift
//  OBFU
//
//  Created by aaron on 2024/1/23.
//

import Foundation

//
// reference:
//  https://stackoverflow.com/questions/28332946/how-do-i-get-the-current-date-in-short-format-in-swift
//

extension TimeZone {
    static let gmt = TimeZone(secondsFromGMT: 0)!
}
extension Locale {
    static let zhTW = Locale(identifier: "zh_TW")
}
extension Formatter {
    static let date = DateFormatter()
}
extension Date {
    func localizedDescription(date dateStyle: DateFormatter.Style = .medium,
                              time timeStyle: DateFormatter.Style = .medium,
                              in timeZone: TimeZone = .current,
                              locale: Locale = .current,
                              using calendar: Calendar = .current) -> String {
        Formatter.date.calendar = calendar
        Formatter.date.locale = locale
        Formatter.date.timeZone = timeZone
        Formatter.date.dateStyle = dateStyle
        Formatter.date.timeStyle = timeStyle
        return Formatter.date.string(from: self)
    }
    var localizedDescription: String { localizedDescription() }
}
extension Date {

    var fullDate: String { localizedDescription(date: .full, time: .none) }
    var longDate: String { localizedDescription(date: .long, time: .none) }
    var mediumDate: String { localizedDescription(date: .medium, time: .none) }
    var shortDate: String { localizedDescription(date: .short, time: .none) }

    var fullTime: String { localizedDescription(date: .none, time: .full) }
    var longTime: String { localizedDescription(date: .none, time: .long) }
    var mediumTime: String { localizedDescription(date: .none, time: .medium) }
    var shortTime: String { localizedDescription(date: .none, time: .short) }

    var fullDateTime: String { localizedDescription(date: .full, time: .full) }
    var longDateTime: String { localizedDescription(date: .long, time: .long) }
    var mediumDateTime: String { localizedDescription(date: .medium, time: .medium) }
    var shortDateTime: String { localizedDescription(date: .short, time: .short) }
}

/*
 
 Date().localizedDescription  // "18 Dec 2021 06:43:50"
 Date().localizedDescription(in: .gmt)  // "18 Dec 2021 06:43:50" UTC time
 Date().localizedDescription(date: .short, time: .short)  // "18/12/21 03:43"
 Date().localizedDescription(date: .full, time: .full)  // "Saturday, 18 December 2021 03:43:50 Brasilia Standard Time"
 Date().localizedDescription(date: .full, time: .full, in: .gmt)  // "Saturday, 18 December 2021 06:43:50 Greenwich Mean Time"
 Date().localizedDescription(date: .full, time: .full, locale: .ptBR)  // "sábado, 18 de dezembro de 2021 03:43:50 Horário Padrão de Brasília"
 
 
 print(Date().fullDate)  // "Saturday, 18 December 2021\n"
 print(Date().shortDate)  // "18/12/21\n"

 print(Date().fullTime)  // "03:43:50 Brasilia Standard Time\n"
 print(Date().shortTime)  // "03:43\n"

 print(Date().fullDateTime)  // "Saturday, 18 December 2021 03:43:50 Brasilia Standard Time\n"
 print(Date().shortDateTime)  // "18/12/21 03:43\n"
 
 */
