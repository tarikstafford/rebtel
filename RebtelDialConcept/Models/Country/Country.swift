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

extension Region: CaseIterable {}

enum ImageType {
    case thumbnail, medium, large
}

struct Currency: Codable {
    let code: String?
    let name: String?
    let symbol: String?
}

struct Country: Codable {
    
    let iso: String?
    let name: String
    let capital: String?
    let population: Int?
    let currencies: [Currency]?
    let region: Region?
    
    private enum CodkingKeys: String, CodingKey {
        case iso = "alpha2code", name, capital, population, currencies, region
    }
    
    func getImage(type: ImageType) -> UIImage? {
        guard var name = self.iso?.lowercased() else  { return nil }
        
        switch type {
        case .medium:
            name += "-250px"
        case .large:
            name += "-1000px"
        default:
            break
        }
        return UIImage.init(named: name)
    }
    
    static func fetchAll() -> [Country] {
        var countries = [Country]()
        if let path = Bundle.main.path(forResource: "countries", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                    jsonResult.forEach({
                        countries.append(Country.init(iso: $0.key, name: ($0.value as! String), capital: nil, population: nil, currencies: nil, region: nil))
                    })
                }
            } catch {
                
            }
        }
        return countries
    }
}
extension Country: Hashable {
    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
}
