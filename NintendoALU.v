module NintendoALU(
	 input wire reset,
    input wire mode,
    inout wire [7:0] data,
	 output wire [2:0] opcode,
    input wire addr0,
    input wire addr1
    );
	 
reg [7:0] fifo [1:0];
reg [2:0] shift;

/* Load shift storage or FIFO based on address */
always @ (posedge addr0)
begin
        shift <= data;
end

always @ (posedge addr1)
begin
        fifo[0] <= fifo[1];
        fifo[1] <= data;
end


/* Assign protection result and drive out to the data bus or tristate*/
assign data = (~mode && reset) ? ((fifo[1] << shift) | (fifo[0] >> (8-shift))): 8'bz;

/* Drive out 0x0 onto 'opcode' bus permenantly. Its output to the rest of the PCB is controlled via an external LS367 */
assign opcode = 3'b0;

endmodule 