//Titulo: Convertir temperatura de Celsius a Fahrenheit
//Nombre: Leonel Martinez Huitron
//Matricula: 22210777
//Materia: Lenguaje de Interfaz
//Descripción: Programa en ensamblador ARM de 64 bits que convierte la temperatura de Celsius a Fahrenheit


//Solucion C#


//SOLUCION ARM64

.section .data
.section .text
.global _start

_start:
    // Cargar el valor de Celsius en x0
    MOV x0, #25               // Ejemplo: Temperatura en Celsius (25 grados)

    // Convertir Celsius a Fahrenheit: F = C * 9/5 + 32
    MOV x1, x0                // Copiar el valor de Celsius a x1 para multiplicación
    MOV x2, #9                // Factor de multiplicación 9
    MUL x1, x1, x2            // x1 = C * 9

    MOV x2, #5                // Divisor 5
    SDIV x1, x1, x2           // x1 = (C * 9) / 5

    ADD x1, x1, #32           // x1 = (C * 9 / 5) + 32

    // Terminar el programa
    MOV x8, #93               // Código de salida para el sistema en ARM
    SVC #0                    // Llamada al sistema para salir
