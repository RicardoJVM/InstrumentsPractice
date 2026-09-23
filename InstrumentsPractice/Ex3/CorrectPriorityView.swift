//
//  CorrectPriorityView.swift
//  InstrumentsPractice
//
//  Created by Ricardo Valencia on 22/9/26.
//

import SwiftUI

struct CorrectPriorityView: View {
    private let resourceManager = SafeResourceManager()
    @State private var statusMessage = "UI Responsiva"
    
    var body: some View {
        VStack(spacing: 20) {
            Text(statusMessage)
                .font(.headline)
            
            Button("Ejecutar Operación Segura con Actor") {
                Task {
                    await runSafeConcurrency()
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
        }
    }
    
    private func runSafeConcurrency() async {
        // Lanza tarea en background
        Task(priority: .background) {
            await resourceManager.performHeavyWrite()
        }
        
        // Suspende en lugar de bloquear el hilo principal.
        // El ejecutor de Swift escala temporalmente la prioridad del actor para liberar la respuesta.
        _ = await resourceManager.readData()
        statusMessage = "Lectura completada sin Inversión de Prioridad"
    }
}
