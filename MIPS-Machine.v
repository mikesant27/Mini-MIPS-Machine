// Michael, Brad, Julio
// Progress Report 4

module reg_file (RR1,RR2,WR,WD,RegWrite,RD1,RD2,clock);
  input [1:0] RR1,RR2,WR;
  input [15:0] WD;
  input RegWrite,clock;
  output [15:0] RD1,RD2;
  reg [15:0] Regs[0:15];
  assign RD1 = Regs[RR1];
  assign RD2 = Regs[RR2];
  initial Regs[0] = 0;
  always @(negedge clock)
    if (RegWrite==1 & WR!=0) 
	Regs[WR] <= WD;
endmodule

// 16-bit MIPS ALU in Verilog using modified template of 4-bit ALU
module ALU (op,a,b,result,zero);
   input  [15:0] a;
   input  [15:0] b;
   input  [3:0] op;
   output [15:0] result;
   output zero;
   wire c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16;
   
   //16 single bit alu's	
   ALU1   alu0  (a[0], b[0], op[3], op[2], op[1:0],set,op[2],c1,result[0]);
   ALU1   alu1  (a[1], b[1], op[3], op[2], op[1:0],1'b0,  c1,   c2,result[1]);
   ALU1   alu2  (a[2], b[2], op[3], op[2], op[1:0],1'b0,  c2,   c3,result[2]);
   ALU1   alu3  (a[3], b[3], op[3], op[2], op[1:0],1'b0,  c3,   c4,result[3]);
   ALU1   alu4  (a[4], b[4], op[3], op[2], op[1:0],1'b0,  c4,   c5,result[4]);
   ALU1   alu5  (a[5], b[5], op[3], op[2], op[1:0],1'b0,  c5,   c6,result[5]);
   ALU1   alu6  (a[6], b[6], op[3], op[2], op[1:0],1'b0,  c6,   c7,result[6]);
   ALU1   alu7  (a[7], b[7], op[3], op[2], op[1:0],1'b0,  c7,   c8,result[7]);
   ALU1   alu8  (a[8], b[8], op[3], op[2], op[1:0],1'b0,  c8,   c9,result[8]);
   ALU1   alu9  (a[9], b[9], op[3], op[2], op[1:0],1'b0,  c9,  c10,result[9]);
   ALU1   alu10 (a[10],b[10],op[3], op[2], op[1:0],1'b0, c10,  c11,result[10]);
   ALU1   alu11 (a[11],b[11],op[3], op[2], op[1:0],1'b0, c11,  c12,result[11]);
   ALU1   alu12 (a[12],b[12],op[3], op[2], op[1:0],1'b0, c12,  c13,result[12]);
   ALU1   alu13 (a[13],b[13],op[3], op[2], op[1:0],1'b0, c13,  c14,result[13]);
   ALU1   alu14 (a[14],b[14],op[3], op[2], op[1:0],1'b0, c14,  c15,result[14]);
   ALUmsb alu15 (a[15],b[15],op[3], op[2], op[1:0],1'b0, c15,  c16,result[15],set);

   nor nor1(zero,result [15:0]);
endmodule

// 1-bit ALU for bits 0-14
module ALU1 (a,b,ainvert,binvert,op,less,carryin,carryout,result);
   input a,b,less,carryin,ainvert, binvert;
   input [1:0] op;
   output carryout,result;
   wire sum, a_and_b, a_or_b, b_inv, a_inv;
	
   // Choose if we use a or a invert
   not not1(a_inv, a);
   mux2x1 mux1(a,a_inv,ainvert,a1);

   // Chose if we use b or b invert
   not not2(b_inv, b);
   mux2x1 mux2(b,b_inv,binvert,b1);
   
   and and1(a_and_b, a1, b1);
   or or1(a_or_b, a1, b1);
   
   fulladder adder1(sum,carryout,a1,b1,carryin);
   
   mux4x1 mux3(a_and_b,a_or_b,sum,less,op[1:0],result); 
endmodule

// 1-bit ALU for smb
module ALUmsb (a,b,ainvert, binvert,op,less,carryin,carryout,result,sum);
   input a,b,less,carryin,ainvert,binvert;
   input [1:0] op;
   output carryout,result,sum;
   wire sum, a_and_b, a_or_b, b_inv, a_inv;

   // Choose if we use a or a invert
   not not1(a_inv, a);
   mux2x1 mux1(a,a_inv,ainvert,a1);
	
   // Choose if we use b or b invert
   not not2(b_inv, b);
   mux2x1 mux2(b,b_inv,binvert,b1);
   
   and and1(a_and_b, a1, b1);
   or or1(a_or_b, a1, b1);
   fulladder adder1(sum,carryout,a1,b1,carryin);
   mux4x1 mux3(a_and_b,a_or_b,sum,less,op[1:0],result); 
   
endmodule

// Adders
module halfadder (S,carryOut,A,B); 
   input A,B; 
   output S,carryOut; 

   xor (S,A,B); 
   and (carryOut,A,B); 
endmodule

module fulladder (S,carryOut,A,B,carryIn); 
   input A,B,carryIn; 
   output S,carryOut; 
   wire S1,D1,D2;

   halfadder HA1 (S1,D1,A,B), 
             HA2 (S,D2,S1,carryIn); 
   or g1(carryOut,D2,D1); 
endmodule

// Multiplexors

// 16-bit 4x1 Mux
module mux16bit(a, b, c, d, select, OUT);
  input  [15:0] a, b, c, d;
  input  [1:0] select;
  output [15:0] OUT;

  //16 4x1 mux
  mux4x1 mux0(a[0],  b[0],  c[0],  d[0], select,  OUT[0]);
  mux4x1 mux1(a[1],  b[1],  c[1],  d[1], select,  OUT[1]);
  mux4x1 mux2(a[2],  b[2],  c[2],  d[2], select,  OUT[2]);
  mux4x1 mux3(a[3],  b[3],  c[3],  d[3], select,  OUT[3]);
  mux4x1 mux4(a[4],  b[4],  c[4],  d[4], select,  OUT[4]);
  mux4x1 mux5(a[5],  b[5],  c[5],  d[5], select,  OUT[5]);
  mux4x1 mux6(a[6],  b[6],  c[6],  d[6], select,  OUT[6]);
  mux4x1 mux7(a[7],  b[7],  c[7],  d[7], select,  OUT[7]);
  mux4x1 mux8(a[8],  b[8],  c[8],  d[8], select,  OUT[8]);
  mux4x1 mux9(a[9],  b[9],  c[9],  d[9], select,  OUT[9]);
  mux4x1 mux10(a[10], b[10], c[10], d[10], select, OUT[10]);
  mux4x1 mux11(a[11], b[11], c[11], d[11], select, OUT[11]);
  mux4x1 mux12(a[12], b[12], c[12], d[12], select, OUT[12]);
  mux4x1 mux13(a[13], b[13], c[13], d[13], select, OUT[13]);
  mux4x1 mux14(a[14], b[14], c[14], d[14], select, OUT[14]);
  mux4x1 mux15(a[15], b[15], c[15], d[15], select, OUT[15]);
endmodule

// 1-bit 4x1 Mux
module mux4x1(a,b,c,d,select,OUT); 
  input a,b,c,d; 
  input [1:0] select; 
  output OUT;
  
  mux2x1 mux1(a, b, select[0], m1);
  mux2x1 mux2(c, d, select[0], m2);
  mux2x1 mux3(m1, m2, select[1], OUT);
endmodule

// 16-bit 2x1 Mux
// Rewritten For Extra Work to use 8 2-bit 2x1 Mux's instead of 16 1-bit 2x1 Mux's
module mux2x1_16bit(A, B, select, OUT);
	input [15:0] A,B;
    input select;
	output [15:0] OUT;
	//8 2-bit 2x1 mux's
	mux2x1_2bit mux1(A[1:0],B[1:0],select,OUT[1:0]);
	mux2x1_2bit mux2(A[3:2],B[3:2],select,OUT[3:2]);
	mux2x1_2bit mux3(A[5:4],B[5:4],select,OUT[5:4]);
	mux2x1_2bit mux4(A[7:6],B[7:6],select,OUT[7:6]);
	mux2x1_2bit mux5(A[9:8],B[9:8],select,OUT[9:8]);
	mux2x1_2bit mux6(A[11:10],B[11:10],select,OUT[11:10]);
	mux2x1_2bit mux7(A[13:12],B[13:12],select,OUT[13:12]);
	mux2x1_2bit mux8(A[15:14],B[15:14],select,OUT[15:14]);
endmodule

// 2-bit 2x1 Mux
module mux2x1_2bit(A,B,select,OUT);
	input [1:0] A,B;
    input select;
	output [1:0] OUT;
	//2 2x1 muxs
    mux2x1 mux1(A[0], B[0], select, OUT[0]),
           mux2(A[1], B[1], select, OUT[1]);
endmodule

// 1-bit 2x1 Mux
module mux2x1(A,B,select,OUT); 
  input A,B,select; 
  output OUT;

  not not1(i0, select);
  and and1(i1, A, i0);
  and and2(i2, B, select);
  or or1(OUT, i1, i2);
endmodule

module MainControl (Op,Control); 
  input [3:0] Op;
  output reg [10:0] Control;
// RegDst,ALUSrc,MemtoReg,RegWrite,MemWrite,Beq,Bne,ALUOp;
  always @(Op) case (Op)
    4'b0000: Control <= 11'b10010_00_0010; // ADD last 2 is for branching
    4'b0001: Control <= 11'b10010_00_0110; // SUB
    4'b0010: Control <= 11'b10010_00_0000; // AND 
    4'b0011: Control <= 11'b10010_00_0001; // OR 
    4'b0100: Control <= 11'b10010_00_1101; // NOR
    4'b0101: Control <= 11'b10010_00_1100; // NAND 
    4'b0110: Control <= 11'b10010_00_0111; // SLT
    4'b0111: Control <= 11'b01010_00_0010; // ADDI   
    4'b1000: Control <= 11'b01110_00_0010; // LW    
    4'b1001: Control <= 11'b01001_00_0010; // SW    
    4'b1010: Control <= 11'b00000_10_0110; // BEQ   
    4'b1011: Control <= 11'b00000_01_0110; // Bne
  endcase
endmodule

module CPU (clock,PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD);
  input clock;
  output [15:0] PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD;

  initial begin 
// Program: swap memory cells (if needed) and compute absolute value |5-7|=2
    IMemory[0] = 16'b1000_00_01_00000000;  // lw $t1, 0($0) 
    IMemory[1] = 16'b1000_00_10_00000010;  // lw $t2, 2($0)
    IMemory[2]= 16'b0000000000000000; //nop
    IMemory[3]= 16'b0000000000000000; //nop
    IMemory[4]= 16'b0000000000000000; //nop
    IMemory[5] = 16'b0110_01_10_11_000000; // slt $t3, $t1, $t2
    IMemory[6]= 16'b0000000000000000; //nop
    IMemory[7]= 16'b0000000000000000; //nop
    IMemory[8]= 16'b0000000000000000; //nop
    IMemory[9] = 16'b1010_11_00_00000110;  // beq $t3, $0, IMemory[15]
    IMemory[10]= 16'b0000000000000000; //nop 
    IMemory[11]= 16'b0000000000000000; //nop
    IMemory[12]= 16'b0000000000000000; //nop
    IMemory[13] = 16'b1001_00_01_00000010;    // sw $t1, 2($0) 
    IMemory[14] = 16'b1001_00_10_00000000;    // sw $t2, 0($0) 
    IMemory[15]= 16'b0000000000000000; //nop
    IMemory[16]= 16'b0000000000000000;//nop
    IMemory[17]= 16'b0000000000000000; //nop
    IMemory[18] = 16'b1000_00_01_00000000;    // lw $t1, 0($0) 
    IMemory[19] = 16'b1000_00_10_00000010;    // lw $t2, 4($0) 
    IMemory[20]= 16'b0000000000000000; //nop
    IMemory[21]= 16'b0000000000000000; //nop
    IMemory[22]= 16'b0000000000000000; //nop
    IMemory[23] = 16'b0100_10_10_10_000000;   // nor $t2, $t2, $t2 (it invert all bits) 
    IMemory[24]= 16'b0000000000000000; //nop
    IMemory[25]= 16'b0000000000000000; //nop
    IMemory[26]= 16'b0000000000000000; //nop
    IMemory[27] = 16'b0111_10_10_00000001;     // addi $t2, $t2, 1 
    IMemory[28]= 16'b0000000000000000; //nop
    IMemory[29]= 16'b0000000000000000; //nop
    IMemory[30]= 16'b0000000000000000; //nop
    IMemory[31] =16'b0000_01_10_11_000000;   // add $t3, $t1, $t2
 
 
// Data
   DMemory[0] = 5; // switch the cells and see how the simulation output changes
   DMemory[1] = 7; // (beq is taken if DMemory[0]=7; DMemory[1]=5, not taken otherwise)

  end

// Pipeline 
// IF 
   wire [15:0] PCplus4, NextPC;
   reg[15:0] PC, IMemory[0:1023], IFID_IR, IFID_PCplus4;
   ALU fetch (4'b0010,PC,16'd2,PCplus4,Unused1);
   mux2x1_16bit m1 (PCplus4,EXMEM_Target, (EXMEM_Beq && EXMEM_Zero || EXMEM_Bne && ~EXMEM_Zero ),NextPC);
// ID
   wire [10:0] Control;
   reg IDEX_RegWrite,IDEX_MemtoReg,
       IDEX_Beq, IDEX_Bne,  IDEX_MemWrite,
       IDEX_ALUSrc,  IDEX_RegDst;
   reg [3:0]  IDEX_ALUOp;
   wire [15:0] RD1,RD2,SignExtend, WD;
   reg [15:0] IDEX_PCplus4,IDEX_RD1,IDEX_RD2,IDEX_SignExt,IDEXE_IR;
   reg [15:0] IDEX_IR; // For monitoring the pipeline
   reg [1:0]  IDEX_rt,IDEX_rd;
   reg MEMWB_RegWrite; // part of MEM stage, but declared here before use (to avoid error)
   reg [1:0] MEMWB_rd; // part of MEM stage, but declared here before use (to avoid error)
   reg_file rf (IFID_IR[11:10],IFID_IR[9:8],MEMWB_rd,WD,MEMWB_RegWrite,RD1,RD2,clock);
   MainControl MainCtr (IFID_IR[15:12],Control); 
   assign SignExtend = {{8{IFID_IR[7]}},IFID_IR[7:0]}; 
// EXE
   reg EXMEM_RegWrite,EXMEM_MemtoReg,
       EXMEM_Beq, EXMEM_Bne,  EXMEM_MemWrite;
   wire [15:0] Target;
   reg EXMEM_Zero;
   reg [15:0] EXMEM_Target,EXMEM_ALUOut,EXMEM_RD2;
   reg [15:0] EXMEM_IR; // For monitoring the pipeline
   reg [1:0] EXMEM_rd;
   wire [15:0] B,ALUOut;
   
   wire [1:0] WR;
   ALU branch (4'b0010,IDEX_SignExt<<2,IDEX_PCplus4,Target,Unused2);
   ALU ex (IDEX_ALUOp, IDEX_RD1, B, ALUOut, Zero);
   
   mux2x1_16bit m2 (IDEX_RD2,IDEX_SignExt,IDEX_ALUSrc,B);        // ALUSrc Mux 
   mux2x1_2bit m3 (IDEX_rt,IDEX_rd,IDEX_RegDst,WR);              // RegDst Mux
// MEM
   reg MEMWB_MemtoReg;
   reg [15:0] DMemory[0:1023],MEMWB_MemOut,MEMWB_ALUOut;
   reg [15:0] MEMWB_IR; // For monitoring the pipeline
   wire [15:0] MemOut;
   assign MemOut = DMemory[EXMEM_ALUOut>>1];
   always @(negedge clock) if (EXMEM_MemWrite) DMemory[EXMEM_ALUOut>>1] <= EXMEM_RD2;
// WB
   mux2x1_16bit m4 (MEMWB_ALUOut,MEMWB_MemOut,MEMWB_MemtoReg,WD); // MemtoReg Mux

   initial begin
    PC = 0;
// Initialize pipeline registers
    IDEX_RegWrite=0;IDEX_MemtoReg=0;IDEX_Beq=0;IDEX_Bne=0;IDEX_MemWrite=0;IDEX_ALUSrc=0;IDEX_RegDst=0;IDEX_ALUOp=0;
    IFID_IR=0;
    EXMEM_RegWrite=0;EXMEM_MemtoReg=0;EXMEM_Beq=0;EXMEM_Bne=0;EXMEM_MemWrite=0;
    EXMEM_Target=0;
    MEMWB_RegWrite=0;MEMWB_MemtoReg=0;
   end

// Running the pipeline
   always @(negedge clock) begin 
// IF
    PC <= NextPC;
    IFID_PCplus4 <= PCplus4;
    IFID_IR <= IMemory[PC>>1];
// ID
    IDEX_IR <= IFID_IR; // For monitoring the pipeline
    {IDEX_RegDst,IDEX_ALUSrc,IDEX_MemtoReg,IDEX_RegWrite,IDEX_MemWrite,IDEX_Beq,IDEX_Bne,IDEX_ALUOp} <= Control;   
    IDEX_PCplus4 <= IFID_PCplus4;
    IDEX_RD1 <= RD1; 
    IDEX_RD2 <= RD2;
    IDEX_SignExt <= SignExtend;
    IDEX_rt <= IFID_IR[9:8];
    IDEX_rd <= IFID_IR[7:6];
// EXE
    EXMEM_IR <= IDEX_IR; // For monitoring the pipeline
    EXMEM_RegWrite <= IDEX_RegWrite;
    EXMEM_MemtoReg <= IDEX_MemtoReg;
    EXMEM_Beq      <= IDEX_Beq;
    EXMEM_Bne      <= IDEX_Bne;
    EXMEM_MemWrite <= IDEX_MemWrite;
    EXMEM_Target <= Target;
    EXMEM_Zero <= Zero;
    EXMEM_ALUOut <= ALUOut;
    EXMEM_RD2 <= IDEX_RD2;
    EXMEM_rd <= WR;
// MEM
    MEMWB_IR <= EXMEM_IR; // For monitoring the pipeline
    MEMWB_RegWrite <= EXMEM_RegWrite;
    MEMWB_MemtoReg <= EXMEM_MemtoReg;
    MEMWB_MemOut <= MemOut;
    MEMWB_ALUOut <= EXMEM_ALUOut;
    MEMWB_rd <= EXMEM_rd;
// WB
// Register write happens on neg edge of the clock (if MEMWB_RegWrite is asserted)
  end
endmodule

// Test module
module test ();
  reg clock;
  wire signed [15:0] PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD;
  CPU test_cpu(clock,PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD);
  always #1 clock = ~clock;
  initial begin
    $display ("PC   IFID_IR          IDEX_IR          EXMEM_IR         MEMWB_IR          WD");
    $monitor ("%3d  %b %b %b %b %2d",PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD);
    clock = 1;
    #69 $finish;
  end
endmodule
