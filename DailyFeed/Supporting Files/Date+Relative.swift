//
//  Date+Relative.swift
//  DailyFeed
//
//  Created by LittleBiteOfCocoa on 23/01/17.
//  Copyright © littlebitesofcocoa.com. All rights reserved.
//

import Foundation

extension Date {

    func relativelyFormatted(short: Bool) -> String {

        let now = Date()
        let components = Calendar.autoupdatingCurrent.dateComponents([.year,
                                                                      .month,
                                                                      .weekOfYear,
                                                                      .day,
                                                                      .hour,
                                                                      .minute,
                                                                      .second],
                                                                     from: self,
                                                                     to: now)

        if let years = components.year, years > 0 {
            return short ? "time_short_year".localizeWithFormat(arguments: years) :"time_long_year".localizeWithFormat(arguments: years)
        }

        if let months = components.month, months > 0 {
            return short ? "time_short_month".localizeWithFormat(arguments: months) :
            "time_long_month".localizeWithFormat(arguments: months)
        }

        if let weeks = components.weekOfYear, weeks > 0 {
            return short ? "time_short_week".localizeWithFormat(arguments: weeks) :
                "time_long_week".localizeWithFormat(arguments: weeks)
        }

        if let days = components.day, days > 0 {
            return short ? "time_short_day".localizeWithFormat(arguments: days) :
                "time_long_day".localizeWithFormat(arguments: days)
        }

        if let hours = components.hour, hours > 0 {
            return short ? "time_short_hour".localizeWithFormat(arguments: hours) :
                "time_long_hour".localizeWithFormat(arguments: hours)
        }

        if let minutes = components.minute, minutes > 0 {
            return short ? "time_short_minute".localizeWithFormat(arguments: minutes) :
                "time_long_minute".localizeWithFormat(arguments: minutes)
        }

        if let seconds = components.second, seconds > 30 {
            return short ? "time_short_second".localizeWithFormat(arguments: seconds) :
                "time_long_second".localizeWithFormat(arguments: seconds)
        }

        return "Just now".localized
    }
}

extension String {
    var dateFromTimestamp: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let date = dateFormatter.date(from: self)
        return date
    }
    
    var languageStringFromISOCode: String {
        let locale = Locale.current
        guard let languageString = locale.localizedString(forLanguageCode: self) else { return self }
        return languageString
    }
    
    var formattedCountryDescription: String {
        return countryFlagFromCountryCode + " " + countryStringFromCountryCode
    }
    
    var countryStringFromCountryCode: String {
        let locale = Locale.current
        guard let languageString = locale.localizedString(forRegionCode: self) else { return self }
        return languageString
    }
    
    var countryFlagFromCountryCode: String {
        let base : UInt32 = 127397
        var s = ""
        for v in self.uppercased().unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s
    }
    
    var direction: Locale.LanguageDirection {
        return NSLocale.characterDirection(forLanguage: self)
    }
}
