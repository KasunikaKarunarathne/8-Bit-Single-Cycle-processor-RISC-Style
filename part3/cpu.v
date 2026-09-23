`include "alu.v"
`include "registerFile.v"

module cpu (
    output [31:0] PC,//ADDRESS OF INSTRUCTION
    input [31:0] INSTRUCTION,//INSTRUCTION ARRAY
    input CLK,RESET//TO RESET PC AND CLK TO GIVE PC SEQUENTIALLY
    
  
);
    wire [7:0] OPCODE/*BITS[31-24]*/,RD/*BITS[23-16]*/,RT/*BITS[15-8]*/,RS_IMM/*BITS[15-8]*/;
    //SPLITTING INSTRUCTON TO DIFFFRENT CHANNELS
    assign OPCODE=INSTRUCTION[31:24];
    assign  RD=INSTRUCTION[23:16];
    assign RT=INSTRUCTION[15:8];
    assign RS_IMM=INSTRUCTION[7:0];//2ND VALUE AND IMMEDIATE VALUE

    //DEFINIG OPCODE OUTPUTS AND INPUTS
    wire WRITEENABLE,MUX1SELECT,MUX2SELECT;//1 BIT CONTROLLERS
    wire [2:0] ALUOP;

    //INITIALIZING PC ADDER IN CONTROL UNIT
    pc_adder add_pc(RESET,CLK,PC);
    

    //CONNECTING CONTROL UNIT 
    control_unit cpu_control(OPCODE,ALUOP,MUX1SELECT,MUX2SELECT,WRITEENABLE);
 

    //DEFINING REGISTERFILE OUTPUTS AND INPUTS
    wire [2:0] READREG1/*RT*/,READREG2/*RS*/,WRITEREG/*RD*/;
    wire [7:0] ALURESULT /*FINAL RESULT THAT COMES TO STORE IN WRITEREG*/,REGOUT1/*VALUE OF ADDRESS READREG1*/,REGOUT2;/*VALUE OF ADDRESS READREG2*/

    //ASSIGNIGNG VALUES FROM THE SPLITTED OUTPUT TO REGISTER INPUTS(BECAUSE INSTRUCTION OUTPUT HAS LARGER ADDRESS BUT REGISTERGILE HAVE ONLY 8 REGISTERS)

    assign READREG1=RT[2:0];
    assign READREG2=RS_IMM[2:0];//2ND VALUE
    assign WRITEREG=RD[2:0];//FOR WRITE 
    
    //CONNECTING REGFILE TO THE ASSIGNED INPUTS AND OUTPUTS
    reg_file reg_8x8(ALURESULT,REGOUT1,REGOUT2,WRITEREG,READREG1,READREG2,WRITEENABLE,CLK,RESET);
   

    //assigning input and output values to 2SCOMP
    wire [7:0] REGOUT2_2SCOMP;
    twoScomp complement(REGOUT2_2SCOMP,REGOUT2);

    //ASSIGNING INPUT AND OUTPUT VALUES TO MUX1 AND MUX2
    wire [7:0] MUX1OUT,MUX2OUT;
    //CONECTIING  MUX1TO THE CIRCUIT
    assign MUX1OUT=MUX1SELECT?REGOUT2_2SCOMP:REGOUT2;
    //CONNECTING MUX2 TO OUTPUT
    assign MUX2OUT=MUX2SELECT?MUX1OUT:RS_IMM;

    //FOR ALU ALL THE OUTPUT AND INPUTS ARE DEFINED ALREADY NO NEED T DEFINE INPUTS AND OUTPUTS TO ALU
    alu alu_cpu(REGOUT1,MUX2OUT,ALUOP,ALURESULT);
    
endmodule

//control_unit
module control_unit (
    input [7:0] OPCODE,
    output reg [2:0]ALUOP,
    output reg MUX1SELECT,MUX2SELECT,WRITEENABLE
);
always @(OPCODE) begin
    case (OPCODE)
        8'b00000010:begin
            ALUOP<=#1 3'b001; //TO ADD
            MUX1SELECT<=#1 0; //SELECT POSITIVE VALUE
            MUX2SELECT<=#1 1; //SELECT REGISTER VALUE
            WRITEENABLE<=#1 1; //ENABLE REGISTER WRITE
        end
        8'b00000011:begin
            ALUOP<=#1 3'b001; //TO ADD
            MUX1SELECT<=#0 0; //SELECT NEGATIVE VALE (TO SUBSTRACT)
            MUX2SELECT<=#1 1; //SELECT REGISTER VALUE 
            WRITEENABLE<=#1 1; //ENABLE REGISTER FILE TO WRITE
        end
        8'b00000100:begin
            ALUOP<=#1 3'b010; //TO AND
            MUX1SELECT<=#0 0; //SELECT POSITIVE VALUE
            MUX2SELECT<=#1 1; //SELECT REGISTER VALUE 
            WRITEENABLE<=#1 1; //ENABLE REGISTER FILE TO WRITE
        end
        8'b00000101:begin
            ALUOP<=#1 3'b011; //TO OR
            MUX1SELECT<=#0 0; //SELECT POSITIVE VALUE
            MUX2SELECT<=#1 1; //SELECT REGISTER VALUE 
            WRITEENABLE<=#1 1; //ENABLE REGISTER FILE TO WRITE
        end
        8'b00000001:begin
            ALUOP<=#1 3'b000; //TO TO FORWARD(MOV)
            MUX1SELECT<=#0 0; //SELECT POSITIVE VALUE
            MUX2SELECT<=#1 1; //SELECT register VALUE 
            WRITEENABLE<=#1 1; //ENABLE REGISTER FILE TO WRITE
        end
        8'b00000000:begin
            ALUOP<=#1 3'b000; //TO loadi
            MUX1SELECT<=#0 0; //SELECT POSITIVE VALUE
            MUX2SELECT<=#1 0; //SELECT immediate VALUE 
            WRITEENABLE<=#1 1; //ENABLE REGISTER FILE TO WRITE
        end
        
    endcase
end
    
endmodule



//DEFININF THE INNER PART OF THE PC ADDER
module pc_adder (
    
    input RESET,
    input CLK ,
    output reg  [31:0]PC
);
   // reg [31:0]tempPC;

    always @(posedge CLK) begin
        
        if(RESET)begin
            PC<= #1 0;//if reset is high assgn pc to zero
            //tempPC<=#1 0;
        end
        else begin
            // PC<=#1 tempPC;//EVERY TIME THAT RESET IS NOT HIGH INCREMENT PC AT THE POSEAGE OF CLK
           PC<= #1 PC + 4;
        end
           
    end
    // always @(PC) begin
    //     #1 tempPC=tempPC+4;
    // end
        
    
endmodule
//DEFINING THE CIRCUIT OF TWOSCOMPLEMENT PART
module twoScomp (
    output reg signed [7:0]REGOUT2_2SCOMP,
    input [7:0]REGOUT2
);

//GET THE COMPLEMENT OF THE VALUE
always @(REGOUT2) begin
    #1 REGOUT2_2SCOMP=  ~REGOUT2+1;
end
     
endmodule

//issues
//loadi is not written in alu
//regwrite time not scheduled properly
//default is not settled