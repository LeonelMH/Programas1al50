//Titulo: División de dos números
//Nombre: Leonel Martinez Huitron
//Matricula: 22210777
//Materia: Lenguaje de Interfaz
//Descripción: Programa en ensamblador ARM de 64 bits que divide dos números.

//SOLUCION C#
//static void Main()
//    {
        // Solicita el primer número
//        Console.Write("Ingresa el primer número: ");
//        double numero1 = Convert.ToDouble(Console.ReadLine());

        // Solicita el segundo número
//       Console.Write("Ingresa el segundo número: ");
//        double numero2 = Convert.ToDouble(Console.ReadLine());

        // Verifica si el divisor es cero
//       if (numero2 != 0)
//     {
            // Realiza la división
//          double resultado = numero1 / numero2;

            // Muestra el resultado
//         Console.WriteLine("El resultado de la división es: " + resultado);
//     }
//     else
//     {
//         Console.WriteLine("Error: No se puede dividir entre cero.");
//     }


//SOLUCION ARM64

.section .data
    num1: .word 42      // Dividendo
    num2: .word 6       // Divisor
    result: .word 0     // Espacio para almacenar el cociente
    remainder: .word 0   // Espacio para almacenar el residuo

.section .text
    .global _start

_start:
    // Cargar los números en registros
    ldr x0, =num1         // Cargar la dirección de num1 en x0
    ldr w1, [x0]          // Cargar el valor de num1 en w1 (dividendo)
    ldr x0, =num2         // Cargar la dirección de num2 en x0
    ldr w2, [x0]          // Cargar el valor de num2 en w2 (divisor)

    // Dividir los números
    sdiv w3, w1, w2       // w3 = w1 / w2 (cociente)
    udiv w4, w1, w2       // w4 = w1 % w2 (residuo)

    // Almacenar el resultado
    ldr x0, =result       // Cargar la dirección de result en x0
    str w3, [x0]          // Almacenar el cociente en result
    ldr x0, =remainder    // Cargar la dirección de remainder en x0
    str w4, [x0]          // Almacenar el residuo en remainder

    // Salir del programa
    mov x8, 93            // syscall número para exit en ARM
    mov x0, 0             // Código de salida
    svc 0                 // Llamar al sistema

