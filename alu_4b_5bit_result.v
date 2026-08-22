module alu_4b (
    input [3:0] a, b,
    input [3:0] opcode,
    output reg [7:0] result,
    output reg [7:0] remainder
);

    localparam op_add  = 4'b0000;  // Addition
    localparam op_sub  = 4'b0001;  // Subtraction
    localparam op_and  = 4'b0010;  // AND
    localparam op_or   = 4'b0011;  // OR
    localparam op_xor  = 4'b0100;  // XOR
    localparam op_slt  = 4'b0101;  // Signed Set Less Than
    localparam op_sltu = 4'b0110;  // Unsigned Set Less Than
    localparam op_sll  = 4'b0111;  // Shift Left Logically
    localparam op_srl  = 4'b1000;  // Shift Right Logically
    localparam op_sra  = 4'b1001;  // Shift Right Arithmetically
    localparam op_mul  = 4'b1010;  // Multiplication
    localparam op_div  = 4'b1011;  // Division
 
// Subsidiary signals
    wire is_sub;                    // Check if subtraction occurs (For sub, slt and sltu)

    wire [7:0] adder_result;        // 8-bit result of the adder
    wire [7:0] a_sll, a_srl, a_sra; // Shifted a
    wire [7:0] mul_result;          // 8-bit result of multiplication
    wire [7:0] div_result;          // 8-bit result of division
    wire [7:0] div_remainder;       // 8-bit remainder of division
    
    wire a_sign;
    wire b_sign;
    
    assign is_sub = (opcode == op_sub) ||
                    (opcode == op_slt) ||
                    (opcode == op_sltu);
    
    
    sll sll_inst(.a(a), .shamt(b[1:0]), .result(a_sll));
    srl srl_inst(.a(a), .shamt(b[1:0]), .result(a_srl));
    sra sra_inst(.a(a), .shamt(b[1:0]), .result(a_sra));  

    assign a_sign = (opcode == op_sltu) ? 1'b0 : a[3];
    assign b_sign = (opcode == op_sltu) ? 1'b0 : b[3];

    multi_4bit multiplier (
        .a(a),
        .b(b),
        .result(mul_result)
    );

    div_4bit divider (
        .a(a),
        .b(b),
        .result(div_result),
        .remainder(div_remainder)
    );
    
    assign adder_result = {4{a_sign}, a} + (is_sub ? ~{4{b_sign}, b} : {4{b_sign}, b}) + {7'b0000000, is_sub};    
    
// Operations
    always @(*) begin
        case (opcode)
            op_add:  result = adder_result; 
            op_sub:  result = adder_result;
            op_and:  result = {4'b0, a & b};
            op_or:   result = {4'b0, a | b};
            op_xor:  result = {4'b0, a ^ b};
            op_slt:  result = {7'b0000000, adder_result[7]};
            op_sltu: result = {7'b0000000, adder_result[7]};
            op_sll:  result = a_sll;
            op_srl:  result = a_srl;
            op_sra:  result = a_sra;
            op_mul:  result = mul_result;
            op_div:  result = div_result;
            default: result = 8'b00000000;
        endcase

        case(opcode)
            op_div:  remainder = div_remainder;
            default: remainder = 8'b00000000;
        endcase
    end

endmodule