//
//  FlightNote.swift
//  DaoShip
//
//  Created by Daniel Clark on 3/18/16.
//  Copyright © 2016 Daniel Clark. All rights reserved.
//

import Foundation

class FlightNote: NSObject, NSCoding {
    let number:Int;
    let dateOfNote:NSDate;
    
    init(number:Int, dateOfNote:NSDate) {
        self.number = number;
        self.dateOfNote = dateOfNote;
    }
    
    required init(coder: NSCoder) {
        self.number = coder.decodeObjectForKey("number")! as! Int;
        self.dateOfNote = coder.decodeObjectForKey("dateOfNote")! as! NSDate;
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.number, forKey: "number")
        coder.encodeObject(self.dateOfNote, forKey: "dateOfNote")
    }
}