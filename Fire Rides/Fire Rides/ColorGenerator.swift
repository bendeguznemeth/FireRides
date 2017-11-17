//
//  ColorGenerator.swift
//  Fire Rides
//
//  Created by Németh Bendegúz on 2017. 11. 05..
//  Copyright © 2017. Németh Bendegúz. All rights reserved.
//

import UIKit

enum MainColor {
    case red, green, blue
}

struct ColorGenerator {
    
    private static var result = UIColor(red: 75, green: 75, blue: 255, alpha: 1)
    
    private static let maxSum: CGFloat = 300
    private static let minSum: CGFloat = 150
    private static let updateDifference: CGFloat = 10
    private static var goingUp = true
    
    private static var mainColor: MainColor = .blue {
        didSet {
            switch mainColor {
            case .red:
                result = UIColor(red: 255/255, green: 75/255, blue: 75/255, alpha: 1)
                red = 255
                green = 75
                blue = 75
            case .green:
                result = UIColor(red: 75/255, green: 255/255, blue: 75/255, alpha: 1)
                red = 75
                green = 255
                blue = 75
            case .blue:
                result = UIColor(red: 75/255, green: 75/255, blue: 255/255, alpha: 1)
                red = 75
                green = 75
                blue = 255
            }
        }
    }
    
    private static var red: CGFloat = 75 {
        didSet{
            result = UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
        }
    }
    
    private static var green: CGFloat = 75 {
        didSet{
            result = UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
        }
    }
    private static var blue: CGFloat = 255 {
        didSet{
            result = UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
        }
    }
    
    static func updateSecondaryColors() -> UIColor {
        
        let firstColorDiff = CGFloat(arc4random_uniform(11))
        let secondColorDiff = updateDifference - firstColorDiff
        
        switch mainColor {
        case .red:
            if green + blue <= minSum {
                goingUp = true
            } else if green + blue >= maxSum {
                goingUp = false
            }
            
            if goingUp {
                green += firstColorDiff
                blue += secondColorDiff
            } else {
                green -= firstColorDiff
                blue -= secondColorDiff
            }
            
            return result
            
        case .green:
            if red + blue <= minSum {
                goingUp = true
            } else if red + blue >= maxSum {
                goingUp = false
            }
            
            if goingUp {
                red += firstColorDiff
                blue += secondColorDiff
            } else {
                red -= firstColorDiff
                blue -= secondColorDiff
            }
            
            return result

        case .blue:
            if red + green <= minSum {
                goingUp = true
            } else if red + green >= maxSum {
                goingUp = false
            }
            
            if goingUp {
                red += firstColorDiff
                green += secondColorDiff
            } else {
                red -= firstColorDiff
                green -= secondColorDiff
            }
            
            return result

        }
    }
    
    static func updateMainColor() {
        switch mainColor {
        case .red:
            mainColor = .blue
        case .green:
            mainColor = .red
        case .blue:
            mainColor = .green
        }
    }
    
    static func reset() {
        mainColor = .blue
    }
    
}

