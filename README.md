# Mini-MIPS-Machine
Design a simplified version of a MIPS machine and wrote a Verilog program that describes its structure and simulates its functioning. Used gate-level modeling for all components unless otherwise specified. 

## Instruction Set:
| Instruction | OPCode |
| :---------: | :----: |
|     add     |  0000  |
## Project Structure:
This project was broken down into 4 Progress Reports, with each Progress Report building off the last, with Progress Report 4 containing our finished MIPS Machine in Verilog

Progrss Reports 1 & 2 focused on the single-cycle datapath, while Progress Report 3 & 4 focused on a 3-stage pipelined datapath.

### Progress Report 1
Using the architecture and the instruction format for the 16-bit CPU described in the semester project design and implement a simpilfied single-cycle datapath capable of executing all R-type and immediate arithmetic instructions (add, sub, and, or, nor, nand, slt, addi). Major components: Instruction memory, ALU, and Register File. Use template files: ALU4-mixed.vl (rewrite it at gate-level and extend it to 16 bit), mips-regfile.vl (adjust the number and size of the registers). Use also the behavioral implementation mips-r-type_addi.vl and make the necessary changes/additions. For testing use the test program, which is part of mips-r-type_addi.txt recompiled for the project 16-bit architecture and follow the requirements given in section "Testing".

### Progress Report 2
Complete single-cycle datapath. Implement all instructions and run a complete test program as explained in section "Testing". Use the behavioral implementation mips-simple.vl, and make the necessary changes/additions. For testing use the test program from mips-simple.vl recompiled for the project 16-bit architecture and extended with the bne instruction and run it with different data to simulate both branch decisions (taken and not taken). Show the PC in the simulation output.

### Progress Report 3
Using the architecture and the instruction format for the 16-bit CPU described in the Semester Project design and implement a 3-stage pipelined datapath capable of executing all R-type and immediate arithmetic instructions (add, sub, and, or, nor, nand, slt, addi). The stages are IF, ID and a third stage combining EX, MEM and WB stages of the 5-stage standard MIPS pipeline. Use the standard MIPS 3-stage datapath diagram mips-pipe3.png and the behavioral model mips-pipe3.vl and make the necessary changes/additions. For testing use the test program from mips-pipe3.vl and recompile it for the project 16-bit architecture. The test results should include simulations with and without nop's that demonstarte the pipeline hazards. The simulation output should show the PC and the instruction in each pipeline stage.

### Progress Report 4
Implement the final version of the complete (5-stage) pipelined datapath. Use the pipeline diagram MIPS-16-Pipeline.pdf, and the behavioural model mips-pipe.txt, and make the necessary changes according to the specifications of the Semester Project. Write a general description of the machine and short description of each major component, include the Verilog code with comments and results from running the Verilog program simulating the MIPS test program (see the "Testing" section in Semester Project).
