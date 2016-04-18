//
//  MaterialTextField.swift
//  Dev Showcase
//
//  Created by Jason Leocata on 11/04/2016.
//  Copyright © 2016 Jason Leocata. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {

    override func awakeFromNib() {
        
        layer.cornerRadius = 3.0
        layer.borderColor = UIColor(red: SHADOW_COLOUR, green: SHADOW_COLOUR, blue: SHADOW_COLOUR, alpha: 0.2).CGColor
        layer.borderWidth = 1.0
        
    }
    
    //For placeholder
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        
        return CGRectInset(bounds, 10, 0)
        
    }
    
    //For editable text
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        
        return CGRectInset(bounds, 10, 0)
    }

}
