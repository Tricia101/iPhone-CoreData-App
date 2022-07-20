//
//  XMLPeopleParser.swift
//  Personal Archive
//
//  Created by lys on 11/03/2022.
//

import Foundation

class XMLPeopleParser:NSObject, XMLParserDelegate{
    
    // init
    var name : String!
    init(fileName:String){
        self.name = fileName
    }
    
    // parsing vars
    var pName, pNationality, pDob, pHeight, pImage,  pUrl: String! // tmp vars for texts
    var tagId : Int = -1; var passData = false // spy vars
    
    // tags
    var tags = ["name", "nationality", "dob", "height", "image",  "url"]
    
    // data vars
    var peopleData = [Person]()
    var personData : Person! // data is an empty dict
    
    // parser obj
    var parser = XMLParser()
    
    // methods to override
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        // set the spys
        if tags.contains(elementName){
            passData = true
            
            switch elementName {
                case "name" :  tagId = 0
                case "nationality" : tagId = 1
                case "dob" : tagId = 2
                case "height" : tagId = 3
                case "image" : tagId = 4
                case "url" : tagId = 5
                   
                default:break

            }
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        // reset spies if new tag found
        if tags.contains(elementName){
            passData = false
            tagId    = -1
        }
        
        // found person then make an person object and add it to dictionary
        if elementName == "person"{
            let person = Person(name: pName, nationality: pNationality, dob: pDob, height: pHeight, image: pImage, url: pUrl)
            peopleData.append(person)
        }
        
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // test spies and store in pVar the found string
        if passData{
            switch tagId {
            case 0 : pName = string
            case 1 : pNationality = string
            case 2 : pDob = string
            case 3 : pHeight = string
            case 4 : pImage = string
            case 5 : pUrl = string
            default: break
                
            }
        }
    }
    
    // method to parsing
    func startParsing(){
        //get to the xml file
        let bundlePath = Bundle.main.bundleURL
        let xmlPath = URL(fileURLWithPath: name, relativeTo: bundlePath)
        
        parser = XMLParser(contentsOf: xmlPath)!
        parser.delegate = self
        parser.parse()
    }
}

