//
//  Person.swift
//  Personal Archive
//
//  Created by lys on 11/03/2022.
//

import Foundation

class Person{
    
    // properties
    var name : String
    var nationality : String
    var dob : String
    var height : String
    var image : String
    var url: String
    
    
    // init
    init(){
        self.name    = ""
        self.nationality   = ""
        self.dob = ""
        self.height   = ""
        self.image   = ""
        self.url = ""
    }
    
    init(name:String, nationality:String, dob:String, height:String, image:String, url:String){
        self.name    = name
        self.nationality   = nationality
        self.dob = dob
        self.height   = height
        self.image   = image
        self.url   =  url
    }
    
    // methods
    
}


