//Titulo: Búsqueda binaria
//Nombre: Leonel Martinez Huitron
//Matricula: 22210777
//Materia: Lenguaje de Interfaz
//Descripción: Programa en ensamblador ARM de 64 bits que implementa la búsqueda binaria en un arreglo.

//SOLUCION C#
// int[] arreglo = {1, 3, 4, 7, 9, 11, 15};
// int valor_buscado = 7;
// int bajo = 0;
// int alto = arreglo.Length - 1;
// bool encontrado = false;
// while (bajo <= alto) {
//     int medio = (bajo + alto) / 2;
//     if (arreglo[medio] == valor_buscado) {
//         encontrado = true;
//         Console.WriteLine("Valor encontrado en índice: " + medio);
//         break;
//     } else if (arreglo[medio] < valor_buscado) {
//         bajo = medio + 1;
//     } else {
//         alto = medio - 1;
//     }
// }
// if (!encontrado) {
//     Console.WriteLine("Valor no encontrado");
// }
//

//SOLUCION ARM64

.section .data
    arr: .quad 1, 3, 4, 7, 9, 11, 15   // Arreglo de enteros (debe estar ordenado)
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

    // Inicializar límites
    mov x6, 0                            // left = 0
    sub x7, x3, 1                        // right = arr_size - 1

binary_search_loop:
    cmp x6, x7                          // Comparar left y right
    bgt not_found                       // Si left > right, ir a not_found

    // Calcular el índice medio
    add x8, x6, x7                      // mid = left + right
    lsr x8, x8, 1                       // mid = (left + right) / 2
    ldr x9, [x1, x8, lsl #3]            // Cargar arr[mid] (8 bytes por elemento)

    cmp x5, x9                          // Comparar target_value con arr[mid]
    beq found                           // Si son iguales, ir a found
    blt update_right                    // Si target_value < arr[mid], actualizar right
    // target_value > arr[mid]
    mov x6, x8                          // left = mid
    add x6, x6, 1                       // left++

    b binary_search_loop                // Repetir el bucle

update_right:
    mov x7, x8                          // right = mid
    sub x7, x7, 1                       // right--

    b binary_search_loop                // Repetir el bucle

found:
    // Almacenar el índice encontrado
    ldr x10, =found_index               // Cargar la dirección de found_index
    str x8, [x10]                       // Almacenar el índice encontrado

    // Imprimir el mensaje encontrado
    mov x0, 1                            // fd: stdout
    ldr x1, =found_msg                  // Cargar la dirección del mensaje
    mov x2, x8                           // El índice a imprimir
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
