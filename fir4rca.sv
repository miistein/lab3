// ECE260A Lab 3
// keep the same input and output and the same input and output registers
// change the combinational addition part to something more optimal
// refer to Fig. 11.42(a) in W&H 
module fir4rca #(parameter w=16)(
  input                      clk, 
                             reset,
  input        signed [w-1:0] a,
  output logic signed [w+1:0] s);
// delay pipeline for input a
  logic        signed [w-1:0] ar, br, cr, dr;

// REFERENCE RIPPLE CARRY ADDER STARTS HERE LOGIC. YOUR PROPOSED LOGIC SHOULD
// REPLACE THE CONTENT IN THIS SECTION
  logic        signed [w+1:0] rca1_s, rca1_co, rca2_s, rca2_co;
  logic        signed [w+1:0] sum;

  always_comb begin
    rca1_co[0] = 0;
    rca2_co[0] = 0;
    for(int i=0; i<w; i++)
      {rca1_co[i+1],rca1_s[i]} = ar[i]+br[i]+rca1_co[i];

    for(int i=0; i<w; i++)
      {rca2_co[i+1],rca2_s[i]} = cr[i]+dr[i]+rca2_co[i];

    sum = rca1_s + rca2_s;    
  end
 
// END OF RIPPLE CARRY ADDER LOGIC, YOUR PROPOSED LOGIC SHOULD END HERE

// sequential logic -- standardized for everyone
  always_ff @(posedge clk)			// or just always -- always_ff tells tools you intend D flip flops
    if(reset) begin					// reset forces all registers to 0 for clean start of test
	  ar <= 'b0;
	  br <= 'b0;
	  cr <= 'b0;
	  dr <= 'b0;
	  s  <= 'b0;
    end
    else begin					    // normal operation -- Dffs update on posedge clk
	  ar <= a;			        // the chain will always hold the four most recent incoming data samples
	  br <= ar;
	  cr <= br;
	  dr <= cr;
	  s  <= sum; 
	end

endmodule
