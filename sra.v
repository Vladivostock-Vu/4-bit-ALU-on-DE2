module sra (
    input [3:0] a,
    input [1:0] shamt,
    output reg [7:0] result
);
    always @(*) begin
        case (shamt)
            2'b00: result = {4{a[3]}, a};
            2'b01: result = {5{a[3]}, a[3:1]};
            2'b10: result = {6{a[3]}, a[3:2]};
            2'b11: result = {8{a[3]}};
            default: result = 8'b00000000;
        endcase
    end
endmodule