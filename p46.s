// ==============================================================================
// Archivo     : Prefijo.s 
// Descripción : 	Encontrar prefijo común más largo en cadenas en ARM64.
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
//        string string1 = "prefix123";
//        string string2 = "prefix456";
//        string string3 = "prefix789";
        
//        string result = LongestCommonPrefix(string1, string2, string3);
//        Console.WriteLine("Longest common prefix: " + result);
//    }

//    static string LongestCommonPrefix(string str1, string str2, string str3)
//    {
//        int minLength = Math.Min(str1.Length, Math.Min(str2.Length, str3.Length));
//        int i = 0;

//        while (i < minLength && str1[i] == str2[i] && str2[i] == str3[i])
//        {
//            i++;
//        }

//        return str1.Substring(0, i); // Retorna el prefijo común más largo
//    }
//}


// -------------------------------
// Sección de código
// -------------------------------

.global _start

.section .data
string1: .asciz "prefix123"
string2: .asciz "prefix456"
string3: .asciz "prefix789"
maxLength: .word 100      // Tamaño máximo para el prefijo común

.section .text
_start:
    // Cargar las direcciones de las cadenas en los registros
    ldr x0, =string1
    ldr x1, =string2
    ldr x2, =string3

    // Llamar a la función para encontrar el prefijo común más largo
    bl find_longest_common_prefix

    // Terminar el programa (exit)
    mov x8, #93         // Código para la syscall exit
    mov x0, #0          // Código de salida (0 es normal)
    svc #0              // Llamada al sistema para terminar

find_longest_common_prefix:
    // Inicializar el índice del prefijo y las direcciones de las cadenas
    mov x3, #0          // x3 será el índice para el prefijo
    mov x4, #0          // Inicializar la longitud del prefijo común en 0

find_characters:
    ldrb w5, [x0, x3]  // Cargar el carácter de la cadena 1 en w5
    ldrb w6, [x1, x3]  // Cargar el carácter de la cadena 2 en w6
    ldrb w7, [x2, x3]  // Cargar el carácter de la cadena 3 en w7

    cmp w5, w6         // Comparar los caracteres de las dos primeras cadenas
    bne done            // Si no son iguales, terminar

    cmp w6, w7         // Comparar con la tercera cadena
    bne done            // Si no son iguales, terminar

    // Si son iguales, continuar comparando el siguiente carácter
    add x3, x3, #1      // Incrementar el índice
    cmp x3, #100        // Verificar que no hayamos excedido el tamaño máximo
    bge done            // Si hemos alcanzado el tamaño máximo, terminar
    b find_characters   // Volver a comparar los siguientes caracteres

done:
    // Aquí x3 contiene la longitud del prefijo común más largo
    mov x0, x3          // Guardar el tamaño del prefijo en x0 (como resultado)
    ret
