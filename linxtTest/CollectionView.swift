//
//  CollectionView.swift
//  linxtTest
//
//  Created by AHITM01 on 31.03.22.
//

import UIKit

class CollectionView: UICollectionView {
    override func draw(_ rect: CGRect) {
        if let subview = self.subviews[0] as? UIDrawView{
            subview.draw(rect);
        }
    }
    
    func drawLine(from: CGPoint, to: CGPoint, player: Int) {
        if let subview = self.subviews[0] as? UIDrawView{
            subview.drawLine(from: from, to: to, player: player)
        }
        setNeedsDisplay()
    }
    

}
