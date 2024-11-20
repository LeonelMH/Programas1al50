// ==============================================================================
// Archivo     : Escribir.s 
// Descripción : Escribir en un archivo en ARM64.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 10/11/2024
// ==============================================================================

//Equivalente en C#:
//using System;
//using System.IO;

//class Program
//{
//    static void Main()
//    {
//        string filePath = "output.txt";  // Ruta del archivo
//        string message = "Hello, this is a test!\n";  // Mensaje a escribir

        // Escribir en el archivo
//        File.WriteAllText(filePath, message);

        // Mostrar en la consola que el archivo ha sido escrito
//        Console.WriteLine("Mensaje escrito en el archivo: " + filePath);
//    }
//}


// -------------------------------
// Sección de código
// -------------------------------

.global _start

.section .data
filename: .asciz "output.txt"  // Nombre del archivo
message:  .asciz "Hello, this is a test!\n"  // Mensaje a escribir en el archivo

.section .text
_start:
    // Abrir el archivo "output.txt" en modo de escritura
    mov x0, #0            // O_RDONLY = 0 (modo lectura)
    adr x1, filename      // Dirección del nombre del archivo
    mov x2, #0x241        // O_WRONLY | O_CREAT | O_TRUNC (escribir, crear, truncar)
    mov x8, #56           // syscall number para open
    svc #0                // Llamada al sistema
    mov x3, x0            // Guardar el descriptor del archivo en x3

    // Escribir el mensaje en el archivo
    adr x1, message       // Dirección del mensaje
    mov x2, #25           // Longitud del mensaje (25 caracteres)
    mov x8, #64           // syscall number para write
    svc #0                // Llamada al sistema

    // Cerrar el archivo
    mov x8, #57           // syscall number para close
    mov x0, x3            // Pasar el descriptor de archivo a x0
    svc #0                // Llamada al sistema

    // Terminar el programa
    mov x8, #93           // Número de syscall para exit
    mov x0, #0            // Código de salida 0
    svc #0                // Llamada al sistema
