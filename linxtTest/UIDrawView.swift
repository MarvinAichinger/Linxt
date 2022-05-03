//
//  UIDrawView.swift
//  linxtTest
//
//  Created by Tikautz Gregor on 26.04.22.
//

import UIKit

class UIDrawView: UIView {
    
    var linesPlayer0: [(CGPoint, CGPoint)] = [(CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0))]
    var linesPlayer1: [(CGPoint, CGPoint)] = [(CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0))]
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        
        //Player 0
        var path = UIBezierPath()
        
        for line in linesPlayer0 {
            path.move(to: line.0)
            path.addLine(to: line.1)
        }
        
        path.close()
        
        UIColor.blue.set()
        path.lineWidth = 4
        path.stroke()
        
        //Player 1
        path = UIBezierPath()
        
        for line in linesPlayer1 {
            path.move(to: line.0)
            path.addLine(to: line.1)
        }
        
        path.close()
        
        UIColor.red.set()
        path.lineWidth = 4
        path.stroke()
    }
    
    func drawLine(from: CGPoint, to: CGPoint, player: Int) {
        if (player == 0) {
            linesPlayer0.append((from, to))
        }else if (player == 1) {
            linesPlayer1.append((from, to))
        }
        setNeedsDisplay()
    }

}
