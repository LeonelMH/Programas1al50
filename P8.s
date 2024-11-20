//Titulo: Serie de Fibonacci
//Nombre: Leonel Martinez Huitron
//Matricula: 22210777
//Materia: Lenguaje de Interfaz
//Descripción: Programa en ensamblador ARM de 64 bits que calcula la serie de Fibonacci.


.section .data
n: .quad 10                       // Número de elementos de Fibonacci a calcular
output: .space 80                 // Espacio para almacenar los resultados

.section .text
.global _start

_start:
    // Inicialización de variables
    ldr x0, =n                    // Cargar dirección de n
    ldr x1, [x0]                  // Cargar valor de n en x1
    mov x2, 0                     // f0 = 0
    mov x3, 1                     // f1 = 1
    mov x4, 0                     // Contador i = 0

.loop:
    cmp x4, x1                    // Comparar i con n
    bge .end_loop                 // Si i >= n, salir del bucle

    // Guardar el número Fibonacci actual
    ldr x5, =output               // Cargar dirección de output
    add x5, x5, x4, lsl 3         // Calcular la dirección de output[i]
    str x2, [x5]                  // Almacenar f0 en output[i]

    // Calcular siguiente número Fibonacci
    add x6, x2, x3                // f2 = f0 + f1
    mov x2, x3                    // f0 = f1
    mov x3, x6                    // f1 = f2

    add x4, x4, 1                 // i++

    b .loop                       // Volver al inicio del bucle

.end_loop:
    // Salir del programa
    mov x8, 93                    // syscall: exit
    mov x0, 0                     // status: 0
    svc 0
