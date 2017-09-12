//
//  BuildingViewController.swift
//  Idle Game Maker
//
//  Created by Albert Wu on 9/2/17.
//  Copyright © 2017 Old Friend. All rights reserved.
//

import UIKit
import os.log
import Foundation

class BuildingViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var buildingNameTF: UITextField!
    @IBOutlet weak var buildingImage: UIImageView!
    @IBOutlet weak var buildingCPSTF: UITextField!
    @IBOutlet weak var buildingCostTF: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var building: Building?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildingNameTF?.delegate = self
        buildingCostTF?.delegate = self
        buildingCPSTF?.delegate = self
        
        if let building = building {
            buildingNameTF.text = building.name
            if let image = building.photo {
                buildingImage.image = image
            }
            
            buildingCPSTF.text = building.cps
            buildingCostTF.text = building.initialCost
        }

        updateSaveButtonState()
    }
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        if(isPresentingInAddMealMode) {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The BuildingViewController is not in a navigation controller")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button == saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        
        let name = buildingNameTF.text
        
        
        building = Building(name: name ?? "", initialCost: buildingCostTF.text!, cps: buildingCPSTF.text!)
        
    }
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == buildingNameTF {
            navigationItem.title = textField.text
        }
        //ADD ERRONEUS INPUT CHECKING FOR NUMBER VALUES
            //if input is erroneus replace with empty string
        updateSaveButtonState()
        
    }
    
    //MARK: Private Methods
    func updateSaveButtonState() {
        let text = buildingNameTF.text ?? ""
        let cost = buildingCostTF.text ?? ""
        let cps = buildingCPSTF.text ?? ""
        let complete = !text.isEmpty && !cost.isEmpty && !cps.isEmpty
        
        
        saveButton.isEnabled = complete
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        buildingNameTF.resignFirstResponder()
        buildingCPSTF.resignFirstResponder()
        buildingCostTF.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            else {
                fatalError("expected a dictionary containing an image, but was provided the following: \(info)")
                
        }
        buildingImage.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
}

