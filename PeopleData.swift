//
//  PeopleData.swift
//  People Core Data
//
//  Created by lys on 31/03/2022.
//  Copyright © 2022 lys. All rights reserved.
//

import Foundation

class PeopleData{
    var data:[Person]
    
    init(fromXML:String){
        let parser=XMLPeopleParser(fileName: fromXML)
        parser.startParsing()
        self.data=parser.peopleData
    }
    
    func getCount() -> Int{return data.count}
    func getPeople(index:Int)-> Person{
        return data[index]
    }
}
