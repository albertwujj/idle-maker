//
//  GameScene.swift
//  Idle Game Maker
//
//  Created by Albert Wu on 9/2/17.
//  Copyright © 2017 Old Friend. All rights reserved.
//

import SpriteKit
import GameplayKit
import os.log
import Foundation

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}


extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[Range(start ..< end)]
    }
}


class IGBuildingCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var costLabel: UILabel!
    
    @IBOutlet weak var cpsLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


class GameScene: SKScene {
    
    //MARK: Properties
    var viewController: GameViewController!
    
    var clickee: SKSpriteNode?
    var scoreLabel: SKLabelNode?
    var cpsLabel: SKLabelNode?
    var currencyName: SKLabelNode?
    var cpsName: SKLabelNode?
    var buildingMenuButton:SKSpriteNode?
    
    var buildingMenuLabel: SKLabelNode?
    var resetGameLabel: SKLabelNode?
    
    var initialScoreData: [Any] = []
    var numCurrency: Double
     = 0
    var game: Game?
    var buildings: [Building] = []
    var countBuildings: NSMutableDictionary = [:]
    var cps: Double = 0
    var secSinceLastSecSave = 0;
    var timer = Timer()
   
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    //static let ArchiveURL = DocumentsDirectory.appendingPathComponent("building")
    
    
    override func didMove(to view: SKView) {
        
        
        //load saved progress
        if let savedData = loadProgressData() as [Any]? {
            initialScoreData = savedData
            numCurrency = initialScoreData[0] as! Double
            cps = initialScoreData[1] as! Double
            countBuildings = initialScoreData[2] as! NSMutableDictionary
            //update count of buildings in GameViewController's [Building]
         
            viewController.igBuildingTableView.reloadData()
        }
        
        
        //hide menu at first
        viewController.igBuildingTableView.isHidden = true
        // Get nodes from scene and store them for use later
        self.clickee = self.childNode(withName: "Clickee") as? SKSpriteNode
        clickee?.isUserInteractionEnabled = false
        clickee?.name = "Clickee"
        
        scoreLabel = self.childNode(withName: "ScoreLabel") as? SKLabelNode
        scoreLabel!.text = numCurrency.format(f: ".1")
        
        cpsLabel = self.childNode(withName: "CPSLabel") as? SKLabelNode
        cpsLabel!.text = cps.format(f: ".1")
        // Table setup
        
        currencyName = self.childNode(withName: "CurrencyName") as? SKLabelNode
        currencyName!.text = game!.currencyName
        
        cpsName = self.childNode(withName: "CPSName") as? SKLabelNode
        cpsName!.text = game!.currencyName[0] + "ps"
        
        buildingMenuButton = self.childNode(withName: "BuildingMenuButton") as? SKSpriteNode
        buildingMenuButton!.isUserInteractionEnabled = false
        buildingMenuLabel = self.childNode(withName: "BuildingMenuLabel") as? SKLabelNode
        buildingMenuLabel!.isUserInteractionEnabled = false
        resetGameLabel = self.childNode(withName: "ResetGameLabel") as? SKLabelNode
        resetGameLabel!.isUserInteractionEnabled = false
        scheduledTimerWithTimeInterval()
        
    }
    override func sceneDidLoad() {
        
    }
    
    //Time Functions
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene.updateEverySecond), userInfo: nil, repeats: true)
    }
    
   
    
    func updateEverySecond(){
        numCurrency += cps
        updateNumCurrency()
        secSinceLastSecSave += 1
        if secSinceLastSecSave > 5 {
            secSinceLastSecSave = 0
            updateProgress()
        }
    }
    
    
    func buyBuilding(building: Building) {
        let name = building.name!
        
       
        let buildCps = Double(building.cps)!
        var cost = 0.0
        if let count = countBuildings.object(forKey: name) as? Int {
            cost = Double(building.initialCost)! * pow(1.15, Double(count))
        }
        else {
            cost = Double(building.initialCost)!
        }
        if(numCurrency >= cost) {
            numCurrency -= cost
            cps += buildCps
            if let count = countBuildings.object(forKey: name) as? Int {
                countBuildings.setObject((count) + 1, forKey: name as NSCopying)
            }
            else {
                countBuildings.setObject(1, forKey: name as NSCopying)
            }
            //updates the building menu to increase cost and count
            viewController.igBuildingTableView.reloadData()
            updateProgress()
            
           
        }
        
    }
    //MARK: Private Functions
    private func updateNumCurrency() {
        scoreLabel!.text = numCurrency.format(f: ".1")
    }
    
    private func updateProgress() {
        
        scoreLabel!.text = numCurrency.format(f: ".1")
        cpsLabel!.text = cps.format(f: ".1")
        saveProgressData()
    }
    
    private func loadBuildings() -> [Building]? {
        
        return NSKeyedUnarchiver.unarchiveObject(withFile: Building.DocumentsDirectory.appendingPathComponent("usergame" + game!.name!).path) as? [Building]
    }
    
    private func loadProgressData() -> [Any]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: GameScene.DocumentsDirectory.appendingPathComponent("usergameprogress" + game!.name!).path) as? [Any]
    }
    
    private func saveProgressData() {
        let toSaveData = [numCurrency, cps, countBuildings] as [Any]
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(toSaveData, toFile: GameScene.DocumentsDirectory.appendingPathComponent("usergameprogress" + game!.name!).path)
        if isSuccessfulSave {
            os_log("Saving progressdata was successful", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save progressdata...", log: OSLog.default, type: .debug)
        }
        saveTimeLastClosed()
    }
    private func saveTimeLastClosed() {
        let timeLastClosed = NSTimeIntervalSince1970
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(timeLastClosed, toFile: AppDelegate.DocumentsDirectory.appendingPathComponent("timelastclosed").path)
        if isSuccessfulSave {
            os_log("Saving timelastclosed was successful", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save timelastclosed...", log: OSLog.default, type: .debug)
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let touchedNode = atPoint(positionInScene)
        
        if let name = touchedNode.name {
            if name == "Clickee" {
                numCurrency+=1
                scoreLabel!.text = numCurrency.format(f: ".1")
                
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let touchedNode = atPoint(positionInScene)
        
        if let name = touchedNode.name {
            if name == "BuildingMenuButton" || name == "BuildingMenuLabel"{
                viewController.igBuildingTableView.isHidden = false
            }
        }
        if let name = touchedNode.name {
            if name == "ResetGameButton" || name == "ResetGameLabel" {
                numCurrency = 0
                cps = 0
                countBuildings = NSMutableDictionary()
                updateProgress()
                viewController.igBuildingTableView.reloadData()
                
            }
        }

    }
}

