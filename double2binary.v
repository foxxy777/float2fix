module double2binary(

    input clk,rst,
    input i_ready,
    input [63:0] i_double,
    output reg o_valid,	
    output reg [13:0] integer_part,//取出来的整数部分
    output reg [3:0] fraction_part,//取出来的小数部分
    output reg [2:0] output_type,
	output reg sign

    );

    reg [63:0] i_double_buffer;
    reg sign_buffer;
    reg [10:0] exp;
    integer exp_result;
    integer exp_result_neg;
    reg [51:0] mantissa;
    reg [13:0] integer_part_buffer;//取出来的整数部分
    reg [3:0] fraction_part_buffer;//取出来的小数部分
    reg [2:0] output_type_buffer;
    //output_type_buffer:
    //0:正常
    //1:NAN
    //2:正无穷
    //3:负无穷
    //4.超出范围
    reg [52:0] mantissa_rightshift_integer;//因为要补足默认的1，所以加多一位在前面
    reg [51:0] mantissa_rightshift_fraction;
    reg [51:0] mantissa_leftshift_fraction;


    //FSM

    parameter IDLE       = 0;
    parameter SEPERATE  = 1;
    parameter DETERMINE      = 2;
    parameter EXTRACT      = 3;
    parameter OUTPUT     = 4;

    reg [2:0] current_state,next_state;

    always @ (posedge clk,negedge rst)
    begin
        if(!rst)
        begin
            current_state <= 0;
            next_state <= 0;
        end
        else
        begin
            current_state <= next_state;
        end
    end

    always @ (*)
        case (current_state)

            IDLE:  
            begin
			$display("IDLE");
                o_valid <= 1'b0;
                if(i_ready == 1'b1)begin
                    integer_part_buffer <= 13'b0;
                    fraction_part_buffer <= 4'b0;
                    output_type_buffer <= 3'b0;

                    i_double_buffer <= i_double;
                    next_state <= SEPERATE;
                end
                else begin
                    next_state <= IDLE;
                end 
            end

            SEPERATE:
            begin
                $display("SEPERATE");
                sign_buffer <= i_double_buffer[63];
                exp <= i_double_buffer[62:52];
                exp_result <= exp - 1023;
                exp_result_neg <= 1023 - exp;
                $display("exp_result:%d",exp_result);
                mantissa <= i_double_buffer[51:0];
                next_state <= DETERMINE;

            end

            DETERMINE:
            begin
                //$display("DETERMINE");
                if(exp == 11'b11111111111 && sign == 1'b0 && mantissa == 52'b0)begin//正无穷
                    output_type_buffer<=3'd2;
                    //"+INF"
                end else if((exp == 11'b11111111111) && (sign ==1'b1) && (mantissa == 52'b0))begin//负无穷
                    output_type_buffer<=3'd3;
                    //"-INF"
                end else if((exp == 11'b11111111111) && (mantissa != 52'b0))begin//NAN
                    output_type_buffer<=3'd1;
                    //"NAN" 
                end else
                begin
                    output_type_buffer<=3'd0;
                    //正常
                end
                //为下面的extract做准备，所以先位移好
                //一开始忘了还有默认的1的事，光移位，没添加1
                mantissa_rightshift_integer<= ({1'b1,mantissa}>>(52-exp_result));
                mantissa_rightshift_fraction<= (mantissa<<(exp_result));
                mantissa_leftshift_fraction <=({1'b1,mantissa}>>(exp_result_neg));//奇妙 居然这样是可以的，向左移负数就是右移还真没报错
                //不过最终还是采用了正常的移法，看起来方便，代价是多高了一个专
                //门用来取反的integer


                next_state <= EXTRACT;
            end

            //曾经因为state哪里该写3bit写成2bit导致这步后面的OUTPUT状态总进不
            //去
            EXTRACT:   
            begin
                $display("EXTRACT");
                if (exp_result >14)begin
                    if(output_type_buffer == 2'b0)begin
                    output_type_buffer<=3'd4;
                end else begin
                    output_type_buffer<=output_type_buffer;
                end

                    //next_state<= OUTPUT;
                    //输出超出范围
                end else if (exp_result<=14 && exp_result >=0 ) begin
                    //integer_part_buffer <= mantissa[51:(51-exp_result)];
                    //fraction_part_buffer <= mantissa[(51-exp_result-1):(51-exp_result-4)];
                    integer_part_buffer <= mantissa_rightshift_integer[13:0];
                    fraction_part_buffer <= mantissa_rightshift_fraction[51:48];
                    //next_state<= OUTPUT;
                end else if (exp_result <=-1 && exp_result >=-3) begin
                    //指数处理后为负数或0，左移
                    integer_part_buffer<= 14'b0;
                    fraction_part_buffer<= mantissa_leftshift_fraction[51:48]; 
                end else begin
				/*
                     if(output_type_buffer == 2'b0)begin
                    output_type_buffer<=3'd0;
                end else begin
                    output_type_buffer<=output_type_buffer;
                end
				*/
				integer_part_buffer<= 14'b0;
				fraction_part_buffer<=4'b0;
                    //next_state<= OUTPUT;
                    //输出超出范围
                end 
                next_state<= OUTPUT;
            end
            //  next_state<= OUTPUT;

        OUTPUT:  
        begin
            $display("OUTPUT");
			sign <=sign_buffer;
            integer_part  <= integer_part_buffer;  
            fraction_part <= fraction_part_buffer;  
            output_type   <= output_type_buffer;    
            o_valid <= 1'b1;
            if (i_ready == 1'b0) begin
			$display("to_IDLE");
                next_state <= IDLE;
            end
            else begin
			$display("remain_OUTPUT");
                next_state <= OUTPUT;
            end

        end

        default:
            next_state <= IDLE;

    endcase

    endmodule


