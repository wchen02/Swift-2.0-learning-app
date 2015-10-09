//
//  GoogleAdCollectionViewCell.swift
//  test
//
//  Created by Wensheng Chen on 10/8/15.
//  Copyright (c) 2015 nluo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class GoogleAdCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bannerView: DFPBannerView!
    var isLoaded = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        println("GoogleAdCollectionViewCell init: Google Mobile Ads SDK version: " + DFPRequest.sdkVersion())
    }
    
    func setup(rootViewController: UIViewController, delegate: GADBannerViewDelegate) {
        println("GoogleAdCollectionViewCell setup")
        bannerView.adUnitID = "/6499/example/banner"
        bannerView.rootViewController = rootViewController
        bannerView.delegate = delegate
        
        var request = DFPRequest()
        request.testDevices = [ kGADSimulatorID ];
        bannerView.loadRequest(request)
        isLoaded = true
    }
}
