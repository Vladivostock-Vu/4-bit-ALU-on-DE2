module multi_4bit (
    input   [3:0] a,
    input   [3:0] b,
    output  [7:0] result
);
    wire [7:0] temp_result [3:0];
    genvar i;
    
    // Tạo tích riêng phần cho 3 bit đầu tiên (b[0] đến b[2])
    generate
        for (i = 0; i < 3; i = i + 1) begin : multiplier_block
            assign temp_result[i] = {4'b0, ~(a[3] & b[i]), (a[2:0] & {3{b[i]}})} << i;
        end
    endgenerate
    
    // Tạo tích riêng phần cuối cùng cho bit dấu (b[3])
    assign temp_result[3] = {4'b0, (a[3] & b[3]), ~(a[2:0] & {3{b[3]}})} << 3;

    wire [7:0] sum_accum [3:0];  // các tầng tích riêng
    assign sum_accum[0] = temp_result[0];
// cộng dồn chuỗi
    generate
        for (i = 1; i < 4; i = i + 1) begin : adder_chain 
            assign sum_accum[i] = sum_accum[i-1] + temp_result[i];
        end
    endgenerate
    wire [7:0] correction;
    assign correction = (8'd1 << 4) | (8'd1 << 7);
    assign result = sum_accum[3] + correction;

endmodule