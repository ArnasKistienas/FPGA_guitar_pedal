// I2S Receiver Module
module i2s_receiver(
        input rst,                      // Active-high reset
        input sclk,                     // Serial clock
        input lrclk,                    // Left-right clock
        input sdin,                     // Serial data input
        input btnL,                     // Button to toggle left channel enable 
        input btnR,                     // Button to toggle right channel enable
        output reg signed [23:0]ldata,  // Left channel data
        output reg signed [23:0]rdata,  // Right channel data
        output reg dvalid,              // Data valid flag
        output ledL,                    // Signal showing that left channel is enabled
        output ledR                     // Signal showing that right channel is enabled
    );

    reg [4:0] counter;

    // Previous lrclk value to detect edge
    reg prev_lr;

    // Temporary place to store incoming data before sending it away
    reg [23:0] indata;

    // Button press states and channel enable flags
    reg btn_pressed_L, btn_pressed_R, enableL, enableR;
    
    // State encodings
    parameter
        IDLE        = 2'b00,
        READ        = 2'b01,
        WRITE       = 2'b10;
    reg [1:0] state;

    assign ledL = enableL;
    assign ledR = enableR;

    always @(posedge sclk or posedge rst) begin
        // Reset internal state and outputs
        if(rst) begin
            prev_lr <= lrclk;
            dvalid <= 1'b0;
            indata <= 24'd0;
            ldata <= 24'd0;
            rdata <= 24'd0;
            state <= IDLE;
            enableL = 1'b1;
            enableR = 1'b1;
            btn_pressed_L =1'b0;
            btn_pressed_R =1'b0;
        end
        // FSM
        else begin
            case (state)
            // Wait for lrclk edge to begin reading new word
            IDLE:
                begin
                    if(prev_lr ^ lrclk) begin
                        counter <= 5'd23;
                        dvalid <= 1'b0;
                        state <= READ;
                    end
                    prev_lr <= lrclk;
                end
            // Read 24 bits from sdin
            READ:
                begin
                    indata <= indata << 1;
                    indata[0] <=  sdin;          
                    if(counter == 5'd0) begin
                        // Finished reading all 24 bits
                        state <= WRITE;
                    end
                    counter <= counter - 1;
                end
            // Write to left/right data registers based on lrclk
            WRITE:
                begin
                    dvalid <= 1'b1;
                    if(lrclk & enableL) begin                    
                        ldata <= indata;
                     end else if(!lrclk & enableR) begin
                        rdata <= indata;
                    end
                    state <= IDLE;
                end
            default:
                state <= IDLE;
            endcase
            // Toggle left channel enable
            if(btnL ^ btn_pressed_L & btnL) begin
                enableL <= ~enableL;
            end
            // Toggle right channel enable
            if(btnR ^ btn_pressed_R & btnR) begin
                enableR <= ~enableR;
            end
            btn_pressed_L <= btnL;
            btn_pressed_R <= btnR;
        end
    end
endmodule