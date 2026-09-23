# 🚀 iOS Performance Engineering Laboratory

Guía rápida de diagnóstico, herramientas de **Xcode Instruments** y patrones de resolución para los 7 cuellos de botella de rendimiento más comunes en iOS.

---

## 🛠️ Resumen de Diagnóstico por Ejercicio

| # | Problema | Instrumento Clave | Síntoma en el Caso Incorrecto | Causa Raíz & Solución |
| :-: | :--- | :--- | :--- | :--- |
| **1** | **Startup Lento** | Time Profiler | Hotspot (~100% CPU) en `Main Thread` durante `init()` / Post-Main. | Trabajo síncrono pesado al arrancar. Usar `Task` diferido o `lazy`. |
| **2** | **Main Thread Hang** | System Trace | `Main Thread` en estado **Blocked** (>250ms) con CPU al 0%. | Espera síncrona de recursos (`semaphore.wait()`). Usar `async/await`. |
| **3** | **Priority Inversion** | System Trace (*States*) | `Main Thread` en **Blocked** (QoS alta) + **Priority Escalation** en hilo de background. | Mutex/NSLock síncrono entre distintas clases de QoS. Migrar a **Swift Actors**. |
| **4** | **CPU Excesivo** | Time Profiler | Picos sostenidos de CPU al 100% revelados al usar **Invert Call Tree**. | Algoritmo ineficiente $O(N^2)$ o tareas pesadas en UI. Optimizar complejidad. |
| **5** | **Memory Leak / Growth** | Leaks & Allocations | Alerta `⚠️ Leaks` (**Cycles & Roots**) o gráfica en "escalera" en **All Heap**. | Strong Reference Cycles (`weak` / `unowned`) o retención en colecciones globales. |
| **6** | **Animation Hitches** | Animation Hitches / Time Profiler | Caída del **Hitch Time Ratio** o >16.6ms consumidos por frame en el `Main Thread`. | **Commit Hitch**: Lógica pesada (`DateFormatter`, layout) dentro del `body` en scroll. |
| **7** | **Swift Concurrency Bottlenecks** | Swift Concurrency / Time Profiler | Trabajo intensivo `async` ejecutándose dentro del **`Main Thread`**. | Tarea aislada por `@MainActor`. Usar `Task.detached` y `await Task.yield()`. |

---

## 📋 Detalle de los 7 Laboratorios

### 1. Startup Lento (App Launch)
* **Instrumento:** `Time Profiler`
* **Síntoma en caso incorrecto:** Un **Hotspot** (pico continuo de ~100% de uso de CPU) en el `Main Thread` antes de que se renderice el primer fotograma visual.
* **Conclusión:** Se está ejecutando trabajo síncrono pesado de CPU en el hilo principal durante el arranque. Debe diferirse fuera del `Main Thread` con `Task` o mediante inicialización perezosa (`lazy`).

---

### 2. Main Thread Hang (UI Freeze)
* **Instrumento:** `System Trace`
* **Síntoma en caso incorrecto:** El `Main Thread` entra en estado **`Blocked`** durante un intervalo prolongado (>250 ms) mientras el consumo de CPU cae a **0%**. En *System Calls* se identifica una trampa de kernel como `semaphore_wait_trap`.
* **Conclusión:** El hilo principal está bloqueado esperando sincrónicamente la liberación de un recurso de otro hilo. Debe reemplazarse la espera bloqueante (`.wait()`) por suspensión asíncrona (`await`).

---

### 3. Priority Inversion
* **Instrumento:** `System Trace` (Vista de *States*)
* **Síntoma en caso incorrecto:** 
  * En la vista `States`, el `Main Thread` (QoS User Interactive / Prioridad ~47) está en estado **`Blocked`** por un cerrojo (`pthread_mutex_lock`).
  * El hilo secundario que posee el cerrojo (QoS Background / Prioridad ~4) experimenta una **`Priority Escalation`**, elevando temporalmente su prioridad a ~47.
* **Conclusión:** Un hilo de baja prioridad está reteniendo un recurso crítico del hilo UI. Se resuelve eliminando cerrojos síncronos compartidos entre distintas clases de QoS o migrando a **Swift Actors**.

---

### 4. CPU Excesivo (Algoritmo Ineficiente)
* **Instrumento:** `Time Profiler`
* **Síntoma en caso incorrecto:** Picos de consumo de CPU al **100%**. Al aplicar las opciones **`Hide System Libraries`** e **`Invert Call Tree`**, la cima de la pila expone directamente la función en Swift.
* **Conclusión:** Existe un punto caliente de procesamiento (*Hotspot*) provocado por un algoritmo ineficiente o trabajo redundante de CPU. Debe optimizarse la complejidad algorítmica o trasladarse a background.

---

### 5. Memory Leak & Memory Growth
* **Instrumentos:** `Leaks` y `Allocations`
* **Síntoma en caso incorrecto:**
  * **Memory Leak:** Tras tomar un *Snapshot*, la pista *Leaks* muestra un icono con **`⚠️ Leaks`**. En `Cycles & Roots` se observa el gráfico de un ciclo de retención fuerte (*Strong Reference Cycle*).
  * **Memory Growth:** En *Allocations*, la gráfica de `All Heap` muestra un patrón en "escalera" que crece continuamente sin volver a bajar.
* **Conclusión:** El leak proviene de referencias mutuas `strong` (requiere `weak` o `unowned`). El growth proviene de objetos retenidos en contenedores longevos sin políticas de descarte.

---

### 6. Animation Hitches (Jank en Scroll)
* **Instrumentos:** `Animation Hitches` (o `Time Profiler` en Simulador)
* **Síntoma en caso incorrecto:**
  * Caídas en la métrica **Hitch Time Ratio** con marcas amarillas/rojas.
  * En *Time Profiler*: El `Main Thread` sobrepasa el presupuesto por frame (>16.6ms a 60Hz / >8.3ms a 120Hz) ejecutando instanciaciones costosas (como `DateFormatter`) dentro del `body` de las celdas.
* **Conclusión:** Es un **Commit Hitch** provocado por ejecutar lógica síncrona pesada dentro del Render Loop de SwiftUI/UIKit. Se soluciona extrayendo o precalculando la lógica fuera de la fase de renderizado.

---

### 7. Swift Concurrency Bottlenecks
* **Instrumentos:** `Swift Concurrency` y `Time Profiler`
* **Síntoma en caso incorrecto:** A pesar de usar funciones `async`, el procesamiento pesado de CPU se muestra bajo la etiqueta del **`Main Thread`** debido a que la función pertenece al contexto de `@MainActor`. La UI se congela durante la ejecución.
* **Conclusión:** Estar en una función `async` no garantiza la migración a hilos de fondo si se está dentro de `@MainActor`. Se resuelve desvinculando la tarea con `Task.detached`, usando un `actor` dedicado o implementando **Cooperative Yielding** con `await Task.yield()`.
