//
//  ViewController.swift
//  Expanding Image Zoom
//
//  Created by Shaver, Kyle J on 1/20/16.
//  Copyright © 2016 Kyle Shaver. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var bigPicture : UIImageView!
    @IBOutlet weak var faderBG : UIView!
    @IBOutlet weak var smallPicture: UIImageView!
    
    var tempFrame: CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func processPan(sender: UIPanGestureRecognizer) {
        adjustAnchorPoint(sender)
        if sender.state == .Began || sender.state == .Changed {
            let view = sender.view!
            let translation = sender.translationInView(view.superview!)
            view.center = CGPointMake(view.center.x + translation.x, view.center.y + translation.y)
            sender.setTranslation(CGPointZero, inView: view.superview!)
        }
    }
    
    @IBAction func processPinch(sender: UIPinchGestureRecognizer) {
        adjustAnchorPoint(sender)
        if sender.state == .Began || sender.state == .Changed {
            bigPicture.transform = CGAffineTransformScale(sender.view!.transform, sender.scale, sender.scale)
            sender.scale = 1
        }
    }
    
    @IBAction func processTap(sender: UITapGestureRecognizer) {
        if sender.view! == smallPicture {
            tempFrame = bigPicture.frame
            bigPicture.frame = smallPicture.frame
            bigPicture.alpha = 1
            UIView.animateWithDuration(0.5) { () -> Void in
                self.bigPicture.frame = self.tempFrame!
                self.faderBG.alpha = 1
            }
        }
    }
    
    @IBAction func processFaderTap(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.faderBG.alpha = 0
            self.bigPicture.frame = self.smallPicture.frame
            }, completion: { (complete: Bool) -> Void in
                if complete {
                    self.bigPicture.transform = CGAffineTransformIdentity
                    self.bigPicture.alpha = 0
                    self.bigPicture.frame = self.tempFrame!
                    self.tempFrame = nil
                }
        })
    }
    
    func adjustAnchorPoint(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .Began {
            let view = gestureRecognizer.view!
            let locationInView = gestureRecognizer.locationInView(view)
            let locationInSuperview = gestureRecognizer.locationInView(view.superview)
            view.layer.anchorPoint = CGPointMake(locationInView.x/view.bounds.size.width, locationInView.y/view.bounds.size.height)
            view.center = locationInSuperview
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

