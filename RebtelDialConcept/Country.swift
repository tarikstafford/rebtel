//
//  Country.swift
//  RebtelDialConcept
//
//  Created by Tarik Stafford on 17/12/18.
//  Copyright © 2018 Tarik Stafford. All rights reserved.
//

import UIKit

enum Region: String, Codable {
    case Africa, Asia, Oceania, Americas, Europe, Error
}

enum ImageType {
    case thumbnail, medium, large
}

struct Country: Codable {
    let iso: String?
    let name: String?
    let info: String?
    let region: Region
    
    func getImage(type: ImageType) -> UIImage? {
        guard var name = self.iso else  { return nil }
        
        switch type {
        case .medium:
            name += "-250px"
        case .large:
            name += "-1000px"
        default:
            break
        }
        print(name)
        return UIImage.init(named: name)
    }
}
