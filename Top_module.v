module top_module(
    input [3:0] a, b,
    input [3:0] opcode,
    output [13:0] seg_a, seg_b,
    output [20:0] seg_result
);
wire [7:0] alu_result;
alu_4b alu_inst (
    .a(a),
    .b(b),
    .opcode(opcode),
    .result(alu_result[7:0])
);
display_alu display_inst (
    .a(a),
    .b(b),
    .result(alu_result[7:0]),
    .seg_a(seg_a),
    .seg_b(seg_b),
    .seg_result(seg_result)
);
endmodule