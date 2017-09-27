//
//  BasicClickUpgrade.swift
//  Idle Game Maker
//
//  Created by Albert Wu on 9/4/17.
//  Copyright © 2017 Old Friend. All rights reserved.
//

import UIKit
import os.log


class BasicClickUpgrade: NSObject, NSCoding {
    
    
    //MARK: Properties
    
    var cost: String! = ""
    var cpMultiplier: String!
    var costMultiplier: String!
    
    
    
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("game")
    
    //MARK: Types
    struct PropertyKey {
        static let cost = "cost"
        static let cpMultiplier = "cpMultiplier"
        static let costMultiplier = "costMultiplier"
        
    }
    
    //MARK: Initialization
    init?(cost: String, cpMultiplier: String, costMultiplier: String) {
        self.cost = cost
        self.cpMultiplier = cpMultiplier
        self.costMultiplier = costMultiplier
    }
    

    func encode(with aCoder: NSCoder) {
        aCoder.encode(cost, forKey: PropertyKey.cost)
        aCoder.encode(cpMultiplier, forKey: PropertyKey.cpMultiplier)
        aCoder.encode(costMultiplier, forKey: PropertyKey.costMultiplier)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let cost = aDecoder.decodeObject(forKey: PropertyKey.cost) as? String else {
            os_log("unable to decode cost for Basic Click Upgrade Object", log: .default, type: .debug)
            return nil
        }
        guard let cpMultiplier = aDecoder.decodeObject(forKey: PropertyKey.cpMultiplier) as? String else {
            os_log("unable to decode cpMultiplier for Basic Click Upgrade Object", log: .default, type: .debug)
            return nil
        }
        guard let costMultiplier = aDecoder.decodeObject(forKey: PropertyKey.costMultiplier) as? String else {
            os_log("unable to decode costMultiplier for Basic Click Upgrade Object", log: .default, type: .debug)
            return nil
        }
        
        
        self.init(cost: cost, cpMultiplier: cpMultiplier, costMultiplier: costMultiplier)
    }
   
    /*
    func dictionaryToArchive() {
        var dataDictionary = NSMutableDictionary()
        dataDictionary = ["cost": cost, "cpMultiplier": cpMultiplier, "costMultiplier": costMultiplier]
        return dataDictionary
        
    }
    //MARK: Initialization
    init?(cost: String, cpMultiplier: String, costMultiplier: String) {
        self.cost = cost
        self.cpMultiplier = cpMultiplier
        self.costMultiplier = costMultiplier
    }
    convenience init(dataDictionary) {
        self.init(cost: dataDictionary.object(forKey: "cost"), cpMultiplier: dataDictionary.object(forKey: "cpMultiplier"), costMultiplier: dataDictionary.object(forKey: "cost"))
        
    }
    
    */
    
}
