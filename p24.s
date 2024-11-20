// ==============================================================================
// Archivo     : longitud_cadena.s
// Descripción : Calcula la longitud de una cadena de caracteres ASCII.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 10/11/2024
// ==============================================================================

// Referencia en C# para calcular la longitud de una cadena:
// using System;
// class Program {
//     static void Main() {
//         string text = "Hello, World!";
//         int length = text.Length;
//         Console.WriteLine(length);  // Salida esperada: 13
//     }
// }

// -------------------------------
// Sección de datos
// -------------------------------
.section .data
text: .asciz "Hello, World!"      // Cadena de ejemplo

// -------------------------------
// Sección de código
// -------------------------------
.section .text
.global _start

// -------------------------------
// Función principal
// -------------------------------
_start:
    ldr x0, =text                 // Cargar la dirección de la cadena en x0
    bl LongitudCadena             // Llamar a la función de cálculo de longitud

    // Salir del programa
    mov w0, #0                    // Estado de salida 0 (éxito)
    mov x8, #93                   // Código de sistema para salir en Linux
    svc 0                         // Interrupción para invocar la salida del sistema

// -------------------------------
// Función: LongitudCadena
// Descripción: Calcula la longitud de una cadena de caracteres ASCII.
// Argumentos: x0 = dirección de la cadena
// Resultado: w1 = longitud de la cadena
// -------------------------------
LongitudCadena:
    mov w1, #0                    // Inicializar longitud a 0

longitud_loop:
    ldrb w2, [x0], #1             // Cargar siguiente byte de la cadena en w2 y avanzar puntero
    cmp w2, #0                    // Comparar con el carácter nulo ('\0')
    beq fin_longitud              // Si es nulo, fin de la cadena

    add w1, w1, #1                // Incrementar la longitud
    b longitud_loop               // Repetir para el siguiente carácter

fin_longitud:
    ret                           // Retornar, longitud en w1
