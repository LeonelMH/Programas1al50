//Titulo: Ordenamiento burbuja
//Nombre: Leonel Martinez Huitron
//Matricula: 22210777
//Materia: Lenguaje de Interfaz
//Descripción: Programa en ensamblador ARM de 64 bits que realiza el ordenamiento burbuja

//SOLUCION C#

// int[] arreglo = {5, 3, 8, 6, 2};
// int n = arreglo.Length;
// for (int i = 0; i < n - 1; i++) {
//     for (int j = 0; j < n - i - 1; j++) {
//         if (arreglo[j] > arreglo[j + 1]) {
//             int temp = arreglo[j];
//             arreglo[j] = arreglo[j + 1];
//             arreglo[j + 1] = temp;
//         }
//     }
// }

//SOLUCION ARM64
.section .data
array:  .int 5, 3, 8, 6, 2
size:   .int 5

.section .text
.global _start

_start:
    // Cargar el tamaño del arreglo y las direcciones
    ldr x0, =size
    ldr w1, [x0]
    ldr x2, =array

outer_loop:
    mov w3, #0
outer_loop_condition:
    cmp w3, w1
    bge end_outer_loop

    mov w4, #0
inner_loop:
    cmp w4, w1
    sub w5, w1, #1
    cmp w4, w5
    bge end_inner_loop

    // Calcular direcciones de los elementos a comparar
    lsl w4, w4, #2  // Multiplica w4 por 4
    sxth x4, w4      // Extender w4 a 64 bits
    add x6, x2, x4  // x6 = base + j * 4
    add x7, x6, #4  // x7 = base + (j + 1) * 4

    // Cargar elementos a comparar
    ldr w8, [x6]
    ldr w9, [x7]

    // Comparar y swap si necesario
    cmp w8, w9
    bgt swap

    // No swap, continuar
    b no_swap

swap:
    str w9, [x6]
    str w8, [x7]

no_swap:
    add w4, w4, #1
    b inner_loop

end_inner_loop:
    add w3, w3, #1
    b outer_loop

end_outer_loop:
    // Terminar el programa
    mov x0, #0
    mov x8, #93
    svc 0