// ECE260A Lab 3
// keep the same input and output and the same input and output registers
// change the combinational addition part to something more optimal
// refer to Fig. 11.42(a) in W&H 
module fir4rca #(parameter w=16)(
  input                       clk, 
                              reset,
  input        [w-1:0] a, 		// unsigned input
  output logic [w+1:0] s);		// sum of 4 most recent values of a

  logic        signed [w-1:0] ar, br, cr, dr;
  
  logic        signed [w-1:0] temp1;   
  logic        signed [w-1  :0] temp2;
  logic        signed [w-1  :0] temp3;
  logic        signed [w :0] cla_c;
  logic        signed [w :0] cla_c2;
  logic        signed [w+1:0] sum1;	  
  logic        signed [w-1  :0] P1;
  logic        signed [w-1  :0] G1;  
  always_comb begin
	 temp1 = ar;
	 temp2 = br;
	 
    // also try adding this logic to sequential
    cla_c[0] = 1'b0;
	 
    for(int i=0; i<w; i++) begin
        G1[i] = temp1[i] & temp2[i];
        P1[i] = temp1[i] | temp2[i];
        
        temp3[i] = cla_c[i] ^ temp1[i] ^ temp2[i];
        cla_c[i+1] = G1[i] | (P1[i] & G1[i]);
    end

    sum1 = {cla_c[w], temp3};        // final CPA or ripple adder (behavioral statement here)      
  end

  logic        signed [w-1:0] temp4;
  logic        signed [w-1  :0] temp5;
  logic        signed [w-1  :0] temp6;
  logic        signed [w-1  :0] P2;
  logic        signed [w-1  :0] G2;
  logic        signed [w+1:0] sum2;	  
  always_comb begin
	 temp4 = cr;
	 temp5 = dr;
	 
    // also try adding this logic to sequential
    cla_c2[0] = 1'b0;
    for(int i=0; i<w; i++) begin
        G2[i] = temp4[i] & temp5[i];
        P2[i] = temp4[i] | temp5[i];
        
        temp6[i] = cla_c[i] ^ temp4[i] ^ temp5[i];
        cla_c2[i+1] = G2[i] | (P2[i] & G2[i]);
    end

    sum2 = {cla_c2[w], temp6};        // final CPA or ripple adder (behavioral statement here)      
  end
  
  always_ff @(posedge clk)			
    if(reset) begin					
	  ar <= 'b0;
	  br <= 'b0;
	  cr <= 'b0;
	  dr <= 'b0;
	  s  <= 'b0;
    end
    else begin					   
	  ar <= a;
	  br <= ar;
	  cr <= br;
	  dr <= cr;
	  s  <= sum1 + sum2; 
	end

endmodule

