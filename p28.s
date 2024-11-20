// ==============================================================================
// Archivo     : BitOperations.s 
// Descripción : Establecer, borrar y alternar bits en ARM64.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 10/11/2024
// ==============================================================================

//Equivalente en C#:
//using System;
//
//class Program {
//    static void Main() {
//        int valor = 0b0000_1010;  // Valor inicial en binario (10 en decimal)
//        int mask = 0b0000_0100;   // Máscara de bits para manipulación (4 en decimal)
//        
        // Establecer un bit (OR)
//        valor |= mask;            // Ahora valor es 0b0000_1110 (14 en decimal)
//        
//        // Borrar un bit (AND con NOT)
//        valor &= ~mask;           // Ahora valor es 0b0000_1010 (10 en decimal)
//        
        // Alternar un bit (XOR)
//        valor ^= mask;            // Ahora valor es 0b0000_1110 (14 en decimal)
//        
//        Console.WriteLine("Resultado: " + Convert.ToString(valor, 2));
//    }
//}
//

// -------------------------------
// Sección de código
// -------------------------------

.global _start                 // Punto de entrada del programa

.section .data
valor: .word 0b00001010        // Valor inicial: 0b00001010 (10 en decimal)
mask: .word 0b00000100         // Máscara: 0b00000100 (4 en decimal)

.section .text
_start:
    // Cargar valor y máscara en registros
    ldr w0, =valor              // Dirección de `valor` en w0
    ldr w1, [w0]                // Cargar el valor actual en w1
    ldr x0, =mask               // Dirección de `mask` en w0
    ldr w2, [x0]                // Cargar la máscara en w2

    // Establecer un bit con OR (valor |= mask)
    orr w3, w1, w2              // OR entre w1 y w2, guardar en w3

    // Borrar un bit con AND y NOT (valor &= ~mask)
    mvn w4, w2                  // Invertir máscara y guardar en w4 (~mask)
    and w5, w1, w4              // AND entre w1 y w4, guardar en w5

    // Alternar un bit con XOR (valor ^= mask)
    eor w6, w1, w2              // XOR entre w1 y w2, guardar en w6

    // Finalizar ejecución
    mov x8, #93                 // Número de syscall para salir en Linux ARM64
    svc #0                      // Llamada al sistema para terminar