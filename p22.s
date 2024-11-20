// ==============================================================================
// Archivo     : ascii_a_entero.s
// Descripción : Convierte una cadena ASCII de dígitos en su valor entero.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 10/11/2024
// ==============================================================================

// Referencia en C# para la conversión ASCII a entero:
// using System;
// class Program {
//     static void Main() {
//         string asciiNumber = "1234";
//         int result = 0;
//
//         foreach (char c in asciiNumber) {
//             result = result * 10 + (c - '0');  // Convertir ASCII a entero
//         }
//
//         Console.WriteLine(result); // Salida esperada: 1234
//     }
// }

// -------------------------------
// Sección de datos
// -------------------------------
.section .data
asciiNumber: .asciz "1234"       // Cadena ASCII de ejemplo

.section .text
.global _start

// -------------------------------
// Función principal
// -------------------------------
_start:
    ldr x0, =asciiNumber          // Cargar dirección de la cadena ASCII en x0
    bl AsciiAEntero               // Llamar a la función de conversión

    // Salir del programa
    mov w0, #0                    // Estado de salida 0 (éxito)
    mov x8, #93                   // Código de sistema para salir en Linux
    svc 0                         // Interrupción para invocar la salida del sistema

// -------------------------------
// Función: AsciiAEntero
// Descripción: Convierte una cadena de caracteres ASCII a un entero.
// Argumentos: x0 = dirección de la cadena ASCII
// Resultado: w1 = valor entero convertido
// -------------------------------
AsciiAEntero:
    mov w1, #0                    // Inicializar resultado a 0
    mov w3, #10
ascii_loop:
    ldrb w2, [x0], #1             // Cargar siguiente carácter ASCII en w2 y avanzar puntero
    cmp w2, #0                    // Verificar si es el carácter nulo ('\0')
    beq fin_conversion            // Si es '\0', fin de la cadena

    sub w2, w2, #'0'              // Convertir carácter ASCII a valor numérico
    mul w1, w1, w3               // Multiplicar resultado acumulado por 10
    add w1, w1, w2                // Sumar el dígito convertido al resultado

    b ascii_loop                  // Repetir para el siguiente carácter

fin_conversion:
    ret                           // Retornar, resultado en w1
