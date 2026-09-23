//
//  HeavyProcess.swift
//  InstrumentsPractice
//
//  Created by Ricardo Valencia on 22/9/26.
//

import SwiftUI

struct HeavyProcess: View {
    @State private var resultMessage = "Presiona para procesar"
    @State private var isProcessing = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text(resultMessage)
                .font(.headline)
                .padding()
            
            Button(action: {
                runHeavyCPUWork()
            }) {
                Text(isProcessing ? "Procesando..." : "Ejecutar Tarea de CPU")
                    .bold()
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(isProcessing)
        }
    }
    
    private func runHeavyCPUWork() {
        isProcessing = true
        resultMessage = "Calculando números primos..."
        
        // Ejecutamos en un hilo secundario para no congelar la UI de golpe,
        // pero quemando CPU al máximo en ese hilo.
        DispatchQueue.global(qos: .userInitiated).async {
            let start = Date()
            
            // Simulación de un Hotspot (Hot Code Path): Algoritmo ineficiente de Primos
            let count = computePrimesUpTo(500_000)
            
            let duration = Date().timeIntervalSince(start)
            
            DispatchQueue.main.async {
                resultMessage = "Procesados \(count) primos en \(String(format: "%.2f", duration))s"
                isProcessing = false
            }
        }
    }
    
    // Función deliberadamente ineficiente (O(N^2)) que genera un "Hotspot"
    private func computePrimesUpTo(_ maxLimit: Int) -> Int {
        var primeCount = 0
        for number in 2...maxLimit {
            if isPrime(number) {
                primeCount += 1
            }
        }
        return primeCount
    }
    
    private func isPrime(_ number: Int) -> Bool {
        if number <= 1 { return false }
        if number <= 3 { return true }
        for i in 2..<number { // Ineficiencia intencional (O(N)) en lugar de O(sqrt(N))
            if number % i == 0 {
                return false
            }
        }
        return true
    }
}
