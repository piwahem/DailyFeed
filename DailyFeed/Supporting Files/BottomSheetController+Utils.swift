//
//  BottomSheetController+Utils.swift
//  DailyFeed
//
//  Created by Admin on 3/24/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func += (lhs: inout CGPoint, rhs: CGPoint) {
        lhs = CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

public extension UIViewController {
    var bottomSheetController: BottomSheetController? {
        return parent as? BottomSheetController
    }
}

extension UIPanGestureRecognizer {
    var direction: BottomSheetPanDirection {
        return velocity(in: view).y < 0 ? .up : .down
    }
    
    var touchPoint: CGPoint {
        return location(in: view)
    }
}
