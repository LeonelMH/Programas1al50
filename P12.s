//Titulo: Encontrar el máximo en un arreglo
//Nombre: Leonel Martinez Huitron
//Matricula: 22210777
//Materia: Lenguaje de Interfaz
//Descripción: Programa en ensamblador ARM de 64 bits que encuentra el valor máximo en un arreglo.

//SOLUCION C#

// int[] arreglo = {3, 5, 7, 2, 9, 1, 4};
// int maximo = arreglo[0];
// for (int i = 1; i < arreglo.Length; i++) {
//     if (arreglo[i] > maximo) {
//         maximo = arreglo[i];
//     }
// }
// Console.WriteLine("Máximo: " + maximo);


// SOLUCION ARM64

.section .data
    arr: .quad 3, 5, 7, 2, 9, 1, 4      // Arreglo de enteros
    arr_size: .quad 7                   // Tamaño del arreglo
    result_msg: .asciz "El máximo es: %ld\n" // Mensaje para imprimir el máximo

.section .bss
    max_value: .quad 0                  // Variable para almacenar el máximo

.section .text
.global _start

_start:
    // Inicialización
    ldr x1, =arr                        // Cargar la dirección del arreglo en x1
    ldr x2, =arr_size                   // Cargar la dirección del tamaño del arreglo
    ldr x3, [x2]                        // Cargar el tamaño del arreglo en x3
    ldr x4, [x1]                        // Cargar el primer elemento del arreglo como máximo
    add x1, x1, 8                       // Mover puntero al siguiente elemento (tamaño de 8 bytes)

    // Bucle para encontrar el máximo
find_max:
    subs x3, x3, 1                      // Decrementar el contador
    ble print_max                       // Si el contador es menor o igual a cero, imprimir el máximo
    ldr x5, [x1]                        // Cargar el siguiente elemento del arreglo
    cmp x4, x5                          // Comparar el máximo actual con el siguiente elemento
    csel x4, x4, x5, gt                // Si x5 es mayor, actualizar el máximo
    add x1, x1, 8                       // Mover puntero al siguiente elemento (tamaño de 8 bytes)
    b find_max                          // Repetir el bucle

print_max:
    // Almacenar el máximo en la sección BSS
    ldr x6, =max_value                  // Cargar la dirección de max_value
    str x4, [x6]                        // Almacenar el máximo

    // Imprimir el resultado
    mov x0, 1                            // fd: stdout
    ldr x1, =result_msg                 // Cargar la dirección del mensaje
    mov x2, x4                           // El máximo a imprimir
    mov x8, 64                           // syscall: write
    svc 0                                 // Llamar a la syscall

    // Salir del programa
    mov x8, 93                           // syscall: exit
    mov x0, 0                            // status: 0
    svc 0
