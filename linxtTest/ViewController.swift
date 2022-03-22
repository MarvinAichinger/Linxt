//
//  ViewController.swift
//  linxtTest
//
//  Created by Aichinger Marvin on 11.03.22.
//

import UIKit


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        //let size = collectionView.bounds.width / 24
        
        let noOfCellsInRow = 24


        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
        

    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 576
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    
        // Configure the cell
    
        return cell
    }
    
    @IBAction func handlePinch(_ sender: UIPinchGestureRecognizer) {
        
        guard let gestureView = sender.view else {
          return
        }
        
        
        gestureView.transform = gestureView.transform.scaledBy(
          x: sender.scale,
          y: sender.scale
        )
        
        if(gestureView.transform.a < 1){
            gestureView.transform.a = 1
            gestureView.transform.d = 1
        }
        
        if(gestureView.transform.a > 4 ){
            gestureView.transform.a = 4
            gestureView.transform.d = 4
        }
        
        sender.scale = 1
        
    }
    
    
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)

        if let gestureView = sender.view {
                
            gestureView.center = CGPoint(
                x: gestureView.center.x + translation.x,
                y: gestureView.center.y + translation.y
            )

            sender.setTranslation(.zero, in: view)
            
            /*if (self.monkeyImage.frame.intersects(self.bananaImage.frame)) {
                self.bananaImage.center.x = 0
                self.bananaImage.center.y = -10
                incrementCounter()
            }*/
            
            guard sender.state == .ended else {
              return
            }

            let velocity = sender.velocity(in: view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 200


            let slideFactor = 1

            var finalPoint = CGPoint(
                x: gestureView.center.x + (velocity.x * CGFloat(slideFactor)),
                y: gestureView.center.y + (velocity.y * CGFloat(slideFactor))
            )


            finalPoint.x = min(max(finalPoint.x, 0), view.bounds.width)
            finalPoint.y = min(max(finalPoint.y, 0), view.bounds.height)

            
        }
        
    }
    
    
}

