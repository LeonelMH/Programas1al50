//Titulo: Ordenamiento por selección
//Nombre: Leonel Martinez Huitron
//Matricula: 22210777
//Materia: Lenguaje de Interfaz
//Descripción: Programa en ensamblador ARM de 64 bits que realiza el ordenamiento por selección

//SOLUCION C#

// int[] arreglo = {5, 3, 8, 6, 2};
// int n = arreglo.Length;
// for (int i = 0; i < n - 1; i++) {
//     int min_idx = i;
//     for (int j = i + 1; j < n; j++) {
//         if (arreglo[j] < arreglo[min_idx]) {
//             min_idx = j;
//         }
//     }
//     // Intercambia arreglo[i] y arreglo[min_idx]
//     int temp = arreglo[i];
//     arreglo[i] = arreglo[min_idx];
//     arreglo[min_idx] = temp;
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
    sxth x1, w1  // Extender w1 a 64 bits
    ldr x2, =array

    // Iterar sobre cada elemento como elemento mínimo potencial
    mov x3, #0  // i = 0
outer_loop:
    cmp x3, x1
    bge end

    // Asumir que el elemento actual es el mínimo
    mov x4, x3  // min_index = i
    mov x5, x3  // j = i

inner_loop:
    cmp x5, x1
    bge end_inner

    // Calcular direcciones de los elementos a comparar
    lsl x6, x5, #2  // x6 = base + j * 4
    ldr w7, [x6]
    lsl x8, x4, #2  // x8 = base + min_index * 4
    ldr w9, [x8]

    // Si el elemento actual es menor, actualizar min_index
    cmp w7, w9
    blt update_min

    // Incrementar j
    add x5, x5, #1
    b inner_loop

update_min:
    mov x4, x5
    b inner_loop

end_inner:
    // Intercambiar el mínimo con el elemento actual
    lsl x6, x3, #2  // x6 = base + i * 4
    lsl x8, x4, #2  // x8 = base + min_index * 4
    ldr w7, [x6]
    ldr w9, [x8]
    str w9, [x6]
    str w7, [x8]

    // Incrementar i
    add x3, x3, #1
    b outer_loop

end:
    // Terminar el programa
    mov x0, #0
    mov x8, #93
    svc 0