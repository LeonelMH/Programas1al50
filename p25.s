// ==============================================================================
// Archivo     : contar_vocales_consonantes.s
// Descripción : Cuenta las vocales y consonantes en una cadena ASCII.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 10/11/2024
// ==============================================================================

// Referencia en C# para contar vocales y consonantes:
// using System;
// class Program {
//     static void Main() {
//         string text = "Hello, World!";
//         int vowels = 0, consonants = 0;
//
//         foreach (char c in text.ToLower()) {
//             if ("aeiou".Contains(c)) vowels++;
//             else if (char.IsLetter(c)) consonants++;
//         }
//
//         Console.WriteLine($"Vowels: {vowels}, Consonants: {consonants}");
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
    bl ContarVocalesConsonantes   // Llamar a la función de conteo

    // Salir del programa
    mov w0, #0                    // Estado de salida 0 (éxito)
    mov x8, #93                   // Código de sistema para salir en Linux
    svc 0                         // Interrupción para invocar la salida del sistema

// -------------------------------
// Función: ContarVocalesConsonantes
// Descripción: Cuenta las vocales y consonantes en una cadena ASCII.
// Argumentos: x0 = dirección de la cadena
// Resultados: w1 = cantidad de vocales, w2 = cantidad de consonantes
// -------------------------------
ContarVocalesConsonantes:
    mov w1, #0                    // Inicializar conteo de vocales a 0
    mov w2, #0                    // Inicializar conteo de consonantes a 0

conteo_loop:
    ldrb w3, [x0], #1             // Cargar siguiente carácter en w3 y avanzar el puntero
    cmp w3, #0                    // Verificar si es el carácter nulo ('\0')
    beq fin_conteo                // Si es nulo, fin de la cadena

    // Convertir el carácter a minúscula (A-Z -> a-z)
    cmp w3, #'A'                  // Comparar con 'A'
    blt siguiente_char            // Si es menor que 'A', no es letra
    cmp w3, #'Z'                  // Comparar con 'Z'
    bgt verificar_minuscula       // Si es mayor que 'Z', verificar si es minúscula
    orr w3, w3, #0x20             // Convertir a minúscula (A-Z -> a-z)

verificar_minuscula:
    cmp w3, #'a'                  // Comparar con 'a'
    blt siguiente_char            // Si es menor que 'a', no es letra
    cmp w3, #'z'                  // Comparar con 'z'
    bgt siguiente_char            // Si es mayor que 'z', no es letra

    // Verificar si el carácter es vocal
    mov w4, w3                    // Copiar el carácter en w4 para comparar
    cmp w4, #'a'                  // Comparar con 'a'
    beq es_vocal
    cmp w4, #'e'                  // Comparar con 'e'
    beq es_vocal
    cmp w4, #'i'                  // Comparar con 'i'
    beq es_vocal
    cmp w4, #'o'                  // Comparar con 'o'
    beq es_vocal
    cmp w4, #'u'                  // Comparar con 'u'
    beq es_vocal

    // Si no es vocal, contar como consonante
    add w2, w2, #1                // Incrementar contador de consonantes
    b siguiente_char              // Saltar al siguiente carácter

es_vocal:
    add w1, w1, #1                // Incrementar contador de vocales

siguiente_char:
    b conteo_loop                 // Repetir para el siguiente carácter

fin_conteo:
    ret                           // Retornar, w1 = vocales, w2 = consonantes
