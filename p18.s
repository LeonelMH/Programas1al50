// ==============================================================================
// Archivo     : merge_sort.s
// Descripción : Implementación de ordenamiento por mezcla (Merge Sort) en ARM64.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 09/11/2024
// ==============================================================================

// Equivalente en C# para referencia:
// using System;
// class Program {
//     static void MergeSort(int[] arr, int left, int right) {
//         if (left < right) {
//             int mid = left + (right - left) / 2;
//             MergeSort(arr, left, mid);
//             MergeSort(arr, mid + 1, right);
//             Merge(arr, left, mid, right);
//         }
//     }
//     
//     static void Merge(int[] arr, int left, int mid, int right) {
//         // Función de mezcla que combina dos subarreglos.
//     }
// }

//-------------------------------
// Sección de datos
// -------------------------------
.section .data
array:      .word 38, 27, 43, 3, 9, 82, 10  // Ejemplo de arreglo a ordenar
array_len:  .word 7                         // Longitud del arreglo
temp:       .space 28                       // Espacio temporal para mezclar

// -------------------------------
// Sección de texto (código)
// -------------------------------
.section .text
.global _start

_start:
    // Inicializar registros de la pila y llamar a la función MergeSort.
    ldr w0, =array            // Cargar la dirección base del arreglo en w0
    ldr w1, =0                // Límite izquierdo (left) en w1
    ldr w2, =array_len        // Cargar longitud del arreglo en w2
    sub w2, w2, #1            // Límite derecho (right) = array_len - 1

    // Llamada a MergeSort
    bl MergeSort

    // Salida del programa
    mov w0, #0                // Estado de salida 0 (indica éxito)
    mov x8, #93               // Código de sistema para salir en Linux
    svc 0                     // Interrupción para invocar la salida del sistema

// -------------------------------
// Función: MergeSort
// Descripción: Implementa la recursión de MergeSort
// Argumentos: x0 = dirección base del arreglo, w1 = límite izquierdo, w2 = límite derecho
// -------------------------------
MergeSort:
    cmp w1, w2                // Comparar left y right
    bge fin_merge_sort        // Si left >= right, retornar

    // Calcular mid = (left + right) / 2
    add w3, w1, w2
    asr w3, w3, #1            // Shift aritmético para dividir por 2 (mid)

    // Llamar recursivamente a MergeSort para la primera mitad
    mov w4, w3                // Guardar mid en w4
    bl MergeSort

    // Llamar recursivamente a MergeSort para la segunda mitad
    add w4, w3, #1            // mid + 1 para el inicio de la segunda mitad
    bl MergeSort

    // Llamar a la función de mezcla para combinar ambas mitades
    mov w4, w3                // Pasar mid como tercer parámetro
    bl Merge

fin_merge_sort:
    ret

// -------------------------------
// Función: Merge
// Descripción: Combina dos subarreglos ordenados en uno solo.
// Argumentos: x0 = dirección base del arreglo, w1 = left, w2 = mid, w3 = right
// -------------------------------
Merge:
    // Implementación de la función Merge en ARM64
    // A completar según las necesidades de ordenamiento de cada subarreglo
    // Aquí se realizarán las copias de los elementos a la sección temporal, luego
    // se reintegrarán en el arreglo principal en orden ascendente.
    // El código exacto depende de los registros y los índices que uses para copiar
    // los datos y combinar los subarreglos.
    ret
