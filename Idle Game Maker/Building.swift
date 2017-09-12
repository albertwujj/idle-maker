//
//  Building.swift
//  Idle Game Maker
//
//  Created by Albert Wu on 9/2/17.
//  Copyright © 2017 Old Friend. All rights reserved.
//

import UIKit
import os.log


class Building: NSObject, NSCoding {
    
    
    //MARK: Properties
    var name: String?
    var photo: UIImage?
    
    var initialCost: String!
    var cps: String!
    var percentCostIncrease: Double = 15.0
    
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("building")
    
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let initialCost = "initialCost"
        static let cps = "cps"
        static let percentCostIncrease = "percentCostIncrease"
    }
    
    //MARK: Initialization
    init?(name: String, initialCost: String, cps: String) {
        self.name = name
        self.initialCost = initialCost
        self.cps = cps
       
    }
    
    
    convenience init?(name: String, photo: UIImage?,  initialCost: String, cps: String) {
        self.init(name: name, initialCost: initialCost, cps: cps)
        self.photo = photo
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        if let photoToCode = photo {
            aCoder.encode(photoToCode, forKey: PropertyKey.photo)
        }
        aCoder.encode(initialCost, forKey: PropertyKey.initialCost)
        aCoder.encode(cps, forKey: PropertyKey.cps)
        //aCoder.encode(initialCost, forKey: PropertyKey.percentCostIncrease)
        
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("unable to decode name for Building Object", log: .default, type: .debug)
            return nil
        }
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        guard let initialCost = aDecoder.decodeObject(forKey: PropertyKey.initialCost) as? String else {
            os_log("unable to decode cost for Building Object", log: .default, type: .debug)
            return nil
        }
        guard let cps = aDecoder.decodeObject(forKey: PropertyKey.cps) as? String else {
            os_log("unable to decode cps for Building Object", log: .default, type: .debug)
            return nil
        
        //let percentCostIncrease = aDecoder.decodeDouble(forKey: PropertyKey.initialCost)
        }
        if let initPhoto = photo {
            self.init(name: name, photo: initPhoto, initialCost: initialCost, cps: cps)
        }
        else {
            self.init(name: name, initialCost: initialCost, cps: cps)
        }
    }
    
}
class BuildingGroup: NSObject, NSCoding {
    var buildings: NSMutableDictionary
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("building group")
    
    
    
    init(buildingsArray: [Building]) {
        buildings = [:]
        for building in buildingsArray {
            if buildings.object(forKey: building.name!) == nil {
                buildings.setObject(building, forKey: building.name! as NSString)
            }
        }
    }
    
    convenience init(buildings: NSMutableDictionary) {
        let emptyArray = [Building]()
        self.init(buildingsArray: emptyArray)
        self.buildings = buildings
    }
    
    
    struct PropertyKey {
        static let buildings = "buildings"
    }
    func encode(with aCoder:NSCoder) {
        aCoder.encode(buildings, forKey: PropertyKey.buildings)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        guard let buildings = aDecoder.decodeObject(forKey: PropertyKey.buildings) as? NSMutableDictionary else {
            os_log("unable to decode buildings for BuildingGroup object", log: .default, type: .debug)
            return nil
        }
        self.init(buildings: buildings)
    }
    
}


