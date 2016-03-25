//
//  FlightNoteManager.swift
//  DaoShip
//
//  Created by Daniel Clark on 3/18/16.
//  Copyright © 2016 Daniel Clark. All rights reserved.
//

import Foundation

class FlightNoteManager {
    var notes:Array<FlightNote> = [];
    
    init() {
        // load existing high scores or set up an empty array
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("FlightNotes.plist")
        let fileManager = NSFileManager.defaultManager()
        
        // check if file exists
        if !fileManager.fileExistsAtPath(path) {
            // create an empty file if it doesn't exist
            if let bundle = NSBundle.mainBundle().pathForResource("DefaultFile", ofType: "plist") {
                do {
                    try fileManager.copyItemAtPath(bundle, toPath: path)
                } catch is ErrorType {
                    print(String(ErrorType))
                }
            }
        }
        
        if let rawData = NSData(contentsOfFile: path) {
            // do we get serialized data back from the attempted path?
            // if so, unarchive it into an AnyObject, and then convert to an array of HighScores, if possible
            let notesArray: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(rawData);
            self.notes = notesArray as? [FlightNote] ?? [];
        }
    }
    
    func save() {
        // find the save directory our app has permission to use, and save the serialized version of self.scores - the HighScores array.
        let saveData = NSKeyedArchiver.archivedDataWithRootObject(self.notes);
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray;
        let documentsDirectory = paths.objectAtIndex(0) as! NSString;
        let path = documentsDirectory.stringByAppendingPathComponent("FlightNotes.plist");
        
        saveData.writeToFile(path, atomically: true);
    }
    
    // a simple function to add a new high score, to be called from your game logic
    // note that this doesn't sort or filter the scores in any way
    func nextNote() {
        let newFlightNote : FlightNote?
        let currentNumber = self.notes.last?.number
        if currentNumber == nil {
            newFlightNote = FlightNote(number: 0, dateOfNote: NSDate());
        } else {
            newFlightNote = FlightNote(number: currentNumber! + 1, dateOfNote: NSDate());
        }
        
        self.notes.append(newFlightNote!)
        self.save();
    }
}
