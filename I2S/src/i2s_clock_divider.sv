module i2s_clock_divider(
    input rst,
    input mclk,
    output reg sclk,
    output reg lrclk
    );

    reg [1:0] mclk_count;
    reg [5:0] sclk_count;

    always @(posedge mclk) begin
        if(rst) begin
            sclk <= 1'b0;
            lrclk <= 1'b0;
            mclk_count <= 3'd0;
            sclk_count <= 6'd0;
        end else begin
            if (mclk_count == 3'd3) begin
                sclk <= ~sclk;
                if(sclk_count == 6'd63) begin
                    lrclk <= ~lrclk;
                    sclk_count <= 6'd0;
                end else begin
                    sclk_count <= sclk_count + 1;
                end
                mclk_count <= 3'd0;
            end else begin
                mclk_count <= mclk_count + 1;
            end
        end
        
    end
endmodule