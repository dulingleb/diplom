//
//  Date + Start End of Month.swift
//  diplom
//
//  Created by Dulin Gleb on 3.2.24..
//

import Foundation

extension Date {
    var startOfMonth: Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self)) else {
            fatalError("Unable to get start date from date")
        }
        return date
    }

    var endOfMonth: Date {
        guard let date = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth) else {
            fatalError("Unable to get end date from date")
        }
        return date
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}
