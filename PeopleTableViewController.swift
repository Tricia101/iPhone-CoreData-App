//
//  PeopleTableViewController.swift
//  People Core Data
//
//  Created by Yunshan Lyu on 11/03/2022.
//  Copyright © 2022 Yunshan Lyu. All rights reserved.
//





import UIKit
import CoreData


class PeopleTableViewController: UITableViewController,NSFetchedResultsControllerDelegate, UISearchBarDelegate {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var pEntity : NSEntityDescription! = nil
    var pManagedObject : People! = nil
    var frc : NSFetchedResultsController <NSFetchRequestResult>!
    private var showFavorite = false
    private var predicate : NSPredicate?
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func showFavourites(_ sender: Any) {   showFavorite = !showFavorite
        
        if !showFavorite {
            predicate = nil
        } else {
            predicate = NSPredicate(format: "isFavorited == %@", NSNumber(value: showFavorite))
        }
        
        favoriteButton.isSelected = !favoriteButton.isSelected
        
        frc.fetchRequest.predicate = predicate
        do{
            try frc.performFetch()
        }catch{
                
            }
        
        
        tableView.reloadData()
    
    }
    

    //core data object and functions
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            predicate = NSPredicate(format: "name contains %@", searchText)
        } else if showFavorite && !searchText.isEmpty {
            predicate = NSPredicate(format: "name contains %@ AND isFavorited == %@", searchText, NSNumber(value: showFavorite))
        } else if showFavorite {
            predicate = NSPredicate(format: "isFavorited == %@", NSNumber(value: showFavorite))
        } else {
            predicate = nil
        }
      
        frc.fetchRequest.predicate = predicate
        do{
            try frc.performFetch()
        }catch{
                
            }
        tableView.reloadData()
     }
    
    
    func makeRequest()->NSFetchRequest<NSFetchRequestResult>{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "People")
        request.predicate = predicate
        let sorter = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sorter]
        return request
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make frc and set it up with the table
        frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        frc.delegate = self
        searchBar.delegate = self
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: makeRequest()) // TO DELETE
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("failed to delete all")
        }
        
        //fetch
        do{
         try frc.performFetch()
            print("perform fetch")
            print(frc.sections![0].numberOfObjects)
         
            //*if frc.sections![0].numberOfObjects == {
                //get data from the xml
                let xmlData:[Person]! = PeopleData(fromXML: "playerdata.xml").data
                
                //traverse the data objects and make coredata objects
                for person in xmlData{
                    //make a pManageObject
                    pEntity = NSEntityDescription.entity(forEntityName: "People", in: context)
                    pManagedObject = People(entity: pEntity, insertInto: context)
                    //populate it with person data
                    
                    pManagedObject.name = person.name
                    pManagedObject.nationality = person.nationality
                    pManagedObject.url = person.url
                    pManagedObject.height = person.height
                    pManagedObject.dob = person.dob
                    pManagedObject.image = person.image
                    
                    //move the image from bundle to documents
                    putImage2Documents(name: person.image)
                }
        }catch{
            print("frc cannot fetch")
        }
            

            //save
            do{
               try context.save()
            }catch{
               print("not save")
            }
        //}
     }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return frc.sections![section].numberOfObjects
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // get the indexPath managed object from frc
        pManagedObject = frc.object(at: indexPath) as? People
        //fill the cell with data
        cell.textLabel?.text = pManagedObject.name
        
     let image = getImage(imageName: pManagedObject.image!)
     if image != nil {
           cell.imageView?.image = image
       }


        return cell
    }
    

    func getImage(imageName:String) -> UIImage!{
      let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,true )[0]as NSString
       let imagePath = documentsPath.appendingPathComponent(imageName)
        return UIImage(contentsOfFile: imagePath)
   }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            pManagedObject = frc.object(at: indexPath) as? People
            context.delete(pManagedObject)
           
            
            tableView.reloadData()
            
            do{
               try context.save()
            }catch{
               print("not save")
            }
            
        }
    }
   



    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func viewWillAppear(_ animated: Bool) {
            tableView.reloadData()
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue1"{
            //get the new viewcontroller using sege.destination
            let destination = segue.destination as! AddPersonViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            pManagedObject = frc.object(at: indexPath!) as? People
            
            if pManagedObject.isFavorited == nil {
                print(pManagedObject.name! + " is nil ")
                pManagedObject.isFavorited = false
                do{
                   try context.save()
                }catch{
                   print("not save")
                }
            }
            destination.pManagedObject = pManagedObject
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

    func putImage2Documents(name:String){
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,true )[0] as NSString
        let imagePath = documentsPath.appendingPathComponent(name)
        
        let image = UIImage(named: name)
        let data = image?.pngData()
        
        // save data with file  manager
        
        let manager = FileManager.default
        manager.createFile(atPath: imagePath,contents:data,attributes:nil)
    }

