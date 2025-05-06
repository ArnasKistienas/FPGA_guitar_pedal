module i2s_clock_divider(
    //input [23:0] data;
    //input lineInSDOUT;
    input rst,
    input mclk,
    output reg sclk,
    output reg lrclk
    );

    reg [2:0] mclk_count;
    reg [5:0] sclk_count;

    always @(mclk) begin
        if(rst) begin
            sclk = mclk;
            lrclk = mclk;
            mclk_count = 0;
            sclk_count = 0;
        end
        if(mclk_count == 3'd7) begin
            sclk = ~sclk;
            if(sclk_count == 6'd63) begin
                lrclk = ~lrclk;
            end
            sclk_count++;
        end
        mclk_count++;
    end
endmodule