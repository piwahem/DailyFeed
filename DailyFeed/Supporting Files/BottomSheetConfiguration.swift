//
//  BottomSheetConfiguration.swift
//  DailyFeed
//
//  Created by Admin on 3/24/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import Foundation
import UIKit

public protocol BottomSheetConfiguration {
    // MARK: - Properties
    var initialY                        : CGFloat           { get }
    var minYBound                       : CGFloat           { get }
    var maxYBound                       : CGFloat           { get }
    var automaticallyAdjustSheetSize    : Bool              { get }
    var allowsContentScrolling          : Bool              { get set }
    var scrollableView                  : UIScrollView?     { get }

    // MARK: - Methods
    func canMoveTo(_ y: CGFloat) -> Bool
    func nextY(from currentY: CGFloat,
        panDirection direction: BottomSheetPanDirection) -> CGFloat
}

// MARK: - Properties Default implementation
public extension BottomSheetConfiguration {
    var initialY: CGFloat {
        return minYBound
    }
    
    var minYBound: CGFloat {
        return 20
    }
    
    var maxYBound: CGFloat {
        return UIScreen.main.bounds.height - 200
    }
    
    var automaticallyAdjustSheetSize: Bool {
        return true
    }
    
    var scrollableView: UIScrollView? {
        return nil
    }
    
    func canMoveTo(_ y: CGFloat) -> Bool {
        return y >= minYBound && y <= maxYBound
    }
}

// MARK: - Helper Methods
extension BottomSheetConfiguration {
    func sizeOf(sheetView view: UIView) -> CGSize {
        return sizeFor(y: view.frame.minY)
    }
    
    func sizeFor(y: CGFloat) -> CGSize {
        let screenBounds = UIScreen.main.bounds
        guard automaticallyAdjustSheetSize else {
            return screenBounds.size
        }
        
        let width   = screenBounds.width
        let height  = screenBounds.height - y
        return CGSize(width: width, height: height)
    }
}
