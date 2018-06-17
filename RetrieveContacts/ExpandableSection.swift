//
//  ExpandableSection.swift
//  Contacts_LBTA
//
//  Created by Dimash Bekzhan on 1/25/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import Foundation
import Contacts

struct ExpandableSection {
    var isExpanded: Bool
    let contacts: [FavoritableContact]
}

class FavoritableContact {
    let contact: CNContact
    var isFavorite: Bool
    
    init(contact: CNContact, isFavorite: Bool = false) {
        self.contact = contact
        self.isFavorite = isFavorite
    }
}
