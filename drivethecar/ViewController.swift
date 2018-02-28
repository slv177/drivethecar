//
//  ViewController.swift
//  drivethecar
//
//  Created by SS on 27/02/2018.
//  Copyright © 2018 SS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var starship = UILabel()
    var meteorite = UILabel()
    var animator = UIDynamicAnimator()
    var animatorM = UIDynamicAnimator()
    var pushBehavior = UIPushBehavior()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(true)
        createGestureRecogniser()
        createStarship()
        createAnimationsAndBehabiors()
        createMeterite()
        createCollisionM()
    
    }
    
    //описываем корабль
    func createStarship() {
        starship = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 15))
        starship.center = view.center
        //starship.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let starshipImage = "🛸"
        let strokeTextAttributes = [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 50)
            ] as [NSAttributedStringKey : Any]
        starship.attributedText = NSAttributedString(string: starshipImage, attributes: strokeTextAttributes)
        view.addSubview(starship)
    }
    
    
    //описываем метеорит
    func createMeterite() {
        meteorite = UILabel(frame: CGRect(x: 100, y: 150, width: 60, height: 40))
        let meteoriteImage = "☄️"
        //meteorite.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let strokeTextAttributes = [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 50)
            ] as [NSAttributedStringKey : Any]
        meteorite.attributedText = NSAttributedString(string: meteoriteImage, attributes: strokeTextAttributes)
        view.addSubview(meteorite)
    }
    
    //описываем жест
    func createGestureRecogniser(){
         let tapGestuerRecognizer = UITapGestureRecognizer(target: self, action: #selector(handler))
        view.addGestureRecognizer(tapGestuerRecognizer)
    }
    
    func createAnimationsAndBehabiors() {
        animator = UIDynamicAnimator(referenceView: view)
        let collision = UICollisionBehavior(items: [starship]) //чтоб не вылетело за пределы экрана
        collision.translatesReferenceBoundsIntoBoundary = true

        pushBehavior = UIPushBehavior(items:[starship], mode: .continuous)
        animator.addBehavior(collision)
        animator.addBehavior(pushBehavior)
    }
    
    func createCollisionM() {
        animatorM = UIDynamicAnimator(referenceView: view)
        let collisionM = UICollisionBehavior(items: [meteorite])
        collisionM.addItem(starship)
        //collisionM.translatesReferenceBoundsIntoBoundary = true
        animatorM.addBehavior(collisionM)
        animator.addBehavior(collisionM)
    }
    
    @objc func handler (paramTap: UITapGestureRecognizer) {
        let tapPoint: CGPoint = paramTap.location(in: view)
        let squareCenterPoint: CGPoint = starship.center
        
        let deltaX: CGFloat = tapPoint.x - squareCenterPoint.x
        let deltaY: CGFloat = tapPoint.y - squareCenterPoint.y
        let angle: CGFloat = atan2(deltaY, deltaX)
        pushBehavior.angle = angle
        let distanceBetveenPins: CGFloat = sqrt(pow(tapPoint.x - squareCenterPoint.x, 2.0) + pow(tapPoint.y - squareCenterPoint.y, 2.0))
        pushBehavior.magnitude = distanceBetveenPins / 1000
    }
 }

extension ViewController: UICollisionBehaviorDelegate {
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        let identifier = identifier as? String
        let kBottomBoundary = "bottomBoundary"
        if identifier == kBottomBoundary {
            UIView.animate(withDuration: 1.0, animations: {
                let view = item as? UIView
                view?.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                view?.alpha = 0.0
                view?.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            }, completion: {(finished) in
                let view = item as? UIView
                behavior.removeItem(item)
                view?.removeFromSuperview()
            })
            
        }
    }
}




