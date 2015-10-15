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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        print("GoogleAdCollectionViewCell init: Google Mobile Ads SDK version: " + DFPRequest.sdkVersion())
    }
    
    func setup(rootViewController: UIViewController, delegate: GADBannerViewDelegate) {
        print("GoogleAdCollectionViewCell setup")
        bannerView.adUnitID = "/6499/example/banner"
        bannerView.rootViewController = rootViewController
        bannerView.delegate = delegate
        
        let request = DFPRequest()

        // Test device IDs
        request.testDevices = [
            kGADSimulatorID, // simulator
            "889d307717479b035cfa484fc30e2119", // ipad
            "259e25d88b78c7f0eec17af92c2499ef" // wensheng's iphone
        ];
        bannerView.loadRequest(request)
        isLoaded = true
    }
}
