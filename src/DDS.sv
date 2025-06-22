// DDS (Direct Digital Synthesis) module
module dds(
    input clk,      // Clock
    input rst,      // Active-high reset
    output mclk     // Master clock
);

    reg [63:0] phase_acc;

    // TUNING_WORD determines the output frequency
    parameter [63:0] TUNING_WORD = 64'd4165090344402879488;

    always @(posedge clk) begin
        // Reset the phase accumulator
        if(rst) begin
            phase_acc <= 64'd0;
        end
        // Accumulate phase by adding TUNING_WORD each clock cycle
        else begin
            phase_acc <= phase_acc + TUNING_WORD;
        end
    end

    // Output the MSB of the phase accumulator as the square wave output
    assign mclk = phase_acc[63];
endmodule
