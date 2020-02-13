//
//  BundleExtension.swift
//  DailyFeed
//
//  Created by Admin on 2/13/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
    var appVersion: String{
        guard let releaseVersionNumber = releaseVersionNumber,
            let buildVersionNumber = buildVersionNumber else {
                return ""
        }
        return "Version \(releaseVersionNumber) (\(buildVersionNumber))"
    }
}
