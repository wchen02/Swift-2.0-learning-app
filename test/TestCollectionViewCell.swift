//
//  TestCollectionViewCell.swift
//  test
//
//  Created by nluo on 6/30/15.
//  Copyright (c) 2015 nluo. All rights reserved.
//

import UIKit

class TestCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var abstract: UITextView!
    
    override init(frame: CGRect) {
        image = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height*2/3))
        title = UILabel(frame:  CGRect(x: 0, y: image.frame.size.height, width: frame.size.width, height: frame.size.height/3))
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
