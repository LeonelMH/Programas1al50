// ==============================================================================
// Archivo     : Armstrong.s 
// Descripción : Verificar si un número es Armstrong en ARM64.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 10/11/2024
// ==============================================================================

//Equivalente en C#:

//using System;

//class Armstrong
//{
//    static void Main()
//    {
        // Número a verificar
//        int num = 153;  // Puedes cambiar el número aquí
//        int originalNum = num;
//        int sum = 0;

        // Calcular la cantidad de dígitos
//        int digits = num.ToString().Length;

        // Sumar los dígitos elevados a la potencia del número de dígitos
//        while (num > 0)
//        {
//            int digit = num % 10; // Obtener el último dígito
//            sum += (int)Math.Pow(digit, digits); // Elevar el dígito y sumar
//            num /= 10; // Eliminar el último dígito
//        }

        // Verificar si la suma es igual al número original
//        if (sum == originalNum)
//        {
//            Console.WriteLine("Es un número Armstrong");
//        }
//        else
//        {
//            Console.WriteLine("No es un número Armstrong");
//        }
//    }
//}


// -------------------------------
// Sección de código
// -------------------------------

.global _start
.section .data
number: .word 153          // Número a verificar si es Armstrong
.section .text
_start:
    // Cargar el número en el registro x0
    ldr x0, =number         // Cargar la dirección del número en x0
    ldr x0, [x0]            // Cargar el valor del número en x0 (x0 = 153)

    // Guardar el valor original de x0 para compararlo después
    mov x3, x0              // x3 = número original (153)

    // Contar el número de dígitos en el número (en x0)
    mov x1, #0              // Inicializar el contador de dígitos en 0
count_digits:
    udiv x2, x0, #10        // Dividir x0 entre 10, cociente en x2
    mul x2, x2, #10         // Multiplicar x2 por 10 para obtener el valor truncado
    sub x2, x0, x2          // Obtener el residuo (el último dígito de x0)
    add x1, x1, #1          // Incrementar el contador de dígitos
    udiv x0, x0, #10        // Reducir el número dividiéndolo entre 10
    cmp x0, #0              // Si x0 es 0, hemos contado todos los dígitos
    bne count_digits        // Si no, seguir contando

    // Almacenar la cantidad de dígitos en x1
    mov x0, x3              // Restaurar el número original en x0

    // Inicializar variables para el cálculo de la suma de los dígitos elevados a la potencia
    mov x2, #0              // x2 = 0 (acumulador de la suma)
    mov x3, x1              // x3 = número de dígitos
    mov x4, x0              // x4 = número original (153)

sum_digits:
    // Obtener el último dígito
    udiv x5, x4, #10        // x5 = cociente de la división entre 10
    mul x6, x5, #10         // x6 = x5 * 10
    sub x7, x4, x6          // x7 = x4 - x6 (último dígito)
    
    // Elevar el dígito a la potencia (x7 ^ x3)
    mov x8, #1              // Inicializamos x8 como 1 (base para la potencia)
    mov x9, x7              // x9 = dígito (el último dígito)

power_loop:
    mul x8, x8, x9          // x8 = x8 * x9 (potencia acumulada)
    sub x3, x3, #1          // Decrementar el exponente
    cmp x3, #0              // Si el exponente es 0, terminamos
    bne power_loop          // Si no, seguimos multiplicando

    // Sumar el resultado de la potencia al acumulador
    add x2, x2, x8          // x2 = x2 + potencia del dígito

    // Reducir x4 eliminando el último dígito
    mov x4, x5              // x4 = cociente de la división (sin el último dígito)
    cmp x4, #0              // Si x4 es 0, terminamos
    bne sum_digits          // Si no, seguimos con el siguiente dígito

    // Comprobar si la suma de las potencias es igual al número original
    cmp x2, x0              // Comparar la suma de las potencias (x2) con el número original (x0)
    beq is_armstrong        // Si son iguales, es un número Armstrong

    // Si no es Armstrong, salir
    mov x0, #0              // Código de salida 0 (no es Armstrong)
    mov x8, #93             // Número de syscall para exit
    svc #0                  // Llamada al sistema para terminar

is_armstrong:
    // Si es Armstrong, salir
    mov x0, #1              // Código de salida 1 (es Armstrong)
    mov x8, #93             // Número de syscall para exit
    svc #0                  // Llamada al sistema para terminar
