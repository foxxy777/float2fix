module fraction_part(
input [3:0] i_fraction_part,
output reg [31:0] o_fraction_part
);

reg [31:0] o_fraction_part_buffer;
always @ (i_fraction_part)
begin
    case(i_fraction_part)
    begin
        //对照着asic表，直接一步到位输出4位小数的asic码得了,表在这：https://www.sojson.com/ascii.html
        4'b0001 : o_fraction_part_buffer <= 32'h30363235 ;//0.0625
        4'b0010 : o_fraction_part_buffer <= 32'h31323530 ;//0.125
        4'b0011 : o_fraction_part_buffer <= 32'h31383735 ;//0.1875
        4'b0100 : o_fraction_part_buffer <= 32'h32353030 ;//0.25
        4'b0101 : o_fraction_part_buffer <= 32'h33313235 ;//0.3125
        4'b0110 : o_fraction_part_buffer <= 32'h33373530 ;//0.375
        4'b0111 : o_fraction_part_buffer <= 32'h34333735 ;//0.4375
        4'b1000 : o_fraction_part_buffer <= 32'h35303030 ;//0.5
        4'b1001 : o_fraction_part_buffer <= 32'h35363235 ;//0.5625
        4'b1010 : o_fraction_part_buffer <= 32'h36323530 ;//0.625
        4'b1011 : o_fraction_part_buffer <= 32'h36383735 ;//0.6875
        4'b1100 : o_fraction_part_buffer <= 32'h37353030 ;//0.75
        4'b1101 : o_fraction_part_buffer <= 32'h38313235 ;//0.8125
        4'b1110 : o_fraction_part_buffer <= 32'h38373530 ;//0.875
        4'b1111 : o_fraction_part_buffer <= 32'h39333735 ;//0.9375

default: o_fraction_part_buffer <= 32'h30303030 ;//默认情况下小数位输出全为0

    end
end




endmodule

