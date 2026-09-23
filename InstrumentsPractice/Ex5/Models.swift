//
//  Models.swift
//  InstrumentsPractice
//
//  Created by Ricardo Valencia on 22/9/26.
//

import Foundation

class LeakyParent {
    var child: LeakyChild?
    deinit { print("✅ LeakyParent liberado de memoria") }
}

class LeakyChild {
    // ❌ ERROR: Referencia 'strong' inversa que genera un ciclo de retención
    var parent: LeakyParent?
    deinit { print("✅ LeakyChild liberado de memoria") }
}

class MemoryCache {
    static let shared = MemoryCache()
    // ❌ Crecimiento ilimitado: Mantiene referencias vivas intencionalmente
    var accumulatedBuffers: [Data] = []
}
