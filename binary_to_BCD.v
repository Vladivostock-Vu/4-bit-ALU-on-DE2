module binary_to_bcd #(
    parameter BIN_WIDTH = 4,      
    parameter BCD_DIGITS = 2     
)(
    input  wire [BIN_WIDTH-1:0]        bin_in,
    output reg  [(BCD_DIGITS*4)-1:0]   bcd_out
);

    integer i, j;
    reg [BIN_WIDTH-1:0]      temp_bin;
    reg [(BCD_DIGITS*4)-1:0] temp_bcd;

    always @(*) begin
        // Khởi tạo giá trị ban đầu
        temp_bin = bin_in;
        temp_bcd = 0;

        // Lặp qua từng bit của số nhị phân
        for (i = 0; i < BIN_WIDTH; i = i + 1) begin
            
            // BƯỚC 1: Kiểm tra từng chữ số BCD (mỗi nhóm 4 bit)
            // Nếu chữ số BCD >= 5 thì cộng thêm 3 (Add 3)
            for (j = 0; j < BCD_DIGITS; j = j + 1) begin
                if (temp_bcd[j*4 +:4] >= 5) begin
                    temp_bcd[j*4 +:4] = temp_bcd[j*4 +:4] + 3;
                end
            end
            
            // BƯỚC 2: Dịch trái 1 bit (Shift left)
            // Đưa bit có trọng số lớn nhất (MSB) của temp_bin vào bit có trọng số nhỏ nhất (LSB) của temp_bcd
            temp_bcd = {temp_bcd[(BCD_DIGITS*4)-2:0], temp_bin[BIN_WIDTH-1]};
            temp_bin = temp_bin << 1;
            
        end
        
        // Gán kết quả cuối cùng ra output
        bcd_out = temp_bcd;
    end

endmodule