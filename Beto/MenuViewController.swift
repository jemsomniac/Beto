//
//  MenuViewController.swift
//  Beto
//
//  Created by Jem on 3/10/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import UIKit
import SpriteKit
import iAd
import GoogleMobileAds

class MenuViewController: UIViewController, ADBannerViewDelegate {
    var scene: MenuScene!
    var board: Board!
    
    @IBOutlet var adBannerView: ADBannerView?
    @IBOutlet var gAdBannerView: GADBannerView!
    
    
    @IBAction func unwindFromGameViewController(segue: UIStoryboardSegue) {
    
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.AllButUpsideDown
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Configure the view.
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = MenuScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        // Present the scene.
        skView.presentScene(scene)
        
        self.canDisplayBannerAds = true
        adBannerView?.delegate = self
        self.gAdBannerView.hidden = true
        
        // DELETE
        print("menu")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // DELETE
        print("got back safely")
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let boardScene = sender as? BoardScene {
            if segue.identifier == "showGameScene" {
                let destinationVC = segue.destinationViewController as! GameViewController
                destinationVC.boardScene = boardScene
            }
        }
    }
    

    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        //Switches to AdMob when iAd fails:
        
        //GAD Info: Ad unit name: BottomBanner
        //GAD Info: Ad unit ID: ca-app-pub-2442145650959654/8984886127
        
        
        adBannerView?.hidden = true
        gAdBannerView.hidden = false
        gAdBannerView.adUnitID = "ca-app-pub-2442145650959654/8984886127"
        gAdBannerView.rootViewController = self
        gAdBannerView.loadRequest(GADRequest())
        
        
    }
    
    
}
