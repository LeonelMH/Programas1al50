// ==============================================================================
// Archivo     : Calculadora.s 
// Descripción : Calculadora simple (Suma, Resta, Multiplicación, División) en ARM64.
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
        // Definir los dos números y la operación
//        int num1 = 10;
//        int num2 = 5;
//        char operation = '+'; // La operación puede ser '+', '-', '*' o '/'

//        int result = 0; // Variable para almacenar el resultado

        // Realizar la operación según el operador
//        switch (operation)
//        {
//            case '+':
//                result = num1 + num2; // Suma
//                break;
//            case '-':
//                result = num1 - num2; // Resta
//                break;
//            case '*':
//                result = num1 * num2; // Multiplicación
//                break;
//            case '/':
//                if (num2 != 0)
//                {
//                    result = num1 / num2; // División
//                }
//                else
//                {
//                    Console.WriteLine("Error: División por cero.");
//                    return;
//                }
//                break;
//            default:
//                Console.WriteLine("Operación no válida.");
//                return;
//        }

        // Mostrar el resultado
//        Console.WriteLine($"El resultado de {num1} {operation} {num2} es: {result}");
//    }
//}


// -------------------------------
// Sección de código
// -------------------------------

.global _start

.section .data
    num1: .word 10             // Primer número
    num2: .word 5              // Segundo número
    operation: .byte '+'       // Operación a realizar: '+' para suma, '-' para resta, '*' para multiplicación, '/' para división

.section .text
_start:
    ldr x0, =num1              // Cargar dirección de num1 en x0
    ldr x1, =num2              // Cargar dirección de num2 en x1
    ldr w0, [x0]               // Cargar el valor de num1 en w0
    ldr w1, [x1]               // Cargar el valor de num2 en w1

    ldr x2, =operation         // Cargar la dirección de la variable 'operation' en x2
    ldrb w2, [x2]              // Cargar el valor de la operación (carácter) en w2

    cmp w2, #'+'               // Comparar si la operación es suma
    beq suma                   // Si es suma, saltar a la etiqueta suma

    cmp w2, #'-'               // Comparar si la operación es resta
    beq resta                  // Si es resta, saltar a la etiqueta resta

    cmp w2, #'*'               // Comparar si la operación es multiplicación
    beq multiplicacion         // Si es multiplicación, saltar a la etiqueta multiplicacion

    cmp w2, #'/'               // Comparar si la operación es división
    beq division               // Si es división, saltar a la etiqueta division

    b end_program              // Si no es ninguna de las anteriores, terminar el programa

suma:
    add w0, w0, w1             // Realizar la suma (w0 = w0 + w1)
    b end_program              // Saltar al final del programa

resta:
    sub w0, w0, w1             // Realizar la resta (w0 = w0 - w1)
    b end_program              // Saltar al final del programa

multiplicacion:
    mul w0, w0, w1             // Realizar la multiplicación (w0 = w0 * w1)
    b end_program              // Saltar al final del programa

division:
    sdiv w0, w0, w1            // Realizar la división (w0 = w0 / w1)
    b end_program              // Saltar al final del programa

end_program:
    // Aquí puedes realizar alguna salida o hacer lo que necesites con el resultado en w0
    mov x8, #93                // Número de syscall para exit en Linux ARM64
    svc #0                      // Llamada al sistema para terminar
