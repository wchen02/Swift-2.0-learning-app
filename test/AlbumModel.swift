//
//  Album.swift
//  test
//
//  Created by nluo on 5/21/15.
//  Copyright (c) 2015 nluo. All rights reserved.
//
import Foundation
import CoreData


class AlbumModel: NSManagedObject {
    
    @NSManaged var title: String
    @NSManaged var price: String
    @NSManaged var thumbnailImageURL: String
    @NSManaged var largeImageURL: String
    @NSManaged var itemURL: String
    @NSManaged var artistURL: String
    //@NSManaged var collectionId: NSNumber
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, name: String, price: String, thumbnailImageURL: String, largeImageURL: String, itemURL: String, artistURL: String, collectionId: Int) -> AlbumModel {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Album", inManagedObjectContext: moc) as! AlbumModel
        newItem.title = name
        newItem.price = price
        newItem.thumbnailImageURL = thumbnailImageURL
        newItem.largeImageURL = largeImageURL
        newItem.itemURL = itemURL
        newItem.artistURL = artistURL
        //newItem.collectionId = NSNumber(long: collectionId)
        
        return newItem
    }
}