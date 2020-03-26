//
//  UILabel+Extension.swift
//  DailyFeed
//
//  Created by Admin on 2/16/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import Foundation
import UIKit

extension UILabel{
    
    func embedIcon(image: UIImage){
        //Create Attachment
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = image
        //Set bound to reposition
        let imageOffsetY:CGFloat = -4.0;
        let width = imageAttachment.image!.size.width
        let height = imageAttachment.image!.size.height
        let ratio = width / height
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: 20, height: 20)
        //Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        //Initialize mutable string
        let completeText = NSMutableAttributedString(string: "")
        //Add image to mutable string
        completeText.append(attachmentString)
        //Add your text to mutable string
        let  textAfterIcon = NSMutableAttributedString(string: " \(text ?? "")")
        completeText.append(textAfterIcon)
        self.textAlignment = .center;
        self.attributedText = completeText;
    }
}
