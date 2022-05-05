//
//  CellTypes.swift
//  linxtTest
//
//  Created by AHITM01 on 19.04.22.
//

import Foundation
import UIKit

enum Players {
    case neutral
    case player1
    case player2
}

public class GameColors {
    
    public var blueCG: CGColor = CGColor.init(red: CGFloat(0.66), green: CGFloat(0.9), blue: CGFloat(1.0), alpha: CGFloat(1.0))
    public var redCG: CGColor = CGColor.init(red: CGFloat(1.0), green: CGFloat(0.55), blue: CGFloat(0.55), alpha: CGFloat(1.0))
    
    public var blue: UIColor = UIColor.init(red: CGFloat(0.66), green: CGFloat(0.9), blue: CGFloat(1.0), alpha: CGFloat(1.0))
    public var red: UIColor = UIColor.init(red: CGFloat(1.0), green: CGFloat(0.55), blue: CGFloat(0.55), alpha: CGFloat(1.0))
    
    init() {
        blue = UIColor.init(cgColor: blueCG)
        red = UIColor.init(cgColor: redCG)
    }
    
}
