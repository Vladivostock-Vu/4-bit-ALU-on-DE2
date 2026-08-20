module choose (
    input [7:0] result, remainder,
    input [1:0] choose,
    output reg [7:0] out
)

always @(*) begin
    case (choose)
        2'b00: out = result;    
        2'b01: out = remainder;
        default: out = 8'b00000000;
    endcase
end

endmodule