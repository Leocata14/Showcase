//
//  MaterialButton.swift
//  Dev Showcase
//
//  Created by Jason Leocata on 11/04/2016.
//  Copyright © 2016 Jason Leocata. All rights reserved.
//

import UIKit

class MaterialButton: UIButton {

    override func awakeFromNib() {
        
        layer.cornerRadius = 3.0
        layer.shadowColor = UIColor(red: SHADOW_COLOUR, green: SHADOW_COLOUR, blue: SHADOW_COLOUR, alpha: 0.5).CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
        
    }

}
