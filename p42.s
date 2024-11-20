// ==============================================================================
// Archivo     : HexadecimalDecimal.s 
// Descripción : 	Conversión de hexadecimal a decimal en ARM64.
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
//        string hexString = "7F"; // Cadena hexadecimal a convertir (Ejemplo: "7F")
//        int decimalValue = ConvertHexToDecimal(hexString); // Convertir hexadecimal a decimal
//        Console.WriteLine(decimalValue); // Imprimir el resultado decimal
//    }

//    static int ConvertHexToDecimal(string hex)
//    {
//        int decimalValue = 0; // Inicializamos el valor decimal
//        foreach (char c in hex)
//        {
//            decimalValue *= 16; // Multiplicamos el valor actual por 16
//            if (c >= '0' && c <= '9')
//                decimalValue += c - '0'; // Si el carácter es entre '0' y '9'
//            else if (c >= 'A' && c <= 'F')
//                decimalValue += c - 'A' + 10; // Si el carácter es entre 'A' y 'F'
//        }
//        return decimalValue; // Devolvemos el resultado decimal
//    }
//}


// -------------------------------
// Sección de código
// -------------------------------

.global _start

.section .data
    hex_string: .asciz "7F"      // Cadena hexadecimal a convertir (Ejemplo: "7F")
    buffer: .skip 8              // Espacio para el número decimal resultante (en formato ASCII)

.section .text
_start:
    ldr x0, =hex_string          // Cargar la dirección de la cadena hexadecimal en x0
    mov x1, #0                   // Inicializar el resultado (decimal) en x1
    mov x2, #0                   // Inicializar el índice (para recorrer la cadena) en x2
    mov x3, #16                  // Base (16 para hexadecimal)
    
convertir_loop:
    ldrb w4, [x0, x2]            // Cargar el siguiente carácter de la cadena hexadecimal en w4
    cmp w4, #0                   // Si llegamos al final de la cadena, terminamos
    beq fin_conversion

    // Convertir carácter ASCII a su valor numérico
    cmp w4, #'0'                 // Si el carácter es '0'-'9'
    blt no_convertir             // Si es menor que '0', es un carácter inválido
    cmp w4, #'9'
    ble convertir_digito         // Si está entre '0' y '9'
    
    cmp w4, #'A'                 // Si el carácter es 'A'-'F'
    blt no_convertir
    cmp w4, #'F'
    ble convertir_digito         // Si está entre 'A' y 'F'

no_convertir:
    b convertir_loop

convertir_digito:
    sub w4, w4, #48              // Convertir '0'-'9' a 0-9 (ASCII a valor numérico)
    cmp w4, #9
    ble es_digito                // Si es '0'-'9', está bien

    sub w4, w4, #7               // Convertir 'A'-'F' a 10-15 (ASCII a valor numérico)
    
es_digito:
    // Extender w4 (32-bit) a x4 (64-bit) antes de la multiplicación
    sxtw x4, w4                  // Sign-extend w4 a 64-bit x4

    mul x1, x1, x3               // Multiplicar el resultado actual por 16 (base hexadecimal)
    add x1, x1, x4               // Sumar el valor del dígito al resultado decimal
    
    add x2, x2, #1               // Incrementar el índice de la cadena
    b convertir_loop              // Repetir el proceso

fin_conversion:
    // Ahora el resultado decimal está en x1
    mov w0, w1                   // Guardamos el resultado decimal en w0 (32-bit)
    mov x8, #93                  // Número de syscall para exit en Linux ARM64
    svc #0
