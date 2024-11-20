//Titulo: Suma de los N primeros números naturales
//Nombre: Leonel Martinez Huitron
//Matricula: 22210777
//Materia: Lenguaje de Interfaz
//Descripción: Programa en ensamblador ARM de 64 bits que calcula la suma de los primeros N números naturales.


.section .data
    N: .word 10            // Número hasta el que sumar
    sum: .word 0           // Espacio para almacenar la suma

.section .text
    .global _start

_start:
    // Inicializar registros
    ldr x1, =N             // Cargar la dirección de N en x1
    ldr w1, [x1]           // Cargar el valor de N en w1 (32 bits)
    mov w2, 0              // w2 será el acumulador (suma)
    mov w3, 1              // w3 será el contador (de 1 a N)

loop:
    cmp w3, w1             // Comparar contador (w3) con N (w1)
    bgt end_loop           // Si w3 > N, salir del bucle

    add w2, w2, w3         // Sumar el contador (w3) al acumulador (w2)
    add w3, w3, 1          // Incrementar el contador (w3)
    b loop                 // Volver al inicio del bucle

end_loop:
    // Almacenar el resultado
    ldr x0, =sum           // Cargar la dirección de sum en x0
    str w2, [x0]           // Almacenar la suma en sum

    // Salir del programa
    mov x8, 93             // syscall número para exit en ARM
    mov x0, 0              // Código de salida
    svc 0                  // Llamar al sistema
