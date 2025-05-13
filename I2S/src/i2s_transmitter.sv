module i2s_transmitter(
        input rst,
        input sclk,
        input lrclk,
        input [23:0]data,
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
                    counter = 5'd23;
                    state <= SEND;
                end
                prev_lr <= lrclk;
            end
        SEND:
            begin          
                sdout <= data[counter];
                if(counter == 5'd0) begin
                    state <= IDLE;
                end
                counter--;
            end
        default:
            state <= IDLE;
        endcase
    end
endmodule