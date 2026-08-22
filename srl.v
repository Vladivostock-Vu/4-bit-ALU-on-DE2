module srl (
    input [3:0] a,
    input [1:0] shamt,
    output reg [7:0] result
);
    always @(*) begin
        case (shamt)
            2'b00: result = {4'b0, a};
            2'b01: result = {5'b00, a[3:1]};
            2'b10: result = {6'b000, a[3:2]};
            2'b11: result = {7'b0000, a[3]};
            default: result = 8'b00000000;
        endcase
    end
endmodule