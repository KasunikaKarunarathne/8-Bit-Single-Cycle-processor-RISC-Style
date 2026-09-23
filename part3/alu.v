module alu (
    input [7:0] DATA1,DATA2,input [2:0] SELECT,output reg [7:0] RESULT
);
wire [7:0] tempResult [3:0];

forwardFunct forwardVal(DATA2,tempResult[0]);
addFunct addVal (DATA1,DATA2,tempResult[1]);
andFunct andVal(DATA1,DATA2,tempResult[2]);
orFunct orVal(DATA1,DATA2,tempResult[3]);


always @(tempResult[0],tempResult[1],tempResult[2],tempResult[3])
 begin
    case (SELECT)
       3'b000 : RESULT=tempResult[0];//FORWARD
       3'b001 : RESULT=tempResult[1];//ADD
       3'b010 : RESULT=tempResult[2];//AND
       3'b011 : RESULT=tempResult[3];//OR
       default: RESULT=8'h00;
    endcase

end
    
endmodule

module forwardFunct (
    input[7:0] DATA2, output[7:0] tempResult
);

     assign #1 tempResult=DATA2; 
endmodule

module addFunct (
    input[7:0] DATA1,DATA2,output[7:0] tempResult
);
assign #2 tempResult=DATA1 + DATA2;   
endmodule

module andFunct (
    input[7:0] DATA1,DATA2, output[7:0] tempResult
);
 assign #1 tempResult=DATA1 & DATA2;   
endmodule

module orFunct (
    input[7:0] DATA1,DATA2,output[7:0] tempResult
);
 assign #1 tempResult=DATA1 | DATA2;   
endmodule