//Titulo: Invertir una cadena
//Nombre: Leonel Martinez Huitron
//Matricula: 22210777
//Materia: Lenguaje de Interfaz
//Descripción: Programa en ensamblador ARM de 64 bits que invierte una cadena.

.section .data
    input_string: .asciz "Hola, mundo!"  // Cadena de entrada
    output_string: .space 14               // Espacio para la cadena invertida (ajusta el tamaño si es necesario)
    length: .quad 13                      // Longitud de la cadena (ajusta según la cadena de entrada)

.section .text
.global _start

_start:
    // Inicializar punteros
    adr x0, input_string                 // Cargar la dirección de la cadena de entrada
    adr x1, output_string                // Cargar la dirección de la cadena de salida
    ldr x2, =length                      // Cargar la dirección de la longitud
    ldr x3, [x2]                         // Cargar la longitud de la cadena en x3

    sub x3, x3, 1                        // x3 = longitud - 1 (índice del último carácter)

    // Invertir la cadena
invert_loop:
    cmp x3, -1                           // Comparar índice con -1
    blt end_inversion                    // Si x3 < 0, terminar
    ldrb w4, [x0, x3]                   // Cargar el carácter de entrada en w4
    strb w4, [x1]                       // Almacenar el carácter en la cadena de salida
    add x1, x1, 1                        // Mover el puntero de salida a la derecha
    sub x3, x3, 1                        // Decrementar el índice
    b invert_loop                        // Repetir el bucle

end_inversion:
    // Añadir el terminador nulo a la cadena invertida
    mov w0, 0                            // Establecer el terminador nulo
    strb w0, [x1]                       // Almacenar el terminador nulo en la cadena invertida

    // Imprimir la cadena invertida
    adr x0, output_string                // Cargar dirección de la cadena invertida
    mov x2, 14                           // Longitud de la cadena (ajusta según la cadena de entrada)
    mov x1, x0                           // Puntero a la cadena
    mov x0, 1                            // fd: stdout
    mov x8, 64                           // syscall: write
    svc 0                                 // Llamar a la syscall

    // Salir del programa
    mov x8, 93                           // syscall: exit
    mov x0, 0                            // status: 0
    svc 0
