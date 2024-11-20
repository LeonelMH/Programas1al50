// ==============================================================================
// Archivo     : multiplicacion_matrices.s
// Descripción : Multiplicación de dos matrices de tamaño 3x3 y almacenamiento en una tercera matriz.
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
//        int[,] B = { {9, 8, 7}, {6, 5, 4}, {3, 2, 1} };
//        int[,] C = new int[3, 3];
//        
//        for (int i = 0; i < 3; i++) {
//            for (int j = 0; j < 3; j++) {
//                C[i, j] = 0;
//                for (int k = 0; k < 3; k++) {
//                    C[i, j] += A[i, k] * B[k, j];
//                }
//            }
//       }
        
        // Imprimir la matriz resultante
//        for (int i = 0; i < 3; i++) {
//            for (int j = 0; j < 3; j++) {
//                Console.Write(C[i, j] + " ");
//            }
//            Console.WriteLine();
//        }
//    }
//}

// ARM64
.section .data
matrixA: .word 1, 2, 3, 4, 5, 6, 7, 8, 9        // Matriz A de 3x3
matrixB: .word 9, 8, 7, 6, 5, 4, 3, 2, 1        // Matriz B de 3x3
matrixC: .space 36                              // Matriz C (resultado), espacio para 9 enteros

.section .text
.global _start

// -------------------------------
// Función principal
// -------------------------------
_start:
    mov w0, #3                    // Número de filas de A
    mov w1, #3                    // Número de columnas de B (y filas de B)
    mov w2, #3                    // Número de columnas de B

    // Cargar direcciones base de las matrices
    ldr x3, =matrixA              // Dirección base de matrixA
    ldr x4, =matrixB              // Dirección base de matrixB
    ldr x5, =matrixC              // Dirección base de matrixC (resultado)

    // Llamar a la función de multiplicación de matrices
    bl MultiplicarMatrices

    // Salir del programa
    mov w0, #0                    // Estado de salida 0 (éxito)
    mov x8, #93                   // Código de sistema para salir en Linux
    svc 0                         // Interrupción para invocar la salida del sistema

// -------------------------------
// Función: MultiplicarMatrices
// Descripción: Multiplica matrices A y B y almacena el resultado en la matriz C.
// Argumentos: w0 = filas A, w1 = columnas B, w2 = columnas A, x3 = matriz A, x4 = matriz B, x5 = matriz C
// -------------------------------
MultiplicarMatrices:
    mov w6, #0                    // Índice i (filas de A)
fila_loop:
    cmp w6, w0                    // Comparar i con el número de filas
    bge fin_multiplicacion        // Si i >= filas de A, terminar

    mov w7, #0                    // Índice j (columnas de B)
columna_loop:
    cmp w7, w1                    // Comparar j con el número de columnas
    bge siguiente_fila            // Si j >= columnas de B, ir a la siguiente fila

    mov x9, #0                    // Inicializar C[i][j] a 0
    mov w8, #0                    // Índice k (para recorrer columnas de A y filas de B)
    
producto_interno:
    cmp w8, w2                    // Comparar k con el número de columnas de A
    bge almacenar_resultado       // Si k >= columnas de A, ir a almacenar el resultado

    // Calcular el índice de A[i][k]
    mul x10, x6, x2               // x10 = i * columnas de A (convertir i a 64 bits para mul)
    add x10, x10, w8, uxtw        // x10 = i * columnas de A + k (extendiendo w8 a 64 bits)
    lsl x10, x10, #2              // x10 *= 4 (convertir índice a bytes)
    ldr x11, [x3, x10]            // Cargar A[i][k] en x11

    // Calcular el índice de B[k][j]
    mul x12, x8, x1               // x12 = k * columnas de B
    add x12, x12, w7, uxtw        // x12 = k * columnas de B + j (extendiendo w7 a 64 bits)
    lsl x12, x12, #2              // x12 *= 4 (convertir índice a bytes)
    ldr x13, [x4, x12]            // Cargar B[k][j] en x13

    // Multiplicar y sumar al producto interno
    mul x14, x11, x13             // x14 = A[i][k] * B[k][j]
    add x9, x9, x14               // Acumular en x9 el producto interno

    add w8, w8, #1                // k++
    b producto_interno            // Repetir para la siguiente posición de k

almacenar_resultado:
    // Guardar el resultado en C[i][j]
    mul x10, x6, x1               // x10 = i * columnas de B
    add x10, x10, w7, uxtw        // x10 = i * columnas de B + j (extendiendo w7 a 64 bits)
    lsl x10, x10, #2              // x10 *= 4 (convertir índice a bytes)
    str x9, [x5, x10]             // Guardar el producto interno en C[i][j]

    add w7, w7, #1                // j++
    b columna_loop                // Repetir para la siguiente columna

siguiente_fila:
    add w6, w6, #1                // i++
    b fila_loop                   // Repetir para la siguiente fila

fin_multiplicacion:
    ret
