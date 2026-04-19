//
//  Quality.swift
//  CompressPdf
//
//  Created by Авазбек Надырбек уулу on 4/19/26.
//

import Foundation

enum Quality: String, CaseIterable {
    
    case max = "low"
    case balance = "medium"
    case high = "high"
    
    var label: String {
        switch self {
        case .max: return "Максимум"
        case .balance: return "Баланс"
        case .high: return "Качество"
        }
    }
    
    var icon: String {
           switch self {
           case .max:     return "🗜️"
           case .balance: return "⚖️"
           case .high:    return "✨"
           }
       }
}
