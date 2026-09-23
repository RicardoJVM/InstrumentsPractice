//
//  CorrectLazyStartupView.swift
//  InstrumentsPractice
//
//  Created by Ricardo Valencia on 22/9/26.
//

import SwiftUI

struct CorrectLazyStartupView: View {
    @State private var dataStatus = "SDK no cargado aún"
    
    var body: some View {
        VStack(spacing: 20) {
            Text(dataStatus)
                .font(.headline)
            
            Button("Cargar módulo pesado") {
                // La primera llamada a .shared ejecutará el init() de HeavyDatabaseSDK.
                // El costo de arranque de la App fue exactamente de 0 ms.
                let data = HeavyDatabaseSDK.shared.fetchLocalData()
                dataStatus = data
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
