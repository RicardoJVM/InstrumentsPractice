//
//  HitchLabView.swift
//  InstrumentsPractice
//
//  Created by Ricardo Valencia on 22/9/26.
//

import SwiftUI

struct HitchLabView: View {
    @State private var isBadPerformanceMode = true
    
    var body: some View {
        VStack {
            Toggle("Modo Ineficiente (Provoca Hitches)", isOn: $isBadPerformanceMode)
                .padding()
                .tint(.red)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(0..<500, id: \.self) { index in
                        HitchCellView(index: index, isBadMode: isBadPerformanceMode)
                    }
                }
                .padding()
            }
        }
    }
}
