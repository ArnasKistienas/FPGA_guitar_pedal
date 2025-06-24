# 🎸 FPGA distortion effect pedal

FPGA based guitar pedal board made using I2S and digital filter logic. The project is a working digital distorion pedal viable for practical use with an electric guitar.
## Intro
This project includes code to use for the Digilent I2S2 Pmod to induce a distortion effect to any sound going into the pmod's input. The I2S communication code created is based on the I2S2 quick start guide located on Digilent's website. We also included a custom .xdc constraints file for the Basys 3 FPGA development board.

## Requirements
- FPGA development board(on default the project uses AMD Artix™ 7 FPGA Trainer Board(part number: XC7A35T-1CPG236C)
- I2S2 Pmod by Digilent

## Setup
To use this project, create a Vivado project and under [insert_project_name].srcs\sources_1\new\ place all the .sv files located in the projects "src" folder.
For simulations(if you want to run them) place the "sim" files under [insert_project_name].srcs\sim_1\new\

Then you can run it like any Vivado project via running synthesis, then impementation, and generating bitstream afterwards.

If you want to code your own effect, you can do it by editing the ,,distortion.sv" file.

## How the distortion effect works
Distortion is also known as clipping and is achieved via 2 methods in analog electronics: by pushing the gain so hard that the amplifier starts clipping the signal on its own, or by clipping the signal using diode limiters.

![image](https://github.com/user-attachments/assets/118574d2-a494-4127-981b-a2c97b99d307)

Since we want the effect to achieve a nice, distorted effect sound that is usually heard when using an external effect pedal, we use a low pass, 8th order finite impulse response(FIR) filter to clean up some harmonics. The filter's coefficients can be edited in the distortion.sv file.

```systemverilog
/*FIR filter structure bit shifted so that the sound doesn't get amplified too much*/
assign filtered = (3*buff[0] + buff[1] + 4*buff[2] + buff[3] + buff[4] + 6*buff[5] + 7*buff[6] + 4*buff[7] + 6*buff[8]) >> 4;
```

Here the sound is bit shifted by 4, but you can change this value to a different one. The smaller the value, the bigger the gain.

## Known issues
- Gain control needs to be external and more intuitive.
- 7 segment display utilization for displaying the gain multiplier.
- Distortion sound has a couple harsh, unwanted frequency harmonics.
- Working on a way to run multiple effects at once.
## Tools
- [Basys 3 unedited constraints file](https://github.com/Digilent/Basys-3-GPIO/blob/master/src/constraints/Basys3_Master.xdc) - For those who want to customize their own constraints file instead of using the one given in the project.
- [Basys 3 literature](https://digilent.com/reference/programmable-logic/basys-3/start) - Everything you need is under the "Documentation" tab.
- [Pmod I2S2 github page](https://github.com/Digilent/Pmod-I2S2) - In here you can find not only the quick start guide we used, but other useful pieces of documentation relating to the Pmod.
