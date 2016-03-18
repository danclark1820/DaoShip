//
//  FlightNote.swift
//  DaoShip
//
//  Created by Daniel Clark on 3/18/16.
//  Copyright © 2016 Daniel Clark. All rights reserved.
//

import Foundation

class FlightNote: NSObject, NSCoding {
    let note:String;
    let dateOfNote:NSDate;
    
    init(note:String, dateOfNote:NSDate) {
        self.note = note;
        self.dateOfNote = dateOfNote;
    }
    
    required init(coder: NSCoder) {
        self.note = coder.decodeObjectForKey("note")! as! String;
        self.dateOfNote = coder.decodeObjectForKey("dateOfNote")! as! NSDate;
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.note, forKey: "note")
        coder.encodeObject(self.dateOfNote, forKey: "dateOfNote")
    }
}