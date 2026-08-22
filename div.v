module div_4bit (
    input [3:0] a,          // Dividend (signed)
    input [3:0] b,          // Divisor (signed)
    output reg [7:0] result,// Quotient (signed, sign-extended)
    output reg [7:0] remainder // Remainder (signed, sign-extended)
);

    wire sign_a = a[3];
    wire sign_b = b[3];
    wire div_zero = (b == 4'b0);

    reg [3:0] mag_a, mag_b;
    reg [4:0] rem_temp;
    reg [3:0] quot_temp;
    integer i;

    always @(*) begin
        if (div_zero) begin
            result = 8'sd0;
            remainder = 8'sd0;
        end else begin
            // Step 1: Extract absolute magnitudes
            mag_a = sign_a ? (~a + 4'd1) : a;
            mag_b = sign_b ? (~b + 4'd1) : b;

            // Step 2: Unsigned shift-and-subtract division loop
            rem_temp = 5'd0;
            quot_temp = 4'd0;
            
            for (i = 3; i >= 0; i = i - 1) begin
                rem_temp = {rem_temp[3:0], mag_a[i]};
                if (rem_temp >= {1'b0, mag_b}) begin
                    rem_temp = rem_temp - {1'b0, mag_b};
                    quot_temp[i] = 1'b1;
                end else begin
                    quot_temp[i] = 1'b0;
                end
            end

            // Step 3: Apply signs and sign-extend to 8 bits
            // Quotient sign is negative if signs differ (XOR)
            if ((sign_a ^ sign_b) && (quot_temp != 4'd0)) begin
                result = {{4{1'b1}}, (~quot_temp + 4'd1)};
            end else begin
                result = {{4{1'b0}}, quot_temp};
            end

            // Remainder matches the sign of the dividend
            if (sign_a && (rem_temp[3:0] != 4'd0)) begin
                remainder = {{4{1'b1}}, (~rem_temp[3:0] + 4'd1)};
            end else begin
                remainder = {{4{1'b0}}, rem_temp[3:0]};
            end
        end
    end

endmodule