//
//  CorrectNonBlockingView.swift
//  InstrumentsPractice
//
//  Created by Ricardo Valencia on 22/9/26.
//

import SwiftUI

struct CorrectNonBlockingView: View {
    @State private var statusMessage = "UI Activa y Responsiva"
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text(statusMessage)
                .font(.headline)
            
            if isLoading {
                ProgressView("Procesando en background...")
            }
            
            Button("Ejecutar Operación de Forma Segura") {
                Task {
                    await triggerNonBlockingOperation()
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .disabled(isLoading)
        }
    }
    
    private func triggerNonBlockingOperation() async {
        isLoading = true
        statusMessage = "Ejecutando en background..."
        
        // ✅ SOLUCIÓN: La tarea se suspende sin bloquear la CPU ni el Main Thread
        await Task.detached(priority: .userInitiated) {
            print("✅ [CORRECTO] Trabajo secundario iniciado...")
            try? await Task.sleep(nanoseconds: 3_000_000_000) // 3 segundos sin bloquear hilo
            print("✅ [CORRECTO] Trabajo secundario finalizado.")
        }.value
        
        statusMessage = "Operación completada sin congelar la UI"
        isLoading = false
    }
}
