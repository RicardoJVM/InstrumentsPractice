//
//  HitchCellView.swift
//  InstrumentsPractice
//
//  Created by Ricardo Valencia on 22/9/26.
//

import SwiftUI

struct HitchCellView: View {
    let index: Int
    let isBadMode: Bool
    
    var body: some View {
        HStack {
            Text("Ítem #\(index)")
                .font(.headline)
            Spacer()
            
            if isBadMode {
                // 🔴 MODO MALO: Trabajo pesado de formateo / CPU en el cuerpo de la vista
                Text(expensiveDateFormatting())
                    .font(.caption)
                    .foregroundColor(.gray)
            } else {
                // 🟢 MODO BUENO: Formateo cacheado o directo
                Text("Hace 5 minutos")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
    
    /// ❌ ANTI-PATRÓN: Instanciar DateFormatter u operaciones pesadas
    /// dentro de la evaluación de 'body' durante el scroll.
    private func expensiveDateFormatting() -> String {
        let formatter = DateFormatter() // Muy costoso en CPU
        formatter.dateStyle = .full
        formatter.timeStyle = .medium
        
        // Simulación de pequeña carga extra de CPU por celda
        var dummy = 0.0
        for i in 1...20_000 {
            dummy += sin(Double(i))
        }
        
        return formatter.string(from: Date())
    }
}
