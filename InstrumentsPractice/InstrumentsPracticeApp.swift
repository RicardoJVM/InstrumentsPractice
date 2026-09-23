//
//  InstrumentsPracticeApp.swift
//  InstrumentsPractice
//
//  Created by Ricardo Valencia on 22/9/26.
//

import SwiftUI

@main
struct InstrumentsPracticeApp: App {
    
    init() {
        //Ex 1
        //heavyInitializationWork()
    }
    
    var body: some Scene {
        WindowGroup {
            //Ex 2
            //IncorrectHangView()
            //CorrectNonBlockingView()
            
            //Ex 3
            //IncorrectPriorityInversionView()
            //CorrectPriorityView()
            
            //Ex 4
            //HeavyProcess()
            
            //Ex 5
            //MemoryLabView()
            
            //Ex 6
            //HitchLabView()
            
            //Ex7
            ConcurrencyLabView()
        }
    }
    
    //Ex 1
    /*private func heavyInitializationWork() {
        print("⚠️ Iniciando trabajo pesado en Post-Main...")
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Simula procesamiento pesado (p. ej., parsing síncrono de un JSON masivo o desencriptado de DB)
        var result = 0.0
        for i in 1...20_000_000 {
            result += sin(Double(i)) * cos(Double(i))
        }
        
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        print("⚠️ Inicialización finalizada en: \(String(format: "%.2f", timeElapsed))s (Result: \(result))")
    }*/
}

// Ex2
/*struct IncorrectHangView: View {
    private let semaphore = DispatchSemaphore(value: 0)
    @State private var statusMessage = "UI Activa (Presiona el botón)"
    
    var body: some View {
        VStack(spacing: 20) {
            Text(statusMessage)
                .font(.headline)
            
            Button("Provocar Main Thread Hang") {
                triggerMainThreadHang()
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
    }
    
    private func triggerMainThreadHang() {
        print("⚠️ [INCORRECTO] Iniciando tarea en hilo secundario...")
        
        // 1. Enviamos un trabajo a un hilo secundario
        DispatchQueue.global(qos: .background).async {
            print("⚠️ [INCORRECTO] Tarea secundaria ejecutándose (simulando 3 segundos)...")
            Thread.sleep(forTimeInterval: 3.0) // Simula cálculo/escritura lenta
            print("⚠️ [INCORRECTO] Liberando semáforo desde el hilo secundario")
            self.semaphore.signal()
        }
        
        // 2. ❌ ERROR GRAVE: El Main Thread se detiene y ESPERA sincrónicamente
        // Esto causa un Hang de 3,000 ms (>250ms). La app no responde a toques.
        print("⚠️ [INCORRECTO] Main Thread bloqueado en semaphore.wait()...")
        _ = semaphore.wait(timeout: .distantFuture)
        
        statusMessage = "Hang finalizado tras 3 segundos"
        print("⚠️ [INCORRECTO] Main Thread desbloqueado.")
    }
}*/

// Ex 3
/*struct IncorrectPriorityInversionView: View {
    private let lock = NSLock()
    @State private var statusMessage = "UI Lista"
    
    var body: some View {
        VStack(spacing: 20) {
            Text(statusMessage)
                .font(.headline)
            
            Button("Simular Priority Inversion") {
                triggerPriorityInversion()
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
        }
    }
    
    private func triggerPriorityInversion() {
        // 1. Tarea de BAJA prioridad toma el cerrojo y hace un trabajo largo
        DispatchQueue.global(qos: .background).async {
            print("⚠️ [LOW QoS] Adquiriendo cerrojo...")
            lock.lock()
            
            // Trabajo pesado en hilo de baja prioridad manteniendo el recurso tomado
            print("⚠️ [LOW QoS] Ejecutando trabajo en background...")
            let start = CFAbsoluteTimeGetCurrent()
            while CFAbsoluteTimeGetCurrent() - start < 3.0 {
                // Simulación de trabajo largo con cerrojo tomado
            }
            
            print("⚠️ [LOW QoS] Liberando cerrojo.")
            lock.unlock()
        }
        
        // Pequeño retardo para asegurar que el hilo de baja prioridad adquirió el lock primero
        Thread.sleep(forTimeInterval: 0.1)
        
        // 2. ❌ ALTA PRIORIDAD (Main Thread): Intenta adquirir el MISMO cerrojo
        // El Main Thread queda bloqueado esperando que un hilo con prioridad muy baja
        // reciba tiempo de CPU para terminar y liberar el cerrojo.
        print("⚠️ [HIGH QoS - Main] Esperando por el cerrojo...")
        lock.lock()
        print("⚠️ [HIGH QoS - Main] Cerrojo adquirido finalmente.")
        lock.unlock()
        
        statusMessage = "Proceso completado tras Inversión de Prioridad"
    }
}*/


