// ==============================================================================
// Archivo     : CountSetBits.s  
// Descripción : Establecer, borrar y alternar bits en ARM64.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 10/11/2024
// ==============================================================================

//Equivalente en C#:
//using System;

//class Program {
//    static void Main() {
//        int valor = 29; // 29 en binario es 0001 1101
//        int contador = 0;
        
//        while (valor > 0) {
//            contador += valor & 1;  // Incrementa si el bit menos significativo es 1
//            valor >>= 1;            // Desplaza valor a la derecha
//        }
        
//        Console.WriteLine("Bits activados: " + contador);
//    }
//}

// -------------------------------
// Sección de código
// -------------------------------

.global _start                  // Punto de entrada

.section .data
valor: .word 29                 // Valor inicial, 29 en decimal (0001 1101 en binario)

.section .text
_start:
    ldr x0, =valor              // Cargar la dirección de `valor` en x0
    ldr w1, [x0]                // Cargar el valor en w1
    mov w2, #0                  // Inicializar contador en 0 en w2

contar_bits:
    and w3, w1, #1              // Obtener el bit menos significativo de w1
    add w2, w2, w3              // Sumarlo al contador en w2
    lsr w1, w1, #1              // Desplazar w1 una posición a la derecha
    cmp w1, #0                  // Comparar w1 con 0
    bne contar_bits             // Repetir mientras w1 no sea 0

    // El resultado final (conteo de bits activados) está en w2

    // Syscall para salir con el conteo como código de salida
    mov x0, x2                  // Mover el contador a x0 para usarlo como código de salida
    mov x8, #93                 // Número de syscall para exit en Linux ARM64
    svc #0                      // Llamada al sistema para terminar