module i2s_transmitter(
        input rst,
        input mclk,
        input sclk,
        input lrclk,
        input [23:0]data,
        output reg sdout,
        output mclk_out,
        output sclk_out,
        output lrclk_out
    );
    assign mclk_out = mclk;
    assign sclk_out = sclk;
    assign lrclk_out = lrclk;

    // Iterators
    reg [4:0] counter;
    reg prev_lr;

    // State encodings
    parameter
        IDLE        = 1'b0,
        SEND        = 1'b1;
    reg state;
  
    // State transitions
    always @(posedge sclk) begin
        if(rst) begin
            prev_lr = lrclk;
            state = IDLE;
        end
        case (state)
        IDLE:
            begin
                sdout <= 1'b0;
                if(prev_lr ^ lrclk) begin
                    counter = 23;
                    state <= SEND;
                end
                prev_lr <= lrclk;
            end
        SEND:
            begin          
                sdout <= data[counter];
                if(counter == 3'd0) begin
                    state <= IDLE;
                end
                counter--;
            end
        default:
            state <= IDLE;
        endcase
    end
endmodule