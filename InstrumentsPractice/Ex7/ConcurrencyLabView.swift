//
//  ConcurrencyLabView.swift
//  InstrumentsPractice
//
//  Created by Ricardo Valencia on 22/9/26.
//

import SwiftUI

struct ConcurrencyLabView: View {
    @State private var statusMessage = "UI Activa (Presiona un botón)"
    @State private var isProcessing = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text(statusMessage)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
            
            if isProcessing {
                ProgressView()
            }
            
            // 🔴 CASO INCORRECTO: Bloqueo de MainActor
            Button("Provocar MainActor Bottleneck") {
                Task {
                    await runIncorrectMainActorTask()
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .disabled(isProcessing)
            
            // 🟢 CASO CORRECTO: Detached / Cooperative Yielding
            Button("Ejecutar Concurrencia Optimizada") {
                Task {
                    await runCorrectCooperativeTask()
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .disabled(isProcessing)
        }
        .padding()
    }
    
    // 🔴 INCORRECTO: Correr trabajo intensivo de CPU dentro del contexto del MainActor
    // Aunque usa 'async', el cuerpo de la función pertenece a la View (que está anotada con @MainActor),
    // por lo que el bucle de CPU se ejecuta ÍNTEGRAMENTE en el Main Thread.
    @MainActor
    private func runIncorrectMainActorTask() async {
        isProcessing = true
        statusMessage = "⚠️ [INCORRECTO] Ejecutando calculo pesado en @MainActor..."
        
        let start = CFAbsoluteTimeGetCurrent()
        var result = 0.0
        
        // Incrementamos la carga para saturar el Main Thread en la Mac
        for i in 1...100_000_000 {
            result += sin(Double(i)) * cos(Double(i))
        }
        
        let elapsed = CFAbsoluteTimeGetCurrent() - start
        statusMessage = "⚠️ Completado en \(String(format: "%.2f", elapsed))s en Main Thread (Result: \(result))"
        isProcessing = false
    }
    
    // 🟢 CORRECTO: Desvincular del @MainActor y usar Task.yield() para cooperación
    private func runCorrectCooperativeTask() async {
        isProcessing = true
        statusMessage = "✅ [CORRECTO] Desplazando trabajo fuera del Main Thread..."
        
        let elapsed = await Task.detached(priority: .userInitiated) { () -> Double in
            let start = CFAbsoluteTimeGetCurrent()
            var result = 0.0
            
            for i in 1...30_000_000 {
                result += sin(Double(i)) * cos(Double(i))
                
                // 💡 COOPERATIVE YIELDING: Cada 5 millones de iteraciones
                // cede el tiempo de ejecución para no acaparar el hilo secundario.
                if i % 5_000_000 == 0 {
                    await Task.yield()
                }
            }
            
            return CFAbsoluteTimeGetCurrent() - start
        }.value
        
        statusMessage = "✅ Completado en \(String(format: "%.2f", elapsed))s sin afectar el Main Thread"
        isProcessing = false
    }
}
