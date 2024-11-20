// ==============================================================================
// Archivo     : operaciones_bitwise.s
// Descripción : Realiza operaciones AND, OR, y XOR a nivel de bits en dos enteros.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 10/11/2024
// ==============================================================================

// Referencia en C# para operaciones AND, OR, XOR a nivel de bits:
// using System;
// class Program {
//     static void Main() {
//         int a = 0b1010;  // 10 en binario (1010)
//         int b = 0b1100;  // 12 en binario (1100)
//
//         int andResult = a & b;   // AND bit a bit
//         int orResult = a | b;    // OR bit a bit
//         int xorResult = a ^ b;   // XOR bit a bit
//
//         Console.WriteLine($"AND: {Convert.ToString(andResult, 2)}"); // "1000"
//         Console.WriteLine($"OR: {Convert.ToString(orResult, 2)}");   // "1110"
//         Console.WriteLine($"XOR: {Convert.ToString(xorResult, 2)}"); // "0110"
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
    mov w0, #0b1010              // Primer valor (a = 0b1010 o 10 en decimal)
    mov w1, #0b1100              // Segundo valor (b = 0b1100 o 12 en decimal)

    // Operación AND
    and w2, w0, w1               // w2 = w0 & w1 (AND bit a bit)

    // Operación OR
    orr w3, w0, w1               // w3 = w0 | w1 (OR bit a bit)

    // Operación XOR
    eor w4, w0, w1               // w4 = w0 ^ w1 (XOR bit a bit)

    // Salir del programa
    mov w0, #0                   // Estado de salida 0 (éxito)
    mov x8, #93                  // Código de sistema para salir en Linux
    svc 0                        // Interrupción para invocar la salida del sistema
