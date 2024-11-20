//Titulo: Resta de dos números
//Nombre: Leonel Martinez Huitron
//Matricula: 22210777
//Materia: Lenguaje de Interfaz
//Descripción: Programa en ensamblador ARM de 64 bits que resta dos números

//SOLUCION C#
//public static int Resta(int a, int b) {
//     return a - b;
// }

//SOLUCION ARM64

.section .data
    num1: .word 15      // Primer número
    num2: .word 5       // Segundo número
    result: .word 0     // Espacio para almacenar el resultado

.section .text
    .global _start

_start:
    // Cargar los números en registros
    ldr x0, =num1       // Cargar la dirección de num1 en x0
    ldr w1, [x0]        // Cargar el valor de num1 en w1
    ldr x0, =num2       // Cargar la dirección de num2 en x0
    ldr w2, [x0]        // Cargar el valor de num2 en w2

    // Restar los números
    sub w3, w1, w2      // w3 = w1 - w2

    // Almacenar el resultado
    ldr x0, =result     // Cargar la dirección de result en x0
    str w3, [x0]        // Almacenar el resultado en la dirección de result

    // Salir del programa
    mov x8, 93          // syscall número para exit en ARM
    mov x0, 0           // Código de salida
    svc 0               // Llamar al sistema
