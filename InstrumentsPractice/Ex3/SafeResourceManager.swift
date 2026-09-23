//
//  SafeResourceManager.swift
//  InstrumentsPractice
//
//  Created by Ricardo Valencia on 22/9/26.
//

import Foundation

actor SafeResourceManager {
    private var internalData = 0
    
    func performHeavyWrite() async {
        print("✅ [BACKGROUND] Escribiendo datos en actor...")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        internalData += 1
    }
    
    func readData() -> Int {
        return internalData
    }
}
