//
//  MemoryLabView.swift
//  InstrumentsPractice
//
//  Created by Ricardo Valencia on 22/9/26.
//

import SwiftUI

private var leakedStore: [Any] = []

struct MemoryLabView: View {
    @State private var createdObjectsCount = 0
    @State private var megabytesAllocated = 0
    
    var body: some View {
        VStack(spacing: 25) {
            Text("Laboratorio de Memoria")
                .font(.title2).bold()
            
            // --- SECCIÓN 1: MEMORY LEAK ---
            VStack(spacing: 10) {
                Text("1. Memory Leak (Retain Cycle)")
                    .font(.headline)
                Text("Objetos fugados creados: \(createdObjectsCount)")
                    .font(.caption)
                
                Button("Provocar Leaky Retain Cycle") {
                    triggerMemoryLeak()
                }
                .buttonStyle(.borderedProminent)
                .tint(.purple)
            }
            .padding()
            .background(Color.purple.opacity(0.1))
            .cornerRadius(12)
            
            // --- SECCIÓN 2: MEMORY GROWTH ---
            VStack(spacing: 10) {
                Text("2. Memory Growth (Acumulación)")
                    .font(.headline)
                Text("MBs retenidos en memoria: \(megabytesAllocated) MB")
                    .font(.caption)
                
                Button("Generar Memory Growth (+10 MB)") {
                    triggerMemoryGrowth()
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(12)
        }
        .padding()
    }
    
    // Provoca un ciclo de retención. Los objetos salen del scope local
    // pero se mantienen vivos mutuamente en el Heap.
    private func triggerMemoryLeak() {
        for _ in 1...500 {
            let parent = LeakyParent()
            let child = LeakyChild()
            
            // Strong Reference Cycle
            parent.child = child
            child.parent = parent
            
            // Mantenemos una referencia raíz temporal para evitar que el compilador las elimine en compilación
            leakedStore.append(parent)
        }
        
        // Vaciamos el arreglo raíz: Las referencias externas mueren,
        // pero parent y child quedan atrapados vivos en el Heap únicamente por su ciclo interno.
        leakedStore.removeAll()
        
        createdObjectsCount += 1000
    }
    
    // Asigna bloques masivos de memoria y los guarda en una variable estática.
    private func triggerMemoryGrowth() {
        let tenMegabytes = 10 * 1024 * 1024
        let dummyData = Data(count: tenMegabytes)
        
        MemoryCache.shared.accumulatedBuffers.append(dummyData)
        megabytesAllocated += 10
    }
}
