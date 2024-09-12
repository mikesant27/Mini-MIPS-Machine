# Mini-MIPS-Machine
Design a simplified version of a MIPS machine and wrote a Verilog program that describes its structure and simulates its functioning. Used gate-level modeling for all components unless otherwise specified. 

## Project Structure:
This project was broken down into 4 Progress Reports, with each Progress Report building off the last, with Progress Report 4 containing our finished MIPS Machine in Verilog

### Progress Report 1
Using the architecture and the instruction format for the 16-bit CPU described in the semester project design and implement a simpilfied single-cycle datapath capable of executing all R-type and immediate arithmetic instructions (add, sub, and, or, nor, nand, slt, addi). Major components: Instruction memory, ALU, and Register File. Use template files: ALU4-mixed.vl (rewrite it at gate-level and extend it to 16 bit), mips-regfile.vl (adjust the number and size of the registers). Use also the behavioral implementation mips-r-type_addi.vl and make the necessary changes/additions. For testing use the test program, which is part of mips-r-type_addi.txt recompiled for the project 16-bit architecture and follow the requirements given in section "Testing".

### Progress Report 2
