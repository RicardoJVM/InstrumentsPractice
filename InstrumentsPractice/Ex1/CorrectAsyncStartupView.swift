//
//  CorrectAsyncStartupView.swift
//  InstrumentsPractice
//
//  Created by Ricardo Valencia on 22/9/26.
//

import SwiftUI

struct CorrectAsyncStartupView: View {
    @State private var isDataLoaded = false
    @State private var calculationResult: Double = 0.0
    
    var body: some View {
        VStack(spacing: 20) {
            if isDataLoaded {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                Text("¡App lista para usar!")
                    .font(.title2)
                Text("Resultado: \(calculationResult)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                // Se renderiza de inmediato (<100ms) evitando el Hang en el startup
                ProgressView("Inicializando servicios en background...")
                    .controlSize(.large)
            }
        }
        .padding()
        .task {
            // Se ejecuta fuera del Main Thread cuando la vista ya es visible
            let result = await runHeavyWorkInBackground()
            
            // Actualizamos la UI en el Main Thread de forma segura
            self.calculationResult = result
            self.isDataLoaded = true
        }
    }
    
    /// Traslada el cálculo a la reserva de hilos secundarios con prioridad reducida (.utility)
    private func runHeavyWorkInBackground() async -> Double {
        await Task.detached(priority: .utility) {
            print("✅ [CORRECTO - ASYNC] Iniciando trabajo en Background Thread...")
            var result = 0.0
            for i in 1...20_000_000 {
                result += sin(Double(i)) * cos(Double(i))
            }
            print("✅ [CORRECTO - ASYNC] Trabajo completado sin afectar el Main Thread.")
            return result
        }.value
    }
}
