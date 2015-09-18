//
//  ViewController.swift
//  DFPNaiveContentAdInTableViewCellSample
//
//  Created by Osamu Nishiyama on 2015/09/17.
//  Copyright (c) 2015年 ever sense. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UITableViewController,GADAdLoaderDelegate,
    GADNativeContentAdLoaderDelegate
{
    
    let firstAdsPositionInCells = 3
    let frequencyAdsInCells = 10
    var adLoader : GADAdLoader!
    var nativeContentAdView : GADNativeContentAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //DFP
        self.adLoader = GADAdLoader(adUnitID: "/6499/example/native", rootViewController: self, adTypes: [kGADAdLoaderAdTypeNativeContent], options: [])
        self.adLoader.delegate = self
        let request = DFPRequest()
        request.testDevices = [ kGADSimulatorID ]
        self.adLoader.loadRequest(request)
        
        
        nativeContentAdView = UINib(nibName: "NativeContentAdView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! GADNativeContentAdView
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func adLoader(adLoader: GADAdLoader!, didFailToReceiveAdWithError error: GADRequestError!) {
    }
    
    func adLoader(adLoader: GADAdLoader!, didReceiveNativeContentAd nativeContentAd: GADNativeContentAd!) {
        nativeContentAdView.nativeContentAd = nativeContentAd
        (nativeContentAdView.headlineView as! UILabel).text = nativeContentAd.headline
        (nativeContentAdView.bodyView as! UILabel).text = nativeContentAd.body
        if let nativeAdImage = nativeContentAd!.images.first as? GADNativeAdImage {
            (nativeContentAdView.imageView as! UIImageView).image = nativeAdImage.image
        }
        
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->  UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        
        let isAdsPosition = (indexPath.row % frequencyAdsInCells - firstAdsPositionInCells) == 0
        
        if isAdsPosition && self.nativeContentAdView.nativeContentAd != nil {
            nativeContentAdView.frame = cell.contentView.frame
            cell.contentView.addSubview(nativeContentAdView)
        }else{
            if self.nativeContentAdView.isDescendantOfView(cell.contentView) {
                nativeContentAdView.removeFromSuperview()
            }
            cell.textLabel?.text = indexPath.row.description
        }
        return cell
    }
    
    
}
