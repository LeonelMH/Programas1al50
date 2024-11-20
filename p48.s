// ==============================================================================
// Archivo     : Ejecucion.s 
// Descripción : Medir el tiempo de ejecución de una función en ARM64.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 10/11/2024
// ==============================================================================

//Equivalente en C#:

//using System;
//using System.Diagnostics;

//class Program
//{
//    static void Main()
//    {
        // Crear un Stopwatch para medir el tiempo
 //       Stopwatch stopwatch = new Stopwatch();

        // Iniciar el cronómetro
 //       stopwatch.Start();

        // Llamada a la función que queremos medir
 //       SampleFunction();

        // Detener el cronómetro
 //       stopwatch.Stop();

        // Mostrar el tiempo transcurrido en milisegundos
//        Console.WriteLine($"Tiempo de ejecución: {stopwatch.ElapsedMilliseconds} ms");
//    }

//    static void SampleFunction()
//    {
        // Simulación de trabajo con un bucle
//        int count = 1000000;
//        while (count > 0)
//        {
//            count--;
//        }
//    }
//}


// -------------------------------
// Sección de código
// -------------------------------
.global _start                   // Punto de entrada del programa

.section .text
_start:
    // Iniciar el contador de ciclos
    mrs x1, CNTVCT_EL0              // Leer el contador de ciclos (actual)
    mov x2, #0                      // Para mantener el valor de la diferencia
    bl funcion_a_medirmedida        // Llamar a la función a medir

    mrs x3, CNTVCT_EL0              // Leer el contador de ciclos después de la función
    sub x2, x3, x1                  // Calcular el tiempo transcurrido en ciclos

    // Almacenar el resultado del tiempo transcurrido en x2
    mov x0, x2                      // Mover el valor de tiempo transcurrido a x0
    mov x8, #93                     // Syscall para terminar el programa
    svc #0                          // Llamada al sistema para terminar el programa

// Función que queremos medir
funcion_a_medirmedida:
    // Implementar aquí el código de la función que quieres medir
    // Cargar un valor grande en x4
    movz x4, #0x2710                // Cargar los primeros 16 bits del número
    movk x4, #0x2710, lsl 16        // Cargar los siguientes 16 bits
    movk x4, #0x2710, lsl 32        // Cargar los siguientes 16 bits
    movk x4, #0x2710, lsl 48        // Cargar los últimos 16 bits

    // Aquí puedes colocar el resto de tu código que quieres medir
    ret                              // Retornar de la función
