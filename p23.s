// ==============================================================================
// Archivo     : entero_a_ascii.s
// Descripción : Convierte un número entero a su representación en ASCII.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 10/11/2024
// ==============================================================================

// Referencia en C# para la conversión de entero a ASCII:
// using System;
// class Program {
//     static void Main() {
//         int number = 1234;
//         string result = number.ToString();
//         Console.WriteLine(result);  // Salida esperada: "1234"
//     }
// }

// -------------------------------
// Sección de datos
// -------------------------------
.section .data
buffer: .space 12                // Buffer para almacenar el resultado (espacio para hasta 10 dígitos + nulo)

// -------------------------------
// Sección de código
// -------------------------------
.section .text
.global _start

// -------------------------------
// Función principal
// -------------------------------
_start:
    mov w0, #1234                // Número entero a convertir
    ldr x1, =buffer              // Dirección del buffer para almacenar el resultado
    bl EnteroAAscii              // Llamar a la función de conversión

    // Salir del programa
    mov w0, #0                   // Estado de salida 0 (éxito)
    mov x8, #93                  // Código de sistema para salir en Linux
    svc 0                        // Interrupción para invocar la salida del sistema

// -------------------------------
// Función: EnteroAAscii
// Descripción: Convierte un número entero en ASCII decimal.
// Argumentos: w0 = número a convertir, x1 = buffer para almacenar la cadena ASCII
// Resultado: El buffer en x1 contiene la representación ASCII del número en w0
// -------------------------------
EnteroAAscii:
    mov x2, x1                   // Guardar la dirección inicial del buffer en x2
    add x1, x1, #10              // Apuntar x1 al final del espacio para dígitos
    mov w3, #10                  // Divisor constante (10)

convert_loop:
    udiv w4, w0, w3              // w4 = w0 / 10 (parte entera)
    msub w5, w4, w3, w0          // w5 = w0 - (w4 * 10), es decir, w5 = w0 % 10 (residuo)
    add w5, w5, #'0'             // Convertir el dígito a ASCII ('0' = 48)
    sub x1, x1, #1               // Retroceder una posición en el buffer
    strb w5, [x1]                // Almacenar el dígito ASCII en el buffer

    mov w0, w4                   // Actualizar w0 con la parte entera para la siguiente iteración
    cmp w0, #0                   // Si w0 == 0, hemos terminado
    bne convert_loop             // Repetir hasta que el número sea 0

    // Mover la cadena convertida al inicio del buffer
    mov x0, x2                   // Dirección base del buffer en x0
    add x1, x1, #10              // Apuntar al final de los dígitos en x1
    sub x1, x1, x0               // Calcular el tamaño de la cadena en x1
    ret                          // Retornar