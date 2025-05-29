module dds(
    input clk,
    input rst,
    output mclk
);

    reg [63:0] phase_acc;
    parameter [63:0] TUNING_WORD = 64'd4165090344402879488;

    always @(posedge clk) begin
        if(rst) begin
            phase_acc <= 64'd0;
        end else begin
            phase_acc <= phase_acc + TUNING_WORD;
        end
    end

    assign mclk = phase_acc[63]; // MSB = square wave output
endmodule
