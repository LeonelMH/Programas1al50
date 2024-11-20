// ==============================================================================
// Archivo     : desplazamientos.s
// Descripción : Realiza desplazamientos a la izquierda y derecha en un entero.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 10/11/2024
// ==============================================================================

// Referencia en C# para desplazamientos a la izquierda y derecha:
// using System;
// class Program {
//     static void Main() {
//         int a = 0b0001_1010;   // 26 en binario (0001 1010)
//
//         int leftShift = a << 2;  // Desplazamiento a la izquierda
//         int rightShift = a >> 2; // Desplazamiento a la derecha
//
//         Console.WriteLine($"Left Shift: {Convert.ToString(leftShift, 2)}");  // "110100"
//         Console.WriteLine($"Right Shift: {Convert.ToString(rightShift, 2)}"); // "000110"
//     }
// }

// -------------------------------
// Sección de código
// -------------------------------
.section .text
.global _start

// -------------------------------
// Función principal
// -------------------------------
_start:
    mov w0, #0b00011010           // Valor inicial (26 en decimal, 0001 1010 en binario)

    // Desplazamiento a la izquierda
    lsl w1, w0, #2                // Desplaza w0 dos bits a la izquierda y almacena en w1
                                  // Resultado esperado: 0b01101000 (104 en decimal)

    // Desplazamiento a la derecha
    lsr w2, w0, #2                // Desplaza w0 dos bits a la derecha y almacena en w2
                                  // Resultado esperado: 0b00000110 (6 en decimal)

    // Salir del programa
    mov w0, #0                    // Estado de salida 0 (éxito)
    mov x8, #93                   // Código de sistema para salir en Linux
    svc 0                         // Interrupción para invocar la salida del sistema
