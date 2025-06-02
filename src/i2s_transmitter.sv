module i2s_transmitter(
        input rst,
        input sclk,
        input lrclk,
        input signed [23:0]ldata,
        input signed [23:0]rdata,
        output reg sdout
    );

    // Iterators
    reg [4:0] counter;
    reg prev_lr;

    // State encodings
    parameter
        IDLE        = 1'b0,
        SEND        = 1'b1;
    reg state;
  
    // State transitions
    always @(negedge sclk or posedge rst) begin
        if(rst) begin
            prev_lr <= lrclk;
            state <= IDLE;
            sdout <= 1'b0;
            counter <= 1'b0;
        end else begin
            case (state)
            IDLE:
                begin
                    sdout <= 1'b0;
                    if(prev_lr ^ lrclk) begin
                        counter <= 5'd23;
                        state <= SEND;
                    end
                    prev_lr <= lrclk;
                end
            SEND:
                begin          
                    sdout <= lrclk ? ldata[counter] : rdata[counter];
                    if(counter == 5'd0) begin
                        state <= IDLE;
                    end
                    counter--;
                end
            default:
                state <= IDLE;
            endcase
        end
    end
endmodule