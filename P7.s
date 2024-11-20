//Titulo: Factorial de un número
//Nombre: Leonel Martinez Huitron
//Matricula: 22210777
//Materia: Lenguaje de Interfaz
//Descripción: Programa en ensamblador ARM de 64 bits que calcula el factorial de un número natural N.


.section .data
    N: .word 5                // Número del cual calcular el factorial
    factorial: .word 1        // Espacio para almacenar el resultado (inicialmente 1)

.section .text
    .global _start

_start:
    // Cargar el valor de N
    ldr x1, =N                // Cargar la dirección de N en x1
    ldr w1, [x1]              // Cargar el valor de N en w1 (32 bits)

    // Inicializar el acumulador y el contador
    mov w2, 1                 // w2 será el acumulador (factorial, inicializado en 1)
    mov w3, 1                 // w3 será el contador (inicializado en 1)

factorial_loop:
    cmp w3, w1                // Comparar el contador (w3) con N (w1)
    bgt end_factorial         // Si w3 > N, salir del bucle

    mul w2, w2, w3            // Multiplicar el acumulador (w2) por el contador (w3)
    add w3, w3, 1             // Incrementar el contador (w3)
    b factorial_loop          // Volver al inicio del bucle

end_factorial:
    // Almacenar el resultado
    ldr x0, =factorial        // Cargar la dirección de factorial en x0
    str w2, [x0]              // Almacenar el resultado en factorial

    // Salir del programa
    mov x8, 93                // syscall número para exit en ARM
    mov x0, 0                 // Código de salida
    svc 0                     // Llamar al sistema
