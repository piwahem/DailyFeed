//
//  BottomSheetControllerDelegate.swift
//  DailyFeed
//
//  Created by Admin on 3/24/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import Foundation
import UIKit

@objc
public protocol BottomSheetControllerDelegate: class {
    @objc optional func bottomSheet(bottomSheetController: BottomSheetController,
                                    viewController: UIViewController,
                                    willMoveTo minY: CGFloat,
                                    direction: BottomSheetPanDirection)
    
    @objc optional func bottomSheet(bottomSheetController: BottomSheetController,
                                    viewController: UIViewController,
                                    didMoveTo minY: CGFloat,
                                    direction: BottomSheetPanDirection)
    
    @objc optional func bottomSheet(bottomSheetController: BottomSheetController,
                                    viewController: UIViewController,
                                    animationWillStart targetY: CGFloat,
                                    direction: BottomSheetPanDirection)
    
    @objc optional func bottomSheetAnimationDidStart(bottomSheetController: BottomSheetController,
                                                     viewController: UIViewController)
    
    @objc optional func bottomSheetAnimationDidEnd(bottomSheetController: BottomSheetController,
                                                   viewController: UIViewController)
}
