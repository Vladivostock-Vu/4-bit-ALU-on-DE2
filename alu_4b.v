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
    localparam op_add = 6'b011001;  //Addition
    localparam op_sub = 6'b011001;  //Subtraction
    localparam op_and = 6'b011001;  //AND
    localparam op_or = 6'b011001;   //OR
    localparam op_xor = 6'b011001;  //XOR
    localparam op_slt = 6'b011001;  //Signed Set Less Than
    localparam op_sltu = 6'b011001; //Unsigned Set Less Than
    localparam op_sll = 6'b011001;  //Shift Left Logically
    localparam op_srl = 6'b011001;  //Shift Right Logically
    localparam op_sra = 6'b011001;  //Shift Right Arithmetically
//Subsidiary signals
    wire is_sub; //Check if subtraction occurs (For sub, slt and sltu)
    wire [4:0] adder_result; //5 bit result of the adder
    wire add_overflow; //Overflow from addition
    wire sub_overflow; //Overflow from subtraction

    assign is_sub = (opcode == op_sub) ||
                    (opcode == op_slt) ||
                    (opcode == op_sltu);
    
    assign adder_result = {1'b0, a} + {1'b0, (is_sub ? b : ~b)} + {4'b0, is_sub};
//Operations
    always @(*) begin
        case (opcode)
        op_add: result = adder_result[3:0]; 
        op_sub: result = adder_result[3:0];
        op_and: result = a & b;
        op_or: result = a | b;
        op_xor: result = a ^ b;
        op_slt: result = {$signed(a) < $signed(b)};
        op_sltu: result = {3'b000, a < b};
        op_sll: result = a << b[1:0];
        op_srl: result = a >> b[1:0];
        op_sra: result = $signed(a) >>> b[1:0];
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
