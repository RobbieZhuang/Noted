//
//  Note.swift
//  PDFViewer
//
//  Created by facebook on 11/15/18.
//  Copyright © 2018 Todd Kramer. All rights reserved.
//

import Foundation


struct Note: Codable {
    let message: String?
    let selected: String?
    let page: Int?
    let x: Double?
    let y: Double?
    let w: Double?
    let h: Double?
    let documentID: String?
    let userName: String?
    let rate: Int?
}

struct NoteRoot: Codable {
    let notes: [Note]?
}
