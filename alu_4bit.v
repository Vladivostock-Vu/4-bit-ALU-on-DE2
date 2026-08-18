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
    wire is_sub;             // Check if subtraction occurs (For sub, slt and sltu)
    wire [4:0] adder_result; // 5-bit result of the adder

    assign is_sub = (opcode == op_sub) ||
                    (opcode == op_slt) ||
                    (opcode == op_sltu);
    
assign adder_result = {a[3], a} + { (is_sub ? ~b[3] : b[3]), (is_sub ? ~b : b)} + {4'b0000, is_sub};    
// Operations
    always @(*) begin
        case (opcode)
            op_add:  result = adder_result[4:0]; 
            op_sub:  result = adder_result[4:0];
            op_and:  result = {1'b0, a & b};
            op_or:   result = {1'b0, a | b};
            op_xor:  result = {1'b0, a ^ b};
            op_slt:  result = {4'b0000, $signed(a) < $signed(b)};
            op_sltu: result = {4'b0000, a < b};
            op_sll:  result = {1'b0, a << b[1:0]};
            op_srl:  result = {1'b0, a >> b[1:0]};
            op_sra:  result = {1'b0, $signed(a) >>> b[1:0]};
            default: result = 5'b00000;
        endcase
    end

endmodule
