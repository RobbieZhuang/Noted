//
//  NetworkExtensions.swift
//  PDFViewer
//
//  Created by facebook on 11/15/18.
//  Copyright © 2018 Todd Kramer. All rights reserved.
//

import Foundation
import Starscream


// MARK: - WebSocketDelegate
extension ViewController : WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        socket.write(string: "initnotes " + textBookName)
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("lLLL")
//        performSegue(withIdentifier: "websocketDisconnected", sender: self)
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("from string " + text)
        
        let data: Data = text.data(using: .utf8)!
//        guard let json = data as? [String: Any] else {
//            print("didn't get todo object as JSON from API")
//            print("Error: \(String(describing: text))")
//            return
//        }
        
        let index = text.index(text.startIndex, offsetBy: 8)
        let mySubstring = text[..<index] // Hello
        
       
        if String(mySubstring).isEqual("{\"notes\"") {
            let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String:AnyObject]
            do {
                let tempNotes: [Note] = (try JSONDecoder().decode(NoteRoot.self, from: (self.jsonToData(json: json))!).notes)!
                self.notes = tempNotes
                print("!!!!!")
                print(tempNotes)
                print(self.notes)
                createAnnotations()
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
        } else if String(mySubstring).isEqual("{\"docid\"") {
            guard let json = try? JSONDecoder().decode(Note.self, from: data) else {
                print("Error: Couldn't decode data into Blog")
                return
            }
            print(json)
                notes.append(json)
                createAnnotations()
        } else if text.isEqual("{\"response\": \"denied\"}") {
            if let tempNote = mostRecentlyAddedNote {
                for i in 0 ..< notes.count {
                    if notes[i].message!.isEqual(tempNote.message!) && notes[i].selected!.isEqual(tempNote.selected!) {
                        removeAnnotation(n: notes[i])
                        notes.remove(at: i)
                    }
                }
            }
        } else {
            if let pg = document?.page(at: tempPageForAnnotation!) {
                pg.addAnnotation(tempAnnotation!)
            }
            let tempNote = Note(message: addText!, selected: curSelected, page: tempPageForAnnotation,
                                x: Double(curBounds!.origin.x), y: Double(curBounds!.origin.y), w: Double(curBounds!.size.width), h: Double(curBounds!.size.height),
                                documentID: textBookName, userName: userName, rate: 0
            )
            notes.append(tempNote)
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("from data")
    }
    
    func dataToJSON(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    func jsonToData(json: Any) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
}

// MARK: - FilePrivate
extension ViewController {
    
    fileprivate func sendMessage(_ message: String) {
        socket.write(string: message)
    }
    
    fileprivate func messageReceived(_ message: String, senderName: String) {
        
    }
}


