module alu_4b (
    input [3:0] a, b,
    input [3:0] opcode,
    output reg [4:0] result
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

// Subsidiary signals
    wire is_sub;                    // Check if subtraction occurs (For sub, slt and sltu)
    wire [4:0] adder_result;        // 5-bit result of the adder
    wire [4:0] a_sll, a_srl, a_sra; // Shifted a
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
// Operations
    always @(*) begin
        case (opcode)
            op_add:  result = adder_result; 
            op_sub:  result = adder_result;
            op_and:  result = {1'b0, a & b};
            op_or:   result = {1'b0, a | b};
            op_xor:  result = {1'b0, a ^ b};
            op_slt:  result = {4'b0000, adder_result[4]};
            op_sltu: result = {4'b0000, adder_result[4]};
            op_sll:  result = a_sll;
            op_srl:  result = a_srl;
            op_sra:  result = a_sra;
            default: result = 5'b00000;
        endcase
    end

endmodule

//Internal modules
module sll (
    input [3:0] a,
    input [1:0] shamt,
    output reg [4:0] result
);
    always @(*) begin
        case (shamt)
            2'b00: result = {1'b0, a};
            2'b01: result = {1'b0, a[2:0], 1'b0};
            2'b10: result = {1'b0, a[1:0], 2'b00};
            2'b11: result = {1'b0, a[0], 3'b000};
            default: result = 5'b00000;
        endcase
    end
endmodule

module srl (
    input [3:0] a,
    input [1:0] shamt,
    output reg [4:0] result
);
    always @(*) begin
        case (shamt)
            2'b00: result = {1'b0, a};
            2'b01: result = {2'b00, a[3:1]};
            2'b10: result = {3'b000, a[3:2]};
            2'b11: result = {4'b0000, a[3]};
            default: result = 5'b00000;
        endcase
    end
endmodule

module sra (
    input [3:0] a,
    input [1:0] shamt,
    output reg [4:0] result
);
    always @(*) begin
        case (shamt)
            2'b00: result = {a[3], a};
            2'b01: result = {2{a[3]}, a[3:1]};
            2'b10: result = {3{a[3]}, a[3:2]};
            2'b11: result = {5{a[3]}};
            default: result = 5'b00000;
        endcase
    end
endmodule
