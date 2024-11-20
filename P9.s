//Titulo: Verificar si un número es primo	
//Nombre: Leonel Martinez Huitron
//Matricula: 22210777
//Materia: Lenguaje de Interfaz
//Descripción: Programa en ensamblador ARM de 64 bits que verifica si un número es primo.

.section .data
    n: .quad 29                     // Número a verificar
    result_prime: .asciz "El número es primo.\n"
    result_not_prime: .asciz "El número no es primo.\n"

.section .text
.global _start

_start:
    // Inicialización
    ldr x0, =n                     // Cargar la dirección de n
    ldr x1, [x0]                   // Cargar el valor de n en x1
    cmp x1, 2                      // Comparar n con 2
    blt .not_prime_case            // Si n < 2, no es primo
    beq .prime_case                // Si n == 2, es primo

    mov x2, 2                      // Iniciar divisor en 2
    lsr x3, x1, 1                  // x3 = n / 2 (máximo divisor posible)
    
.check_loop:
    cmp x2, x3                     // Comparar divisor con n/2
    bgt .prime_case                // Si divisor > n/2, es primo

    // Verificar si n es divisible por divisor
    mov x4, x1                     // Guardar n en x4
    sdiv x5, x4, x2                // x5 = n / divisor
    mul x6, x5, x2                 // x6 = x5 * divisor
    cmp x6, x4                     // Comparar resultado con n
    beq .not_prime_case            // Si son iguales, no es primo

    add x2, x2, 1                  // Incrementar divisor
    b .check_loop                  // Repetir el bucle

.prime_case:
    // Imprimir que el número es primo
    ldr x0, =result_prime          // Cargar dirección del mensaje primo
    bl print_string                // Llamar a la función para imprimir
    b .exit                        // Salir

.not_prime_case:
    // Imprimir que el número no es primo
    ldr x0, =result_not_prime      // Cargar dirección del mensaje no primo
    bl print_string                // Llamar a la función para imprimir

.exit:
    // Salir del programa
    mov x8, 93                     // syscall: exit
    mov x0, 0                      // status: 0
    svc 0

// Función para imprimir cadenas
print_string:
    mov x1, x0                     // Puntero a la cadena
    mov x2, 25                     // Longitud máxima de la cadena (ajusta si es necesario)
    mov x0, 1                      // fd: stdout
    mov x8, 64                     // syscall: write
    svc 0
    ret
