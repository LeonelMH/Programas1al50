// ==============================================================================
// Archivo     : Desbordamiento.s 
// Descripción : Detección de desbordamiento en suma en ARM64.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 10/11/2024
// ==============================================================================

//Equivalente en C#:

//using System;

//class Program
//{
//    static void Main()
//    {
//        try
//        {
//            int a = int.MaxValue;  // Valor máximo de un entero de 32 bits
//            int b = 1;              // Valor pequeño para causar desbordamiento

            // Realizar la suma con comprobación de desbordamiento
//            int result = checked(a + b);

//            Console.WriteLine("Resultado: " + result);
//        }
//        catch (OverflowException)
//        {
//            Console.WriteLine("¡Desbordamiento detectado!");
//        }
//    }
//}


// -------------------------------
// Sección de código
// -------------------------------

.global _start

.section .text
_start:
    // Cargar los valores en los registros
    mov w0, #2147483647     // Primer operando (valor máximo de un entero de 32 bits con signo)
    mov w1, #1               // Segundo operando (un valor pequeño que causará desbordamiento al sumarlo)

    // Realizar la suma, y actualizamos las banderas del procesador
    adds w2, w0, w1          // Suma de w0 y w1, el resultado va en w2, y las banderas de estado se actualizan

    // Verificar si ocurrió un desbordamiento
    bvs overflow_detected    // Si la bandera de Overflow está activada, saltamos a 'overflow_detected'

    // Si no hubo desbordamiento
    mov x8, #93              // Syscall número 93 (exit)
    mov x0, #0               // Código de salida (0, sin errores)
    svc #0                   // Llamada al sistema para salir

overflow_detected:
    // Si hubo desbordamiento
    mov x8, #93              // Syscall número 93 (exit)
    mov x0, #1               // Código de salida (1, indicando desbordamiento)
    svc #0                   // Llamada al sistema para salir
