//
//  ISourceRouter.swift
//  DailyFeed
//
//  Created by Admin on 11/5/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import UIKit

protocol ISourceRouter {
    func passDataToNews()
}

class SourceRouter: ISourceRouter {
    
    weak var viewController: NewsSourceViewController!
    
    func passDataToNews(){
        viewController.performSegue(withIdentifier: "sourceUnwindSegue", sender: viewController)
    }
}
