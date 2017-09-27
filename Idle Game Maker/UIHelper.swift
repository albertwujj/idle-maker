//
//  UIHelper.swift
//  Idle Game Maker
//
//  Created by Albert Wu on 9/25/17.
//  Copyright © 2017 Old Friend. All rights reserved.
//

import UIKit

class UIHelper {
    static func makeTextAdjusting(label: UILabel) {
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byClipping
        label.baselineAdjustment = .alignCenters
    }
    static func setButtonBorder(button: UIButton) {
        button.contentEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
        button.layer.cornerRadius = 2;
        button.layer.borderWidth = 1;
        button.layer.borderColor = UIColor.blue.cgColor
    }
    static func constrainLabelToProperWidth(label1: UILabel, label2: UILabel) {
        let label1Font = label1.font
        let label2Font = label2.font
        label1.font = label1.font.withSize(20)
        label2.font = label2.font.withSize(20)
        let scale = label2.intrinsicContentSize.width/label1.intrinsicContentSize.width
        NSLayoutConstraint(item: label2, attribute: .width, relatedBy: .equal, toItem: label1, attribute:.width, multiplier: scale, constant:0.0).isActive = true
        label1.font = label1Font
        label2.font = label2Font
    }
}
