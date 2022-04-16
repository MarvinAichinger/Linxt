

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    var isOccupiedFrom: Int = -1
    var hasConnectionToSide1: Bool = false
    var hasConnectionToSide2: Bool = false
    
    var connectedTo = [CollectionViewCell]()
    
    
    func buildConnectionsTo(cells: [CollectionViewCell]) {
        
        self.connectedTo.append(contentsOf: cells)
        var cells = cells
        
        for cell in cells {
            self.hasConnectionToSide1 = self.hasConnectionToSide1 || cell.hasConnectionToSide1
            self.hasConnectionToSide2 = self.hasConnectionToSide2 || cell.hasConnectionToSide2
            
            if (cell.hasConnectionToSide1 || cell.hasConnectionToSide2) {
                if let index: Int = cells.firstIndex(of: cell) {
                    cells.remove(at: index)
                }
            }
            
            cell.connectedTo.append(self)
        }
        
        if (self.hasConnectionToSide1 && self.hasConnectionToSide2) {
            print("player \(isOccupiedFrom) wins")
            return;
        }
        
        for cell in cells {
            if (self.hasConnectionToSide1) {
                if (!cell.hasConnectionToSide1) {
                    cell.getConnectionTo(side: 1)
                }
            }
            if (self.hasConnectionToSide2) {
                if (!cell.hasConnectionToSide2) {
                    cell.getConnectionTo(side: 2)
                }
            }
        }
        
        
    }
    
    func getConnectionTo(side: Int) {
        if (side == 1) {
            self.hasConnectionToSide1 = true
            
            for cell in connectedTo {
                if (!cell.hasConnectionToSide1) {
                    cell.getConnectionTo(side: 1)
                }
            }
        }
        if (side == 2) {
            self.hasConnectionToSide2 = true
            
            for cell in connectedTo {
                if (!cell.hasConnectionToSide2) {
                    cell.getConnectionTo(side: 2)
                }
            }
        }
    }
}
