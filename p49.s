// ==============================================================================
// Archivo     : Leer.s 
// Descripción : Leer entrada desde el teclado en ARM64.
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
        // Leer entrada desde el teclado
//        Console.WriteLine("Ingresa algo:");
//        string input = Console.ReadLine();  // Leer la entrada del teclado

        // Imprimir lo que se ingresó
//        Console.WriteLine("Lo que ingresaste es: " + input);

        // Finalizar el programa
//        Environment.Exit(0);
//    }
//}


// -------------------------------
// Sección de código
// -------------------------------

.global _start

.section .data
buffer: .space 100   // Espacio para almacenar la cadena de entrada

.section .bss
len: .skip 4          // Almacenará la longitud de la entrada

.section .text
_start:
    // Leer desde la entrada estándar (teclado)
    mov x0, #0        // Descriptor de archivo 0 (stdin)
    adr x1, buffer    // Cargar la dirección de 'buffer' en x1
    mov x2, #100      // Leer un máximo de 100 bytes
    mov x8, #63       // Número de syscall para 'read'
    svc #0            // Llamada al sistema para leer

    // Escribir en la salida estándar (pantalla)
    mov x0, #1        // Descriptor de archivo 1 (stdout)
    adr x1, buffer    // Dirección de 'buffer' en x1
    mov x2, #100      // Longitud máxima
    mov x8, #64       // Número de syscall para 'write'
    svc #0            // Llamada al sistema para escribir

    // Terminar el programa
    mov x8, #93       // Número de syscall para 'exit'
    mov x0, #0        // Código de salida 0
    svc #0            // Llamada al sistema para terminar
