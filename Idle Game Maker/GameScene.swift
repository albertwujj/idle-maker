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








class GameScene: SKScene {
    
    //MARK: Properties
    
    var viewController: GameViewController!
    var igBuildingTableView: IGBuildingTableView!
    var game: Game?
    var buildings: [Building] = []
    var upgrades: [Any] = []
    
    
    var clickee: SKSpriteNode?
    var scoreLabel: SKLabelNode?
    var cpsLabel: SKLabelNode?
    var currencyName: SKLabelNode?
    var cpsName: SKLabelNode?
    var buildingMenuButton:SKSpriteNode?
    
    var buildingMenuLabel: SKLabelNode?
    var resetGameLabel: SKLabelNode?
    
    var initialScoreData: [String: Any] = [:]
    var numCurrency: Double
     = 0
    
    var countBuildings: NSMutableDictionary = [:]
    var cps: Double = 0
    var secSinceLastSecSave = 0
    var timer = Timer()
    
    var clickPower: Double = 1
    var basicClickUpgradeLevel: Int = 0
    
   
    //var hiddenTableView
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    //static let ArchiveURL = DocumentsDirectory.appendingPathComponent("building")
    
    
    override func didMove(to view: SKView) {
        
        let backgroundMusic = SKAudioNode(fileNamed: "Epic sax Guy.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        //load saved progress
        if let savedData = loadProgressData() {
            initialScoreData = savedData
            numCurrency = initialScoreData["NumCurrency"] as! Double
            
            

            countBuildings = initialScoreData["CountBuildings"] as! NSMutableDictionary
            basicClickUpgradeLevel = initialScoreData["BasicClickUpgradeLevel"] as! Int
            clickPower = 1 * pow(Double((upgrades[0] as! BasicClickUpgrade).cpMultiplier)!, Double(basicClickUpgradeLevel))
            cps = 0
            for building in buildings {
                if let buildingCount = countBuildings.object(forKey: building.name!) as? Int {
                    cps += Double(buildingCount) * Double(building.cps)!
                 
                }
               
            }
            let timeSinceLastClosed = AppDelegate.loadTimeSinceLastClosed(game: game!)!
            print(timeSinceLastClosed)
            print(cps)
            numCurrency += timeSinceLastClosed * cps
            igBuildingTableView.reloadData()
            
            
            
        }
        
        
        //hide menu at first
        igBuildingTableView.isHidden = true
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
        cpsName!.text = game!.currencyName[0] + "pS"
        
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
        if secSinceLastSecSave > 3 {
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
            updateProgress()
            
           
        }
        
    }
    func buyBasicClickUpgrade(basicClickUpgrade: BasicClickUpgrade) {
        let cost = Double(basicClickUpgrade.cost)! * pow(Double(basicClickUpgrade.costMultiplier)!, Double(basicClickUpgradeLevel))
        if(numCurrency >= cost) {
            numCurrency -= cost
            basicClickUpgradeLevel += 1
            clickPower = pow(Double(basicClickUpgrade.cpMultiplier)!, Double(basicClickUpgradeLevel))
            updateProgress()
        }
        
    }
    //MARK: Random number generators
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    //MARK: Private Functions
    
    private func addClickPowerSprite(clickPoint: CGPoint) {
        let clickPowerSprite = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        clickPowerSprite.text = clickPower.format(f: ".0")
        
        let xVariation = random(min: CGFloat(-20), max: CGFloat(20))
        let yVariation = random(min: CGFloat(1), max: CGFloat(1))
        let spawnPoint = CGPoint(x: clickPoint.x + xVariation, y: clickPoint.y + yVariation)

        clickPowerSprite.position = spawnPoint
        addChild(clickPowerSprite)
        
        
        let duration = random(min: CGFloat(0.8), max: CGFloat(0.8))
        let moveDistanceUp = random(min: CGFloat(40), max: CGFloat(40))
        let actionFade = SKAction.fadeAlpha(by: -0.7, duration: TimeInterval(duration))
        let actionMove = SKAction.move(to: CGPoint(x: spawnPoint.x, y: spawnPoint.y + moveDistanceUp), duration:
            TimeInterval(duration))
        let actionMoveWhileFade = SKAction.group([actionFade, actionMove])
        let actionMoveDone = SKAction.removeFromParent()
        
        clickPowerSprite.run(SKAction.sequence([actionMoveWhileFade, actionMoveDone]))
        
        
    }
    private func updateNumCurrency() {
        scoreLabel!.text = numCurrency.format(f: ".1")
    }
    
    private func updateProgress() {
        
        scoreLabel!.text = numCurrency.format(f: ".1")
        cpsLabel!.text = cps.format(f: ".1")
        saveProgressData()
    }
    
    //MARK: Persist Data
    
    private func loadBuildings() -> [Building]? {
        
        return NSKeyedUnarchiver.unarchiveObject(withFile: Building.DocumentsDirectory.appendingPathComponent("usergame" + game!.name!).path) as? [Building]
    }
    
    private func loadProgressData() -> [String: Any]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: GameScene.DocumentsDirectory.appendingPathComponent("usergameprogress" + game!.name!).path) as? [String: Any]
    }
    
    private func saveProgressData() {
        let toSaveData = ["NumCurrency": numCurrency, "CountBuildings": countBuildings, "BasicClickUpgradeLevel": basicClickUpgradeLevel] as [String : Any]
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
        let timeLastClosed = Date().timeIntervalSince1970
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(timeLastClosed, toFile: AppDelegate.DocumentsDirectory.appendingPathComponent("timelastclosedfor" + game!.name).path)
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
            if name == "Clickee" || name == "ClickeeLabel" {
                numCurrency += clickPower
                
                scoreLabel!.text = numCurrency.format(f: ".1")
                addClickPowerSprite(clickPoint: positionInScene)
                let jiggle = SKAction.sequence([SKAction.scale(by: 0.9, duration: TimeInterval(0.1)), SKAction.scale(by: 1.11, duration: 0.02)])
                clickee?.run(jiggle)
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let touchedNode = atPoint(positionInScene)
        
        if let name = touchedNode.name {
            if name == "BuildingMenuButton" || name == "BuildingMenuLabel"{
                
                igBuildingTableView.isHidden = false
            }
        }
        if let name = touchedNode.name {
            if name == "ResetGameButton" || name == "ResetGameLabel" {
                numCurrency = 0
                cps = 0
                countBuildings = NSMutableDictionary()
                basicClickUpgradeLevel = 0
                clickPower = 1
                updateProgress()
                igBuildingTableView.reloadData()
                
            }
        }

    }
}

