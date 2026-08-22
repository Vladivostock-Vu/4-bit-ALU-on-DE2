module sll (
    input [3:0] a,
    input [1:0] shamt,
    output reg [7:0] result
);
    always @(*) begin
        case (shamt)
            2'b00: result = {4'b0, a};
            2'b01: result = {4'b0, a[2:0], 1'b0};
            2'b10: result = {4'b0, a[1:0], 2'b00};
            2'b11: result = {4'b0, a[0], 3'b000};
            default: result = 8'b00000000;
        endcase
    end
endmodule