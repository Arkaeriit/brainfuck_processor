# Brainfuck Processor
A processor using Brainfuck as its machine language.

# Implementation

## Main core
The main part of this processor is found in the file brainfuckCore.v. This core can be implemented on any FPGA.

## Rest of the implementation
The other Verilog files are meant to use the processor in a usable computer on an Arty S7-50 board from Diligent. The code is meant to be compiled with Vivado.

## IO
The IO of the board is used to interact with the processor. The serial link is meant to be used ad a 1 Mbaud UART link used to load a brainfuck program or use the `.` or `,` Brainfuck operations. The switch is used to alternate between the loading mode and or running mode. The RGB LED shows the state of the processor. The 4 LEDs show the 4 LSB of the address of the currently executed operation and the buttons btn0 and btn1 are used to restart the currently loaded program and restart the whole implementation, respectively.

## Usage
To use the brainfuck computer you must put the sw0 switch in the up position to enter loading mode. In this case, the RGB LED will be green. Then you enter the brainfuck program through the serial connection. To run the program, flip the switch to the other position, the LED will turn blue while running the code then red when done.

