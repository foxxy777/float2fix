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
        4'b0001 : o_fraction_part_buffer <= 32'h ;
        4'b0010 : o_fraction_part_buffer <= 32'h ;
        4'b0011 : o_fraction_part_buffer <= 32'h ;
        4'b0100 : o_fraction_part_buffer <= 32'h ;
        4'b0101 : o_fraction_part_buffer <= 32'h ;
        4'b0110 : o_fraction_part_buffer <= 32'h ;
        4'b0111 : o_fraction_part_buffer <= 32'h ;
        4'b1000 : o_fraction_part_buffer <= 32'h ;
        4'b1001 : o_fraction_part_buffer <= 32'h ;
        4'b1010 : o_fraction_part_buffer <= 32'h ;
        4'b1011 : o_fraction_part_buffer <= 32'h ;
        4'b1100 : o_fraction_part_buffer <= 32'h ;
        4'b1101 : o_fraction_part_buffer <= 32'h ;
        4'b1110 : o_fraction_part_buffer <= 32'h ;
        4'b1111 : o_fraction_part_buffer <= 32'h ;

default: o_fraction_part_buffer <= 32'h30303030 ;//默认情况下小数位输出全为0

    end
end




endmodule
