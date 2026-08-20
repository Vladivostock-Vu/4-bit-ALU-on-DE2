module display_alu (
    input [3:0] a, b,
    input [7:0] result,
    output reg [13:0] seg_a, seg_b,         
    output reg [20:0] seg_result            
);

    wire [3:0] a_unsigned, b_unsigned;
    wire [7:0] result_unsigned;
    assign a_unsigned = a[3] ? (~a + 1) : a;
    assign b_unsigned = b[3] ? (~b + 1) : b;
    assign result_unsigned = result[7] ? (~result + 1) : result;
    wire [3:0] a_bcd, b_bcd;
    wire [7:0] result_bcd;

    binary_to_bcd #(.BIN_WIDTH(4), .BCD_DIGITS(1)) bcd_a (
        .bin_in(a_unsigned),
        .bcd_out(a_bcd[3:0])
    );

    binary_to_bcd #(.BIN_WIDTH(4), .BCD_DIGITS(1)) bcd_b (
        .bin_in(b_unsigned),
        .bcd_out(b_bcd[3:0])
    );

    binary_to_bcd #(.BIN_WIDTH(8), .BCD_DIGITS(2)) bcd_result (
        .bin_in(result_unsigned),
        .bcd_out(result_bcd[7:0])
    );

    // Xử lý hiển thị cho a
    always @(*) begin
        seg_a[13:7] = a[3] ? 7'b0111111 : 7'b1111111; // Dấu âm cho a
        case (a_bcd)
            4'h0: seg_a[6:0] = 7'b1000000;   
            4'h1: seg_a[6:0] = 7'b1111001;
            4'h2: seg_a[6:0] = 7'b0100100;
            4'h3: seg_a[6:0] = 7'b0110000;
            4'h4: seg_a[6:0] = 7'b0011001;
            4'h5: seg_a[6:0] = 7'b0010010;
            4'h6: seg_a[6:0] = 7'b0000010;
            4'h7: seg_a[6:0] = 7'b1111000;
            4'h8: seg_a[6:0] = 7'b0000000;
            4'h9: seg_a[6:0] = 7'b0010000;
            default: seg_a[6:0] = 7'b1111111;
        endcase
    end

    // Xử lý hiển thị cho b
    always @(*) begin
        seg_b[13:7] = b[3] ? 7'b0111111 : 7'b1111111; // Sửa lỗi logic: Dùng b[3] thay vì result[4]
        case (b_bcd)
            4'h0: seg_b[6:0] = 7'b1000000;   
            4'h1: seg_b[6:0] = 7'b1111001;
            4'h2: seg_b[6:0] = 7'b0100100;
            4'h3: seg_b[6:0] = 7'b0110000;
            4'h4: seg_b[6:0] = 7'b0011001;
            4'h5: seg_b[6:0] = 7'b0010010;
            4'h6: seg_b[6:0] = 7'b0000010;
            4'h7: seg_b[6:0] = 7'b1111000;
            4'h8: seg_b[6:0] = 7'b0000000;
            4'h9: seg_b[6:0] = 7'b0010000;
            default: seg_b[6:0] = 7'b1111111;
        endcase
    end

    // Xử lý hiển thị cho result
    always @(*) begin
        seg_result[20:14] = result[7] ? 7'b0111111 : 7'b1111111; // Dấu âm cho result
        
        // Hàng chục
        case (result_bcd[7:4])
            4'h0: seg_result[13:7] = 7'b1000000;   
            4'h1: seg_result[13:7] = 7'b1111001;
            4'h2: seg_result[13:7] = 7'b0100100;
            4'h3: seg_result[13:7] = 7'b0110000;
            4'h4: seg_result[13:7] = 7'b0011001;
            4'h5: seg_result[13:7] = 7'b0010010;
            4'h6: seg_result[13:7] = 7'b0000010;
            4'h7: seg_result[13:7] = 7'b1111000;
            4'h8: seg_result[13:7] = 7'b0000000;
            4'h9: seg_result[13:7] = 7'b0010000;
            default: seg_result[13:7] = 7'b1111111;
        endcase
        
        // Hàng đơn vị
        case (result_bcd[3:0])
            4'h0: seg_result[6:0] = 7'b1000000;   
            4'h1: seg_result[6:0] = 7'b1111001;
            4'h2: seg_result[6:0] = 7'b0100100;
            4'h3: seg_result[6:0] = 7'b0110000;
            4'h4: seg_result[6:0] = 7'b0011001;
            4'h5: seg_result[6:0] = 7'b0010010;
            4'h6: seg_result[6:0] = 7'b0000010;
            4'h7: seg_result[6:0] = 7'b1111000;
            4'h8: seg_result[6:0] = 7'b0000000;
            4'h9: seg_result[6:0] = 7'b0010000;
            default: seg_result[6:0] = 7'b1111111;
        endcase
    end
endmodule