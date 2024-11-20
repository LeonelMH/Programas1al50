// ==============================================================================
// Archivo     : suma_matrices.s
// Descripción : Suma dos matrices de tamaño 3x3 y almacena el resultado en una tercera matriz.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 09/11/2024
// ==============================================================================

// Equivalente en C# para referencia:
// using System;
// class Program {
//     static void Main() {
//         int[,] A = { {1, 2, 3}, {4, 5, 6}, {7, 8, 9} };
//         int[,] B = { {9, 8, 7}, {6, 5, 4}, {3, 2, 1} };
//         int[,] C = new int[3, 3];
//         
//         for (int i = 0; i < 3; i++) {
//             for (int j = 0; j < 3; j++) {
//                 C[i, j] = A[i, j] + B[i, j];
//             }
//         }
//     }
// }

// -------------------------------
// Sección de datos
// -------------------------------
.section .data
matrixA: .word 1, 2, 3, 4, 5, 6, 7, 8, 9        // Matriz A de 3x3
matrixB: .word 9, 8, 7, 6, 5, 4, 3, 2, 1        // Matriz B de 3x3
matrixC: .space 36                              // Matriz C (resultado), reservamos espacio para 9 enteros

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
    ldr x3, =matrixB              // Dirección base de matrixB
    ldr x4, =matrixC              // Dirección base de matrixC (resultado)

    // Llamar a la función de suma de matrices
    bl SumaMatrices

    // Salir del programa
    mov w0, #0                    // Estado de salida 0 (éxito)
    mov x8, #93                   // Código de sistema para salir en Linux
    svc 0                         // Interrupción para invocar la salida del sistema

// -------------------------------
// Función: SumaMatrices
// Descripción: Suma las matrices A y B y almacena el resultado en la matriz C.
// Argumentos: w0 = filas, w1 = columnas, x2 = matriz A, x3 = matriz B, x4 = matriz C
// -------------------------------
SumaMatrices:
    mov w5, #0                    // Índice i (filas)
fila_loop:
    cmp w5, w0                    // Comparar i con el número de filas
    bge fin_suma                  // Si i >= filas, terminar

    mov w6, #0                    // Índice j (columnas)
columna_loop:
    cmp w6, w1                    // Comparar j con el número de columnas
    bge siguiente_fila            // Si j >= columnas, ir a la siguiente fila

    // Calcular el índice lineal: índice = (i * columnas + j) * 4 (tamaño de palabra en bytes)
    mul x7, x5, x1                // x7 = i * columnas
    add x7, x7, w6, uxtw          // x7 = i * columnas + j
    lsl x7, x7, #2                // x7 *= 4 (multiplicar por 4 para calcular el desplazamiento en bytes)

    // Cargar valores de A[i][j] y B[i][j]
    ldr x8, [x2, x7]              // Cargar A[i][j] en x8
    ldr x9, [x3, x7]              // Cargar B[i][j] en x9

    // Sumar A[i][j] + B[i][j] y almacenar en C[i][j]
    add x10, x8, x9               // x10 = A[i][j] + B[i][j]
    str x10, [x4, x7]             // Guardar el resultado en C[i][j]

    add w6, w6, #1                // j++
    b columna_loop                // Repetir para la siguiente columna

siguiente_fila:
    add w5, w5, #1                // i++
    b fila_loop                   // Repetir para la siguiente fila

fin_suma:
    ret
