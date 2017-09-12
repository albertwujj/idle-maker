//
//  Game.swift
//  Idle Game Maker
//
//  Created by Albert Wu on 9/4/17.
//  Copyright © 2017 Old Friend. All rights reserved.
//

import UIKit
import os.log


class Game: NSObject, NSCoding {
    
    
    //MARK: Properties
    var name: String!
    var currencyName: String!
    var photo: UIImage!
    

    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("game")
    
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let currencyName = "currencyName"

    }
    
    //MARK: Initialization
    init?(name: String) {
        self.name = name
        
    }
    
    
    convenience init?(name: String, photo: UIImage?) {
        self.init(name: name)
        self.photo = photo
    }
    convenience init?(name: String, currencyName: String) {
        self.init(name: name)
        self.currencyName = currencyName
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        if let photoToCode = photo {
            aCoder.encode(photoToCode, forKey: PropertyKey.photo)
        }
        aCoder.encode(currencyName, forKey: PropertyKey.currencyName)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("unable to decode name for Building Object", log: .default, type: .debug)
            return nil
        }
        guard let currencyName = aDecoder.decodeObject(forKey: PropertyKey.currencyName) as? String else {
            os_log("unable to decode currencyName for Building Object", log: .default, type: .debug)
            return nil
        }
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        if let initPhoto = photo {
            self.init(name: name, photo: initPhoto)
            self.currencyName = currencyName
        }
        else {
            self.init(name: name, currencyName: currencyName)
        }
    }
    
}
