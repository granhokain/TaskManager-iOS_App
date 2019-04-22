//
//  UIColor+TaskManagerColors.swift
//  TaskManager
//
//  Created by Rafael Martins on 22/04/19.
//  Copyright © 2019 Rafael Martins. All rights reserved.
//

import UIKit

//Extensão com as configurações de cores dos componentes do app
extension UIColor {
    
    class func backgroundColor() -> UIColor {
        return UIColor(red: 86.0/255.0, green: 149.0/255.0, blue: 211.0/255.0, alpha: 1.0)
    }
    
    class func frontColor() -> UIColor {
        return UIColor(red: 97.0/255.0, green: 167.0/255.0, blue: 232.0/255.0, alpha: 1.0)
    }
    
    class func cellFontColor() -> UIColor {
        return UIColor.white
    }
    
    class func completedTaskColor() -> UIColor {
        return UIColor(red: 90.0/255.0, green: 209.0/255.0, blue: 127.0/255.0, alpha: 1.0)
    }
    
    class func deletedTaskColor() -> UIColor {
        return UIColor(red: 236.0/255.0, green: 109.0/255.0, blue: 99.0/255.0, alpha: 1.0)
    }
    
}
