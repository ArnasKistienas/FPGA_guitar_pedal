module seg7_driver (
    input  wire        clk,          
    input  wire        rst,        
    input  wire [15:0] D_in,         // Number data input
    output reg  [3:0]  SSEG_AN,      // SSEG_ANode enables
    output reg  [6:0]  SSEG_CA       // segment outputs
);

    
    reg [16:0] div_cnt;
    wire [1:0] sel;

    always @(posedge clk) begin
        if (rst)
            div_cnt <= 17'd0;
        else
            div_cnt <= div_cnt + 1'b1;
    end

    always @(*) begin
        SSEG_AN = 4'b1111;      // default off (inactive)
        SSEG_AN[div_cnt[16:15]] = 1'b0;    // enable selected digit
    end

    
    reg [3:0] nibble;
    always @(*) begin
        case (sel)
            2'b00: nibble = D_in[3:0];  
            2'b01: nibble = D_in[7:4];
            2'b10: nibble = D_in[11:8];
            2'b11: nibble = D_in[15:12];
            default: nibble = 4'h0;
        endcase
    end

    


    always @(*) begin
        case (nibble)
            4'h0: SSEG_CA = 7'b1000000;
            4'h1: SSEG_CA = 7'b1111001;
            4'h2: SSEG_CA = 7'b0100100;
            4'h3: SSEG_CA = 7'b0110000;
            4'h4: SSEG_CA = 7'b0011001;
            4'h5: SSEG_CA = 7'b0010010;
            4'h6: SSEG_CA = 7'b0000010;
            4'h7: SSEG_CA = 7'b1111000;
            4'h8: SSEG_CA = 7'b0000000;
            4'h9: SSEG_CA = 7'b0010000;
            4'hA: SSEG_CA = 7'b0001000;
            4'hB: SSEG_CA = 7'b0000011; // displays 'b'
            4'hC: SSEG_CA = 7'b1000110;
            4'hD: SSEG_CA = 7'b0100001; // displays 'd'
            4'hE: SSEG_CA = 7'b0000110;
            4'hF: SSEG_CA = 7'b0001110; // displays 'F'
            default: SSEG_CA = 7'b1111111; // blSSEG_ANk
        endcase
    end
endmodule