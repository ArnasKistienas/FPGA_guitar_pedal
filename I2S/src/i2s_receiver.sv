module i2s_receiver(
        input rst,
        input sclk,
        input lrclk,
        input sdin,
        output reg [23:0]data,
        output reg dvalid
    );

    // Iterators
    reg [4:0] counter;
    reg prev_lr;

    // State encodings
    parameter
        IDLE        = 1'b0,
        READ        = 1'b1;
    reg state;
  
    // State transitions
    always @(posedge sclk) begin
        if(rst) begin
            prev_lr = lrclk;
            dvalid = 1'b0;
            state = IDLE;
        end
        case (state)
        IDLE:
            begin
                if(prev_lr ^ lrclk) begin
                    counter = 5'd23;
                    dvalid <= 1'b0;
                    state <= READ;
                end
                prev_lr <= lrclk;
            end
        READ:
            begin          
                data[counter] <= sdin;
                if(counter == 5'd0) begin
                    dvalid <= 1'b1;
                    state <= IDLE;
                end
                counter--;
            end
        default:
            state <= IDLE;
        endcase
    end
endmodule