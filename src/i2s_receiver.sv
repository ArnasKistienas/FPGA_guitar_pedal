module i2s_receiver(
        input rst,
        input sclk,
        input lrclk,
        input sdin,
        input btnL,
        input btnR,
        output reg signed [23:0]ldata,
        output reg signed [23:0]rdata,
        output reg dvalid,
        output ledL,
        output ledR
    );

    // Iterators
    reg [4:0] counter;
    reg prev_lr;
    reg [23:0] indata;

    reg btn_pressed_L, btn_pressed_R, enableL, enableR;
    // State encodings
    parameter
        IDLE        = 2'b00,
        READ        = 2'b01,
        WRITE       = 2'b10;
    reg [1:0] state;

    assign ledL = enableL;
    assign ledR = enableR;

    // State transitions
    always @(posedge sclk or posedge rst) begin
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
        end else begin
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
                    indata <= indata << 1;
                    indata[0] <=  sdin;          
                    if(counter == 5'd0) begin
                        //dvalid <= 1'b1;
                        state <= WRITE;
                        /*if(lrclk && enableL) begin
                            ldata <= indata;
                        end else if(!lrclk && enableR) begin
                            rdata <= indata;
                        end*/
                    end
                    counter <= counter - 1;
                    /*
                    data[counter] <= sdin;
                    if(counter == 5'd0) begin
                        dvalid <= 1'b1;
                        state <= IDLE;
                    end
                    counter--;
                    */
                end
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
            //Kazkas negerai su mygtuku paspaudimais
            if(btnL ^ btn_pressed_L & btnL) begin
                enableL <= ~enableL;
            end
            if(btnR ^ btn_pressed_R & btnR) begin
                enableR <= ~enableR;
            end
            btn_pressed_L <= btnL;
            btn_pressed_R <= btnR;
        end
    end
endmodule