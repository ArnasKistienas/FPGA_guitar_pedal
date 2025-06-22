// I2S Transmitter Module
module i2s_transmitter(
        input rst,                  // Active-high reset
        input sclk,                 // Serial clock
        input lrclk,                // Left-right clock
        input signed [23:0]ldata,   // Left channel data
        input signed [23:0]rdata,   // Right channel data
        output reg sdout            // Serial data output
    );

    reg [4:0] counter;

    // Previous lrclk value to detect edge
    reg prev_lr;

    // State encodings
    parameter
        IDLE        = 1'b0,
        SEND        = 1'b1;
    reg state;
  
    always @(negedge sclk or posedge rst) begin
        // Reset all internal registers and outputs
        if(rst) begin
            prev_lr <= lrclk;
            state <= IDLE;
            sdout <= 1'b0;
            counter <= 1'b0;
        end
        // FSM
        else begin
            case (state)
            // Wait for lrclk edge to begin sending out first bit
            IDLE:
                begin
                    sdout <= 1'b0;
                    if(prev_lr ^ lrclk) begin
                        counter <= 5'd22;
                        // Select MSB of the left or right channel based on lrclk
                        sdout <= lrclk ? ldata[23] : rdata[23];
                        state <= SEND;
                    end
                    prev_lr <= lrclk;
                end
            // Transmit the 24-bit data for either left or right channel
            SEND:
                begin          
                    sdout <= lrclk ? ldata[counter] : rdata[counter];
                    if(counter == 5'd0) begin
                        // Once all 24 bits are sent, return to IDLE state
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