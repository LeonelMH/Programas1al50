//Titulo: Búsqueda lineal
//Nombre: Leonel Martinez Huitron
//Matricula: 22210777
//Materia: Lenguaje de Interfaz
//Descripción: Programa en ensamblador ARM de 64 bits que implementa una búsqueda lineal en un arreglo.

//SOLUCION C#

// int[] arreglo = {3, 5, 7, 2, 9, 1, 4};
// int valor_buscado = 7;
// bool encontrado = false;
// for (int i = 0; i < arreglo.Length; i++) {
//     if (arreglo[i] == valor_buscado) {
//         encontrado = true;
//         break;
//     }
// }
// Console.WriteLine(encontrado ? "Valor encontrado en la posicion:" : "Valor no encontrado");
//

//SOLUCION ARM64

.section .data
    arr: .quad 3, 5, 7, 2, 9, 1, 4      // Arreglo de enteros
    arr_size: .quad 7                   // Tamaño del arreglo
    target_value: .quad 7               // Valor a buscar
    found_index: .quad -1               // Variable para almacenar el índice encontrado (-1 si no se encuentra)
    found_msg: .asciz "Valor encontrado en la posición: %ld\n" // Mensaje si se encuentra
    not_found_msg: .asciz "Valor no encontrado.\n" // Mensaje si no se encuentra

.section .text
.global _start

_start:
    // Inicialización
    ldr x1, =arr                        // Cargar la dirección del arreglo en x1
    ldr x2, =arr_size                   // Cargar la dirección del tamaño del arreglo
    ldr x3, [x2]                        // Cargar el tamaño del arreglo en x3
    ldr x4, =target_value               // Cargar la dirección del valor a buscar
    ldr x5, [x4]                        // Cargar el valor a buscar en x5
    mov x6, 0                            // Inicializar el índice (i = 0)

search_loop:
    cmp x6, x3                          // Comparar índice con tamaño del arreglo
    bge not_found                       // Si i >= tamaño, ir a not_found
    ldr x7, [x1]                        // Cargar el elemento actual del arreglo
    cmp x5, x7                          // Comparar el valor a buscar con el elemento actual
    beq found                           // Si son iguales, ir a found
    add x1, x1, 8                       // Mover puntero al siguiente elemento (tamaño de 8 bytes)
    add x6, x6, 1                       // Incrementar el índice
    b search_loop                       // Repetir el bucle

found:
    // Almacenar el índice encontrado
    ldr x8, =found_index                // Cargar la dirección de found_index
    str x6, [x8]                        // Almacenar el índice encontrado

    // Imprimir el mensaje encontrado
    mov x0, 1                            // fd: stdout
    ldr x1, =found_msg                  // Cargar la dirección del mensaje
    mov x2, x6                           // El índice a imprimir
    mov x8, 64                           // syscall: write
    svc 0                                 // Llamar a la syscall

    // Salir del programa
    mov x8, 93                           // syscall: exit
    mov x0, 0                            // status: 0
    svc 0

not_found:
    // Imprimir el mensaje no encontrado
    mov x0, 1                            // fd: stdout
    ldr x1, =not_found_msg               // Cargar la dirección del mensaje
    mov x8, 64                           // syscall: write
    svc 0                                 // Llamar a la syscall

    // Salir del programa
    mov x8, 93                           // syscall: exit
    mov x0, 0                            // status: 0
    svc 0
