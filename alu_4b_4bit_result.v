module alu_4b (
    input [3:0] a, b,
    input [5:0] opcode,
    output reg [3:0] result,
    output wire zero,
    output wire sign,
    output wire overflow,
    output wire carry,
);
//Operation codes
    localparam op_add  = 6'b011001; //Addition
    localparam op_sub  = 6'b011001; //Subtraction
    localparam op_and  = 6'b011001; //AND
    localparam op_or   = 6'b011001; //OR
    localparam op_xor  = 6'b011001; //XOR
    localparam op_slt  = 6'b011001; //Signed Set Less Than
    localparam op_sltu = 6'b011001; //Unsigned Set Less Than
    localparam op_sll  = 6'b011001; //Shift Left Logically
    localparam op_srl  = 6'b011001; //Shift Right Logically
    localparam op_sra  = 6'b011001; //Shift Right Arithmetically
//Subsidiary signals
    wire is_sub;                    //Check if subtraction occurs (For sub, slt and sltu)
    wire [4:0] adder_result;        //5 bit result of the adder
    wire add_overflow;              //Overflow from addition
    wire sub_overflow;              //Overflow from subtraction
    wire [4:0] a_sll, a_srl, a_sra; //Shifted a
    wire a_sign;
    wire b_sign;

    assign is_sub = (opcode == op_sub) ||
                    (opcode == op_slt) ||
                    (opcode == op_sltu);
    
    assign adder_result = {a_sign, a} + (is_sub ? ~{b_sign, b} : {b_sign, b}) + {4'b0000, is_sub};

    sll sll_inst(.a(a), .shamt(b[1:0]), .result(a_sll));
    srl srl_inst(.a(a), .shamt(b[1:0]), .result(a_srl));
    sra sra_inst(.a(a), .shamt(b[1:0]), .result(a_sra));  

    assign a_sign = (opcode == op_sltu) ? 1'b0 : a[3];
    assign b_sign = (opcode == op_sltu) ? 1'b0 : b[3];
//Operations
    always @(*) begin
        case (opcode)
        op_add:  result = adder_result[3:0]; 
        op_sub:  result = adder_result[3:0];
        op_and:  result = a & b;
        op_or:   result  = a | b;
        op_xor:  result = a ^ b;
        op_slt:  result = {3'b000, carry};
        op_sltu: result = {3'b000, carry};
        op_sll:  result = a << b[1:0];
        op_srl:  result = a >> b[1:0];
        op_sra:  result = $signed(a) >>> b[1:0];
        defaut:  result = 4'b0000;
        endcase
    end
//Flag
    assign zero = (result == 4'b0000);

    assign sign = result[3];
    
    assign carry = adder_result[4];

    assign add_overflow = (a[3] == b[3]) && (alu_result[3] != a[3]);
    assign sub_overflow = (a[3] != b[3]) && (alu_result[3] != a[3]);
    assign overflow = (opcode == op_sub) ? sub_overflow :
                      (opcode == op_add) ? add_overflow : 1'b0;

endmodule
//Internal modules
module sll (
    input [3:0] a,
    input [1:0] shamt,
    output reg [3:0] result
);
    always @(*) begin
        case (shamt)
            2'b00: result = a;
            2'b01: result = {a[2:0], 1'b0};
            2'b10: result = {a[1:0], 2'b00};
            2'b11: result = {a[0], 3'b000};
            default: result = 4'b0000;
        endcase
    end
endmodule

module srl (
    input [3:0] a,
    input [1:0] shamt,
    output reg [3:0] result
);
    always @(*) begin
        case (shamt)
            2'b00: result = a;
            2'b01: result = {1'b0, a[3:1]};
            2'b10: result = {2'b00, a[3:2]};
            2'b11: result = {3'b000, a[3]};
            default: result = 4'b0000;
        endcase
    end
endmodule

module sra (
    input [3:0] a,
    input [1:0] shamt,
    output reg [3:0] result
);
    always @(*) begin
        case (shamt)
            2'b00: result = a;
            2'b01: result = {a[3], a[3:1]};
            2'b10: result = {2{a[3]}, a[3:2]};
            2'b11: result = {4{a[3]}};
            default: result = 4'b0000;
        endcase
    end
endmodule
