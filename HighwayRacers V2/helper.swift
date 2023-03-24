//
//  helper.swift
//  HighwayRacers V2
//
//  Created by Matthew Twigg on 6/3/21.
//  Copyright © 2021 Matthew Twigg. All rights reserved.
//

import Foundation
import UIKit

struct ColliderType{
    static let CAR_COLLIDER : UInt32 = 0
    static let ITEM_COLLIDER : UInt32 = 1
    
}
class Helper: NSObject{
    func randomBetweenTwoNumbers(firstNumber : CGFloat, secondNumber : CGFloat) -> CGFloat{
        return CGFloat(arc4random())/CGFloat(UINT32_MAX) * abs(firstNumber - secondNumber) + min(firstNumber, secondNumber)
    }
}
