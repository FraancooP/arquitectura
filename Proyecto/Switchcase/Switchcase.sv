module Switchcase;
	reg[2:0] opcion;//Definimos un registro de 3 bits.
	wire a, b, c, d;
	always @(*) begin
		a = 0;
		b = 0;
		c = 0;
		d = 0;
		case(opcion)
			3'b000: a = 1;
			3'b001: b = 1;
			3'b010: c = 1;
			3'b011: d = 1;
			default: a = 0;
		endcase
	end
endmodule
