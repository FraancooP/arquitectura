module SumadorRestador #(parameter width = 8)(//width asigna el ancho a 8 bits.
       input logic [width-1:0] a,
       input logic [width-1:0] b,
       input logic subtract,//Decide si se realizara una suma o una Resta.
       output logic [width-1:0] y,//Resultado de la operacion
       output logic cout);//Señal de acarreo 
logic [width:0] temp_result;//Esta variable temporal almacena temporalmente el resultado
always_comb begin
	if(subtract)
	temp_result = a-b;//Si subtract = 1
	else
	temp_result = a+b;//Si subtract = 0
end
assign y = temp_result[width-1:0];//A y le asignamos el resultado temporal
assign cout = temp_result[width-1:0];//Se asigna el bit mas significativo de temp
endmodule
