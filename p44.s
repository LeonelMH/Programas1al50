// ==============================================================================
// Archivo     : Generacion.s 
// Descripción : Generación de números aleatorios (con semilla) en ARM64.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 10/11/2024
// ==============================================================================

//Equivalente en C#:

//using System;

//class RandomNumberGenerator
//{
//    static void Main()
//    {
        // Semilla inicial
 //       int seed = 12345;

        // Valor máximo para el número aleatorio
//        int maxValue = 100;

        // Crear una instancia de Random con la semilla
//        Random random = new Random(seed);

        // Generar un número aleatorio en el rango de 0 a maxValue - 1
//        int randomNumber = random.Next(maxValue);

        // Mostrar el número aleatorio generado
//        Console.WriteLine("Número aleatorio generado: " + randomNumber);
//    }
//}


// -------------------------------
// Sección de código
// -------------------------------

.global _start

.section .data
    seed: .word 12345         // Semilla inicial
    max_value: .word 100      // Valor máximo para el número aleatorio (ej. 0-99)

.section .text
_start:
    // Cargar la semilla
    ldr x0, =seed            // Cargar la dirección de la semilla en x0
    ldr w1, [x0]             // Cargar la semilla en w1

    // Cargar el valor máximo
    ldr x0, =max_value       // Cargar la dirección del valor máximo en x0
    ldr w2, [x0]             // Cargar el valor máximo en w2

    // Algoritmo simple para generación de números pseudoaleatorios (con semilla)
    mov w3, w1               // Copiar semilla a w3
    mul w3, w3, w3           // w3 = semilla * semilla
    add w3, w3, w1           // w3 = w3 + semilla
    mov w1, w3               // Guardar el nuevo valor de la semilla

    // Modificar el valor aleatorio por el valor máximo
    udiv w3, w1, w2          // Dividir el número generado por el valor máximo
    mul w3, w3, w2           // Multiplicar el cociente por el valor máximo
    sub w3, w1, w3           // Restar el producto para obtener el residuo (número aleatorio)

    // El número aleatorio ahora está en w3

    // Aquí podrías hacer algo con el número aleatorio, como imprimirlo

    // Terminar el programa
    mov x8, #93              // Número de syscall para exit en Linux ARM64
    svc #0                    // Llamada al sistema para terminar
