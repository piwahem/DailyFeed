//
//  OnActionInfoListener.swift
//  DailyFeed
//
//  Created by Admin on 2/20/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import Foundation

protocol OnActionInfoListener {
    func onSendEmail(toUser: String)
    func onCallNumber()
}
