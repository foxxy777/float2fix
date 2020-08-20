`timescale 1ns / 1ns
`include "double2binary.v"
module double2b_testbench ();

reg clk,rst;
reg i_ready;
reg [63:0] i_double;

wire o_valid;
wire [13:0] integer_part;//取出来的整数部分
wire [3:0] fraction_part;//取出来的小数部分
wire [2:0] output_type;

parameter PERIOD = 10;

//internal
parameter NUMBER = 46;
reg [63:0] i_input[0:NUMBER-1];
//reg [63:0] i_output[0:NUMBER-1];
//reg [63:0] float_o_valid[0:NUMBER-1];
reg [13:0] i_integer_part[0:NUMBER-1];
reg [3:0] i_fraction_part[0:NUMBER-1];
reg [2:0] i_output_type[0:NUMBER-1];
integer i;


initial 
begin
	clk = 0;
	forever
		#(PERIOD/2) clk = ~clk; 
end 

double2binary double2binary_inst(
.clk(clk),
.rst(rst),
.i_ready(i_ready),
.i_double(i_double),
.o_valid(o_valid),
.sign(sign),
.integer_part(integer_part),
.fraction_part(fraction_part),
.output_type(output_type)
);

//读取输入输出
task read_input_output;
begin	
	$readmemh("float_input.txt",i_input);
	//$readmemh("float_output.txt",i_output);
end
endtask

task initialization;
begin
rst = 1'b0;
#PERIOD;
rst = 1'b1;
#PERIOD;
end
endtask

task calculate;
begin
	for(i=0;i<=NUMBER-1;i=i+1)
	begin
	/*rst = 1'b0;
    #PERIOD;
    rst = 1'b1;
#PERIOD;*/
	$display("%t i=%d",$time,i);
	//$display("%t o_valid=%b",$time,o_valid);
	i_double=i_input[i];
	#PERIOD;
	i_ready =1'b1;
	#50;
	//$display("%t i_double=%h",$time,i_double);
	//$display("%t integer_part=%h",$time,integer_part);
	//$display("%t fraction_part=%h",$time,fraction_part);
	//$display("%t output_type=%h",$time,output_type);
	/*integer_part=i_integer_part[i];
    $display("%t integer_part=%h",$time,integer_part);
	fraction_part=i_fraction_part[i];
    $display("%t fraction_part=%h",$time,fraction_part);
	output_type=i_output_type[i];
    $display("%t output_type=%h",$time,output_type);*/
	$display("------------------------------------------------------------");	
	i_ready =1'b0;
	
	
	
	
    end
end
endtask


initial
begin
$monitor("%t %m MON0 input:%h o_valid: %b sign:  %b integer_part: %b fraction_part: %b output_type: %d",$time,i_double,o_valid,sign,integer_part,fraction_part,output_type);
    
//i_double = 64'h4000_0000_0000_0000;
////2 inte_part:10   frac_part:0000 output_type:0
//i_double = 64'h3FF0000000000000;
////1 inte_part:1   frac_part:0000 output_type:0
//i_double = 64'h3FE0000000000000;
////0.5 inte_part:0   frac_part:1000 output_type:0
//i_double = 64'h7FF8000000000000;
////NAN inte_part:0   frac_part:1000 output_type:1
//i_double = 64'h7FF0000000000000;
////+INF inte_part:0   frac_part:1000 output_type:2
//i_double = 64'hFFF0000000000000;
////+INF inte_part:0   frac_part:1000 output_type:3





//i_ready = 1'b1;
$display("Begin calculation:");
    read_input_output;	
	initialization;
	calculate;
#5000

$finish;
end


endmodule
