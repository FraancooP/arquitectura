module UnidadProcesadora #(parameter N = 4) 
                (input logic clk, 
                 input logic [15:0] ctrl_word,
                 input logic [N-1:0] DATA_in,
                 output logic [3:0] stateBits,
                 output logic [N-1:0] DATA_out);
					  
	Alu #(N) alu_instancia(
		.a(busA),
		.b(busB),
		.ALUControl(ctrl_word[6:3]),
		.Result(ALU_out),
		.ALUFlags(flags)
	);
	
	Shifter #(N) shifter_instancia(
		.F(busA),
		.H(ctrl_word[2:0]),
		.S(DATA_out)
	);
	
	RamPort #(N, 4) ram_instancia(
		.clk(clk),
		.we3(ctrl_word[7]),
		.a1(ctrl_word[15:12]),
		.a2(ctrl_word[11:8]),
		.a3(ctrl_word[6:3]),
		.d1(busA),
		.d2(busB),
		.d3(DATA_out),
	);
endmodule
//Ram3port--------------------------------------------------------------------------------
module RamPort #(parameter N = 2, M = 4)
(
	input logic clk,
	input logic we3,
	input logic [N-1:0] a1, a2, a3 ,
	output logic [M-1:0] d1, d2 ,
	input logic [M-1:0] d3
);
logic [M-1:0] mem[2**N-1:0];
always @(posedge clk)
	if(we3) mem[a3] <= d3;
		assign d1 = mem[a1];
		assign d2 = mem[a2];
endmodule
//-----------------------------------------------------------------------------------------
//Shifter----------------------------------------------------------------------------------
module Shifter #(parameter N = 4)
                 (input logic [N-1:0] F,
                  input logic [2:0] H,
                  output logic [N-1:0] S);
  always_comb
    case (H)
      3'b000: S = F;
      3'b001: S = F << 1;
      3'b010: S = F >> 1;
      3'b011: S = { N {1'b0} };
		3'b100: S = F;
		3'b101: S = {F[N-2:0], F[N-1]};
		3'b110: S = {F[N-N],F[N-1:1]};
		3'b111: S = F;
    endcase
endmodule 
//-----------------------------------------------------------------------------------------
//Alu--------------------------------------------------------------------------------------
module Alu #(parameter N = 4)
          (input logic [N-1:0] a, b,
           input logic [3:0] ALUControl,
           output logic [N-1:0] Result,
           output logic [3:0] ALUFlags);

  logic neg, zero, acarreo, overflow;
  logic [N-1:0] y, sum;
  logic cin, cout;
// ________________________________________________
//|_selección_|_  entrada _|_   F = A + y + cin   _|
//|_ S1  S0  _|_    y     _|_   cin=0     cin=1   _|
//|   0   0   | solo ceros |    F=A       F=A+1    |
//|   0   1   |     B      |    F=A+B     F=A+B+1  |
//|   1   0   |    /B      |    F=A+/B    F=A+/B+1 |
//|_  1   1  _|_solo unos _|_   F=A-1     F=A     _|  
 
  assign cin = ALUControl[0]; 
  assign y = ALUControl[2] ? (ALUControl[1] ? {N {1'b1}}
                                            : ~b )
                           : (ALUControl[1] ? b 
                                            : {N {1'b0}} );
  assign {cout,sum} = a + y + cin;
  
  always_comb
    casez (ALUControl[3:1])
      3'b0??: Result = sum;
      3'b100: Result = a & b;
      3'b101: Result = a | b;
      3'b110: Result = a ^ b;
      3'b111: Result = ~a;
    endcase

  assign neg = Result[N-1];
  assign zero = (Result == {N {1'b0}});
  assign acarreo = (ALUControl[3] == 1'b0) & cout;
  assign overflow = (ALUControl[3] == 1'b0) &
                    (~a[N-1] & ~y[N-1] & sum[N-1] +
                      a[N-1] &  y[N-1] & ~sum[N-1]);
  assign ALUFlags = {overflow, neg, zero, acarreo };
endmodule
//-----------------------------------------------------------------------------------------












