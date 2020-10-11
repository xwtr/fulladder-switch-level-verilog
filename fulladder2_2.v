




module cmos_inv (input i1,output o1);

supply1 vcc;
supply0 gnd;
pmos (o1, vcc, i1);
nmos (o1, gnd, i1);
endmodule



module cmos_nand(input a, input b , output o2);

wire net;
supply0 vss;
supply1 vdd;

pmos(o2, vdd,a);
pmos(o2, vdd,b);

nmos(net,vss,b);
nmos(o2,net,a);


endmodule


module cmos_xor(input a,input b,output o3);
supply0 vss; //ground
supply1 vdd;

wire w1,w2,w3,w4;


pmos(w1,vdd,~b);
pmos(o3,w1,a);

pmos(w2,vdd,b);
pmos(o3,w2,~a);


nmos(w3,vss,a);
nmos(o3,w3,b);



nmos(w4,vss,~a);
nmos(o3,w4,~b);

endmodule


module full_adder_2(input a,input b,input c ,output s,output cout);
wire w1;//G
wire w2;//F
wire w3;//E

cmos_xor xor1(a,b,w1);
cmos_xor xor2(w1,c,s);

cmos_nand n1(a,b,w2);
cmos_nand n2(c,w1,w3);
cmos_nand n3(w2,w3,cout);

endmodule


`timescale 1ns / 1ps
module main;

  reg  A_input, B_input, C_input;
  wire Sum, C_output;  

 
  full_adder_2 instantiation(.a(A_input), .b(B_input), .c(C_input), .s(Sum), .cout(C_output));

  initial
    begin
      $dumpfile("xyz.vcd");
      $dumpvars;

    
      A_input=0;
      B_input=0;
      C_input=0;
       #100 $finish;
    end

always #40 A_input=~A_input;
always #20 B_input=~B_input;
always #10 C_input=~C_input;

  always @(A_input or B_input or C_input)
      $monitor("At TIME(in ns)=%t, A=%d B=%d C=%d Sum = %d Carry = %d", $time, A_input, B_input, C_input, Sum, C_output);

endmodule