`include "utility.v"
`include "simple_ram.v"

//Address (32-bit):
//	TAG INDEX WORD_SELECT 00
module cache #(
	parameter WORD_SELECT_BIT = 3, //block size: 2^3 * 4 = 32 bytes
	parameter INDEX_BIT       = 2, //block count: 2^2 = 4
	parameter NASSOC          = 4
) (
	input             clk           ,
	input             rst           ,
	//from cpu core
	input      [ 1:0] rw_flag_in      , //[0] for read, [1] for write
	input      [31:0] addr_in         ,
	output     [31:0] read_data     ,
	input      [31:0] write_data_in   ,
	input      [ 3:0] write_mask_in   ,
	output reg        busy          ,
	output reg        done          ,
	input             flush_flag    ,
	input      [31:0] flush_addr    ,
	//to memory
	output reg [ 1:0] mem_rw_flag   ,
	output reg [31:0] mem_addr      ,
	input      [31:0] mem_read_data ,
	output reg [31:0] mem_write_data,
	output reg [ 3:0] mem_write_mask,
	input             mem_busy      ,
	input             mem_done
);

localparam TAG_BIT = 32-WORD_SELECT_BIT-INDEX_BIT-2;	// 每个块存储的tag值
localparam BYTE_SELECT_BIT = WORD_SELECT_BIT + 2;
reg [TAG_BIT-1:0] 		 tag[NASSOC-1:0][NBLOCK-1:0]; // 标记位
reg 					 valid[NASSOC-1:0][NBLOCK-1:0];             // 有效位
reg [SET_SELECT_BIT-1:0] recuse[NASSOC-1:0][NBLOCK-1:0]; // LRU 计数器
reg [SET_SELECT_BIT-1:0] recent_use_counter[NBLOCK-1:0]; // 记录最近使用情况




reg [1:0]	pending_rw_flag;
reg [31:0]	pending_addr;
reg [31:0]	pending_write_data;
reg [3:0]	pending_write_mask;
always @(posedge clk or posedge rst) begin
	if (rst) begin
		pending_rw_flag		<= 1'b0;
		pending_addr		<= 32'b0;
		pending_write_data	<= 32'b0;
		pending_write_mask	<= 4'b0;
	end else if (busy) begin	// 状态机
		if (next_done)		busy <= 1'b0;
		else 				busy <= busy;
	end else begin // ~busy
		if (!next_done && rw_flag_!=2'b0) begin  //[0] for read, [1] for write
			busy				<= 1'b1;
			pending_rw_flag		<= rw_flag_in;
			pending_addr		<= addr_in;
			pending_write_data	<= write_data_in;
			pending_write_mask  <= write_mask_in;
		end
		// else lock state
	end

end
wire [1:0]	rw_flag			= busy ? pending_rw_flag	: rw_flag_in;
wire [31:0]	addr			= busy ? pending_addr		: addr_in;
wire [31:0]	write_data_in	= busy ? pending_write_data : write_data_in;
wire [3:0]	write_mask_in	= busy ? pending_write_mask : write_mask_in;
	wire [TAG_BIT-1:0] 			addr_tag 	= addr[31:31-TAG_BIT+1];
	wire [INDEX_BIT-1:0]		addr_index	= addr[BYTE_SELECT_BIT+INDEX_BIT-1:BYTE_SELECT_BIT];
	wire [WORD_SELECT_BIT-1:0]	addr_ws		= addr[WORD_SELECT_BIT+2-1:2];

genvar i, j, k;
generate
	for(i=0; i<NASSOC; i=i+1) begin
		wire RAM_read_flag  = (read_cache==i);
		wire RAM_write_flag = (write_cache==i);
		// simple ram 
	end
endgenerate

// LRU 的计数器
always @(posedge clk or posedge rst) begin
	if (rst) begin
		done <= 1'b0;
		for(i=0; i<NASSOC; i=i+1)
		for(j=0; j<NBLOCK; j=j+1) begin
			rescue[i][j]	<= 1'b0;
			valid[i][j]		<= 1'b0;
		end
		for(j=0; j<NBLOCK; j=j+1) 
			recent_use_counter[j] <= 1'b0;
		state		<= STATE_IDLE;
		////// 203
	end else begin
		if (!read_cache[SET_])




reg [TAG_BIT-1:0]			tag[NASSOC-1:0][NBLOCK-1:0];
reg 						valid[NASSOC-1:0][NBLOCK-1:0];
reg [SET_SELECT_BIT-1:0]	recuse[NASSOC-1:0][NBLOCK-1:0];
generate
	for(i=0; i<NASSOC; i=i+1) begin
		assign found_in_cache[i]		= valid[i][addr_index]
	end


endgenerate

endmodule