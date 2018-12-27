//
//  Theme.swift
//  RebtelDialConcept
//
//  Created by Tarik Stafford on 22/12/18.
//  Copyright © 2018 Tarik Stafford. All rights reserved.
//

import UIKit

extension UIColor {
    static var forestGreen: UIColor {
        return .rbg(r: 63, g: 204, b: 105)
    }
    
    static var synthPurple: UIColor {
        return .rbg(r: 244, g: 63, b: 202)
    }
    
    class func rbg(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        let color = UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
        return color
    }
}

extension UIFont {
    static var mainHeader: UIFont {
        return UIFont(name: "Avenir", size: 20)!
    }
    
    static var labelHeader: UIFont {
        return UIFont(name: "Avenir-Medium", size: 17)!
    }
    
    static var fontAwesome: UIFont {
       return UIFont(name: "FontAwesome", size: 17)!
    }
}

class Theme {
    // Can init this through App Del for multiple color styles -- light/dark
    static let primaryColor = UIColor.forestGreen
    static let secondaryColor = UIColor.synthPurple
    
    static let headerFont = UIFont.mainHeader
    static let labelHeader = UIFont.labelHeader
    static let fontAwesome = UIFont.fontAwesome
}
