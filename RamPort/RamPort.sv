//MODULO DE PUERTO DE MEMORIA RAM(Random acces memory)!!!!
//Este modulo describe 3 puertos de escritura y 2 puertos de lectura.
module RamPort #(parameter N = 2, M = 4)//N Y M Definen tamaño y profundidad de memoria ram
(
	input logic clk,//Clock
	input logic we3,//Define si tenemos que escribir en la memoria ram
	input logic [N-1:0] a1, a2, a3 ,//Entradas que representan las direcciones de lectura/escritura
	output logic [M-1:0] d1, d2 ,//Representan los datos leidos en la memoria RAM
	input logic [M-1:0] d3//Entrada q Representa el dato que se va a escribir en la memoria RAM
);
logic [M-1:0] mem[2**N-1:0];//Declaramos la memoira RAM como un arreglo llamado mem(2**N = 2^n)
always @(posedge clk)//Se ejecutará cada vez que ocurra un flanco de una subida
	if(we3) mem[a3] <= d3;//Si we3 == 1, esta activada, se escribe el valor de d3 en la ubicacion de memoria de a3
		assign d1 = mem[a1];
		assign d2 = mem[a2];//asignan los valores almacenados en las ubicaciones de memoria a1 y a2 a las salidas d1 y d2
endmodule
//En resumen, para testear esto, tenemos que asignarle valores clk, we3,a1,a2,a3 y d3 y ver como
//Se comportan las salidas d1 y d2.
//En el simulador, se elijen valores a a1 a2 y a3, donde a1 y a2, si ponemos que es 00 y 01,
//a3 debe ser uno de esos 2 valores, ya que en d3, usara la direccion que tiene a3 para copiar
//el valor ingresado en d3 y mandarlo a la direccion que tiene a3, por ejemplo si a3 tiene 00
//el valor de d3 aparece en la direccion que apunta a1, esta direccion es d1, y si a3 tiene
//01, el valor que tiene d3 aparecera en la direccion que tiene a2, osea d2.