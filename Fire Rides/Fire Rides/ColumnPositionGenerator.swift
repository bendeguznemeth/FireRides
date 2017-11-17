//
//  ColumnPositionGenerator.swift
//  Fire Rides
//
//  Created by Németh Bendegúz on 2017. 11. 06..
//  Copyright © 2017. Németh Bendegúz. All rights reserved.
//

import UIKit

struct ColumnPositionGenerator {
    
    private static let maximumChange = 120
    
    private static var goingUp = true
    
    private static var currentChange = 0
    
    private static var changeCount = 10
    
    private static var previousDifference = 0
    
    private static var next10Results = [-500, -500, -500, -500, -500, -500, -500, -500, -500, -500]
    
    static func updatePosition() -> CGFloat {
        
        changeCount += 1
        if changeCount >= 10 {
            
            if next10Results[0] < next10Results[9] {
                previousDifference = next10Results[9] - next10Results[0]
                for x in 0...9 {
                    next10Results[x] += previousDifference
                }
                currentChange = Int(arc4random_uniform(UInt32(maximumChange) + 1))
                var changes = [Int]()
                for _ in 0...9 {
                    changes.append(Int(arc4random_uniform(101)))
                }
                var changesSum = 0
                for x in changes {
                    changesSum += x
                }
                for x in 0...9 {
                    changes[x] = Int(Double(changes[x]) / Double(changesSum) * Double(currentChange))
                }
                for x in 0...9 {
                    var tempForChage = 0
                    for y in 0...x {
                        tempForChage += changes[y]
                    }
                    next10Results[x] -= tempForChage
                }
            } else if next10Results[0] > next10Results[9] {
                previousDifference = next10Results[0] - next10Results[9]
                for x in 0...9 {
                    next10Results[x] -= previousDifference
                }
                currentChange = Int(arc4random_uniform(UInt32(maximumChange) + 1))
                var changes = [Int]()
                for _ in 0...9 {
                    changes.append(Int(arc4random_uniform(101)))
                }
                var changesSum = 0
                for x in changes {
                    changesSum += x
                }
                for x in 0...9 {
                    changes[x] = Int(Double(changes[x]) / Double(changesSum) * Double(currentChange))
                }
                for x in 0...9 {
                    var tempForChage = 0
                    for y in 0...x {
                        tempForChage += changes[y]
                    }
                    next10Results[x] += tempForChage
                }
            }
            
            currentChange = Int(arc4random_uniform(UInt32(maximumChange) + 1))
            changeCount = 0
            
            if arc4random_uniform(2) == 0 {
                goingUp = true
            } else {
                goingUp = false
            }
            
            var changes = [Int]()
            for _ in 0...9 {
                changes.append(Int(arc4random_uniform(101)))
            }
            var changesSum = 0
            for x in changes {
                changesSum += x
            }
            for x in 0...9 {
                changes[x] = Int(Double(changes[x]) / Double(changesSum) * Double(currentChange))
            }
            
            if goingUp {
                for x in 0...9 {
                    var tempForChage = 0
                    for y in 0...x {
                        tempForChage += changes[y]
                    }
                    next10Results[x] += tempForChage
                }
            } else {
                for x in 0...9 {
                    var tempForChage = 0
                    for y in 0...x {
                        tempForChage += changes[y]
                    }
                    next10Results[x] -= tempForChage
                }
            }
            
        }
        
        return CGFloat(next10Results[changeCount])
        
    }
    
    static func reset() {
        changeCount = 10
        next10Results = [-500, -500, -500, -500, -500, -500, -500, -500, -500, -500]
    }
    
}

