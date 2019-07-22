//
//  Storage.swift
//  Notes
//
//  Created by Ruslan Gilmullin on 21/07/2019.
//  Copyright © 2019 Ruslan Gilmullin. All rights reserved.
//

import UIKit

class Storage {
    static let noteBook = FileNotebook()
    static var noteUid: String? = nil
    static var noteIx: Int?
    static var updateTable: Bool = false
    static var customColor: UIColor? = nil
}
