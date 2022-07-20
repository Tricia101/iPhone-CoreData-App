//
//  AddPersonViewController.swift
//  People Core Data
//
//  Created by Yunshan Lyu on 11/03/2022.
//  Copyright © 2022 Yunshan Lyu. All rights reserved.
//

import UIKit
import CoreData//must import  core data to use it

class AddPersonViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    //core data objects and functions
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var pEntity : NSEntityDescription! = nil
    var pManagedObject : People! = nil
    
    func updatePerson(){
        //fill pManaged object with data from fields
        pManagedObject.name = nameTextField.text
        pManagedObject.nationality = nationalityTextField.text
        pManagedObject.dob = dobTextField.text
        pManagedObject.height = heightTextField.text
        pManagedObject.image = imageTextField.text
        pManagedObject.url = urlTextField.text
        pManagedObject.isFavorited = favoritedSwitch.isOn
     //   print("update " )
      //  print(pManagedObject.isFavorited)
     //   print(favoritedSwitch.isOn)
        
        //context saves
        do{
            try context.save()
        }catch{
            print("context cannot save")
        }
        
        let image = pickImageView.image
        if image != nil && imageTextField.text != nil{
            putImage(imageName: imageTextField.text!)
        }
    }
    func saveNewPerson(){
        //create a new managed object
        pEntity = NSEntityDescription.entity(forEntityName: "People", in: context)
        pManagedObject = People(entity: pEntity, insertInto:context)
        
        
        
        //fill pManaged object with data from fields
        pManagedObject.name = nameTextField.text
        pManagedObject.nationality = nationalityTextField.text
        pManagedObject.dob = dobTextField.text
        pManagedObject.height = heightTextField.text
        pManagedObject.image = imageTextField.text
        pManagedObject.url = urlTextField.text
        pManagedObject.isFavorited = favoritedSwitch.isOn
        //print("save ")
      //  print(pManagedObject.isFavorited)
        //print(pManagedObject.isFavorited ?? false)
        //context saves
        do{ try context.save()
        }catch{
            print("context cannot save")
        }
    }
    func getImage(imageName:String){
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,true )[0] as NSString
        let imagePath = documentsPath.appendingPathComponent(imageName)
        
        let image = UIImage(contentsOfFile: imagePath)
        
        pickImageView.image = image
    }
    
    func putImage(imageName:String){
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,true )[0] as NSString
        let imagePath = documentsPath.appendingPathComponent(imageName)
        
        let image = pickImageView.image
        let data = image?.pngData()
        
        // save data with file  manager
        
        let manager = FileManager.default
        manager.createFile(atPath: imagePath,contents:data,attributes:nil)
        
    }
    //picker controller
    let pickerController = UIImagePickerController()
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        pickImageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    //outlets and actions
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nationalityTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var imageTextField: UITextField!
    @IBOutlet weak var pickImageView: UIImageView!
    @IBOutlet weak var favoritedSwitch: UISwitch!
    
    @IBAction func pickImageAction(_ sender: Any) {
        pickerController.delegate = self
        pickerController.sourceType = .savedPhotosAlbum
        pickerController.allowsEditing = false
        
        present(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        //test pManagedObject to action
        if pManagedObject == nil{
            saveNewPerson()
        }else{
            updatePerson()
        }
        //return to table
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // fill the fields with pManagedObject data
        if pManagedObject != nil{
            nameTextField.text = pManagedObject.name
            nationalityTextField.text = pManagedObject.nationality
            dobTextField.text = pManagedObject.dob
            heightTextField.text = pManagedObject.height
            imageTextField.text = pManagedObject.image
            urlTextField.text = pManagedObject.url
            favoritedSwitch.isOn = pManagedObject.isFavorited
            print("viewdidload")
            print(pManagedObject.isFavorited)
            // get the image from document
            getImage(imageName: imageTextField.text!)
            
            // place it
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
