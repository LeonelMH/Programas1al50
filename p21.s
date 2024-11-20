// ==============================================================================
// Archivo     : transposicion_matriz.s
// Descripción : Transposición de una matriz de tamaño 3x3 y almacenamiento en una segunda matriz.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 09/11/2024
// ==============================================================================

// Equivalente en C# para referencia:
// using System;
// class Program {
//    static void Main() {
//        int[,] A = { {1, 2, 3}, {4, 5, 6}, {7, 8, 9} };
//        int[,] T = new int[3, 3];
//        
//        for (int i = 0; i < 3; i++) {
//            for (int j = 0; j < 3; j++) {
//                T[j, i] = A[i, j];  // Asignar el elemento transpuesto
//           }
//        }

        // Imprimir la matriz transpuesta
//        for (int i = 0; i < 3; i++) {
//            for (int j = 0; j < 3; j++) {
//                Console.Write(T[i, j] + " ");
//            }
//            Console.WriteLine();
//        }
//    }
//}

// ARM64
.section .data
matrixA: .word 1, 2, 3, 4, 5, 6, 7, 8, 9        // Matriz A de 3x3
matrixT: .space 36                              // Matriz T (resultado de la transposición)

.section .text
.global _start

// -------------------------------
// Función principal
// -------------------------------
_start:
    mov w0, #3                    // Número de filas
    mov w1, #3                    // Número de columnas

    // Cargar direcciones base de las matrices
    ldr x2, =matrixA              // Dirección base de matrixA
    ldr x3, =matrixT              // Dirección base de matrixT (transpuesta)

    // Llamar a la función de transposición
    bl TransponerMatriz

    // Salir del programa
    mov w0, #0                    // Estado de salida 0 (éxito)
    mov x8, #93                   // Código de sistema para salir en Linux
    svc 0                         // Interrupción para invocar la salida del sistema

// -------------------------------
// Función: TransponerMatriz
// Descripción: Calcula la transpuesta de la matriz A y la almacena en la matriz T.
// Argumentos: w0 = filas, w1 = columnas, x2 = matriz A, x3 = matriz T
// -------------------------------
TransponerMatriz:
    mov w4, #0                    // Índice i (filas de A)
fila_loop:
    cmp w4, w0                    // Comparar i con el número de filas
    bge fin_transposicion         // Si i >= filas, terminar

    mov w5, #0                    // Índice j (columnas de A)
columna_loop:
    cmp w5, w1                    // Comparar j con el número de columnas
    bge siguiente_fila            // Si j >= columnas, ir a la siguiente fila

    // Calcular el índice de A[i][j]
    mul x6, x4, x1                // x6 = i * columnas
    add x6, x6, w5, uxtw          // x6 = i * columnas + j
    lsl x6, x6, #2                // x6 *= 4 (convertir índice a bytes)
    ldr w7, [x2, x6]              // Cargar A[i][j] en w7

    // Calcular el índice de T[j][i] para la transposición
    mul x8, w5, w0                // x8 = j * filas (filas de T = columnas de A)
    add x8, x8, w4, uxtw          // x8 = j * filas + i
    lsl x8, x8, #2                // x8 *= 4 (convertir índice a bytes)
    str w7, [x3, x8]              // Guardar A[i][j] en T[j][i]

    add w5, w5, #1                // j++
    b columna_loop                // Repetir para la siguiente columna

siguiente_fila:
    add w4, w4, #1                // i++
    b fila_loop                   // Repetir para la siguiente fila

fin_transposicion:
    ret
