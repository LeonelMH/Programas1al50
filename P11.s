//Titulo: Verificar si una cadena es palíndromo
//Nombre: Leonel Martinez Huitron
//Matricula: 22210777
//Materia: Lenguaje de Interfaz
//Descripción: Programa en ensamblador ARM de 64 bits que verifica si una cadena es palíndromo

//SOLUCION C#
// string cadena = "anitalavalatina";
// bool esPalindromo = true;
// for (int i = 0; i < cadena.Length / 2; i++) {
//     if (cadena[i] != cadena[cadena.Length - i - 1]) {
//         esPalindromo = false;
//         break;
//     }
// }
// Console.WriteLine(esPalindromo ? "Es palíndromo" : "No es palíndromo");
//

//SOLUCION ARM64

.section .data
    input_string: .asciz "anitalavalatina"  // Cadena de entrada (puedes cambiarla por otra)
    length: .quad 0                          // Longitud de la cadena (será calculada)
    result_palindrome: .asciz "Es un palíndromo\n"   // Mensaje si es palíndromo
    result_not_palindrome: .asciz "No es un palíndromo\n" // Mensaje si no es palíndromo

.section .text
.global _start

_start:
    // Calcular la longitud de la cadena
    adr x0, input_string                 // Cargar la dirección de la cadena
    mov x1, 0                            // Inicializar contador de longitud
length_loop:
    ldrb w2, [x0, x1]                   // Cargar el siguiente byte
    cbz w2, finish_length                // Si es nulo, terminar
    add x1, x1, 1                        // Incrementar el contador
    b length_loop                        // Repetir el bucle

finish_length:
    ldr x3, =length                      // Cargar dirección de la longitud
    str x1, [x3]                         // Almacenar longitud

    // Verificar si la cadena es un palíndromo
    sub x1, x1, 1                        // x1 = longitud - 1 (índice del último carácter)
    adr x0, input_string                 // Volver al inicio de la cadena
    mov x4, 0                            // Inicializar índice para la comparación

check_palindrome:
    cmp x4, x1                           // Comparar índices
    bge is_palindrome                    // Si x4 >= x1, es palíndromo
    ldrb w5, [x0, x4]                   // Cargar carácter de inicio
    ldrb w6, [x0, x1]                   // Cargar carácter de fin
    cmp w5, w6                           // Comparar caracteres
    bne not_palindrome                   // Si son diferentes, no es palíndromo
    add x4, x4, 1                        // Incrementar índice de inicio
    sub x1, x1, 1                        // Decrementar índice de fin
    b check_palindrome                   // Repetir la comparación

is_palindrome:
    // Imprimir mensaje de palíndromo
    adr x0, result_palindrome            // Cargar dirección del mensaje
    mov x1, x0                           // Puntero a la cadena
    mov x0, 1                            // fd: stdout
    mov x2, 20                           // Longitud del mensaje (ajusta si es necesario)
    mov x8, 64                           // syscall: write
    svc 0                                 // Llamar a la syscall
    b exit_program                       // Salir

not_palindrome:
    // Imprimir mensaje de no palíndromo
    adr x0, result_not_palindrome        // Cargar dirección del mensaje
    mov x1, x0                           // Puntero a la cadena
    mov x0, 1                            // fd: stdout
    mov x2, 25                           // Longitud del mensaje (ajusta si es necesario)
    mov x8, 64                           // syscall: write
    svc 0                                 // Llamar a la syscall

exit_program:
    // Salir del programa
    mov x8, 93                           // syscall: exit
    mov x0, 0                            // status: 0
    svc 0
