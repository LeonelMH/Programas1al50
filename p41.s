// ==============================================================================
// Archivo     : DecimalHexadecimal.s 
// Descripción : Conversión de decimal a hexadecimal en ARM64.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 10/11/2024
// ==============================================================================

//Equivalente en C#:

//using System;

//class Program
//{
//    static void Main()
//    {
//        int decimalNumber = 1234;  // Número decimal
//       string hexadecimal = DecimalToHex(decimalNumber);
//        Console.WriteLine(hexadecimal);  // Imprimir el número hexadecimal
//    }

    // Función para convertir decimal a hexadecimal
//    static string DecimalToHex(int decimalNumber)
//    {
//        string hexValue = "";
        
//        while (decimalNumber > 0)
//        {
//            int remainder = decimalNumber % 16;  // Obtenemos el residuo de la división entre 16
//            hexValue = GetHexChar(remainder) + hexValue;  // Convertimos el residuo a carácter hexadecimal y lo agregamos al resultado
//            decimalNumber /= 16;  // Dividimos el número entre 16
//        }

//        return hexValue;  // El número hexadecimal
//    }

    // Función para obtener el carácter hexadecimal correspondiente a un valor
//    static char GetHexChar(int value)
//    {
//        if (value < 10)
//            return (char)(value + '0');  // Para los valores 0-9
//        else
//            return (char)(value - 10 + 'A');  // Para los valores A-F
//    }
//}


// -------------------------------
// Sección de código
// -------------------------------

.global _start

.section .data
    buffer: .skip 16            // Reservar espacio para almacenar hasta 16 caracteres (suficiente para un número de 64 bits en hexadecimal)

.section .text
_start:
    // Número decimal que queremos convertir (ejemplo: 1234)
    mov w0, #1234            // Número decimal 1234
    
    // Llamar a la función de conversión a hexadecimal
    bl decimal_a_hexadecimal

    // Terminar el programa
    mov w0, #0               // Código de salida 0
    mov x8, #93              // Número de syscall para exit en Linux ARM64
    svc #0

// Función para convertir decimal a hexadecimal
decimal_a_hexadecimal:
    mov w1, #0               // Inicializamos el índice (usado para almacenamiento de los restos)
    mov w2, #16              // Divisor (base hexadecimal)
    ldr x3, =buffer          // Cargar la dirección de buffer en x3

convertir_loop:
    cmp w0, #0               // Comprobamos si el número decimal es 0
    beq fin_conversion       // Si es 0, terminamos el bucle

    udiv w4, w0, w2          // Realizamos la división entre el número decimal (w0) y 16 (w2)
    mul w5, w4, w2           // Multiplicamos el cociente por 16
    sub w6, w0, w5           // Restamos el cociente multiplicado por 16 para obtener el residuo
    add w6, w6, #48          // Convertimos el residuo a su carácter ASCII ('0' = 48 en ASCII)
    cmp w6, #57              // Comprobamos si el residuo es menor o igual a '9' (57)
    ble almacenar            // Si es menor o igual, almacenamos el dígito como un número
    add w6, w6, #7           // Si el residuo es mayor que 9, lo convertimos a 'A' - 'F' (añadimos 7)
    
almacenar:
    // Usamos x1 (registro de 64 bits) para el índice de almacenamiento
    strb w6, [x3, x1]        // Almacenamos el dígito hexadecimal en la memoria reservada (buffer)
    add x1, x1, #1           // Incrementamos el índice de almacenamiento (x1)

    mov w0, w4               // Colocamos el cociente como nuevo número a procesar
    b convertir_loop          // Continuamos con la siguiente iteración

fin_conversion:
    // El número hexadecimal se encuentra ahora en el buffer, pero está en orden inverso.
    ret
