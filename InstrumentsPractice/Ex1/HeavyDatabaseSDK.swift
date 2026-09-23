//
//  HeavyDatabaseSDK.swift
//  InstrumentsPractice
//
//  Created by Ricardo Valencia on 22/9/26.
//

import Foundation

final class HeavyDatabaseSDK {
    static let shared = HeavyDatabaseSDK()
    
    private init() {
        print("✅ [CORRECTO - LAZY] Inicializando SDK pesado solo bajo demanda...")
        var result = 0.0
        for i in 1...20_000_000 {
            result += sin(Double(i)) * cos(Double(i))
        }
        print("✅ [CORRECTO - LAZY] SDK Listo (Result: \(result))")
    }
    
    func fetchLocalData() -> String {
        return "Datos de la base de datos local"
    }
}
