`timescale 1 ns / 1 ps

module ball_pos_ctrl(
	input wire rst,
	input wire clk,
	input wire pl1_col,
	input wire pl2_col,
	input wire net_col,
	input wire [11:0] pl1_posx,
	input wire [11:0] pl1_posy,
	input wire [11:0] pl2_posx,
	input wire [11:0] pl2_posy,
	output wire gnd_col,
	output reg ovr_touch,
	output wire [11:0] ball_posx_out,
	output wire [11:0] ball_posy_out	
);

reg [7:0] timer, timer_nxt;
wire timer_done;

wire clk100Hz;

clk_divider #(.FREQ(100), .SRC_FREQ(65_000_000)) my_clk_divider(
	.clk_in(clk),
	.rst(rst),
	.clk_div(clk100Hz)
);

//rst delay for clk100Hz
reg rst_d, rst_d_nxt;
always @(posedge clk) begin
	if(rst) rst_d = 1;
	else rst_d = rst_d_nxt;
end

always @* begin
	if(clk100Hz) rst_d_nxt = 0;
	else rst_d_nxt = rst_d;
end

//ball position

reg [11:-7] ball_posx, ball_posy, ball_posx_nxt, ball_posy_nxt;

assign ball_posx_out = ball_posx[11:0];
assign ball_posy_out = ball_posy[11:0];


localparam 	PL_CENTER_POSX = 38,
			PL_CENTER_POSY = 45,
			BALL_CENTER_POS = 32;

reg [0:-7] vel_x, vel_x_nxt, vel_y, vel_y_nxt;

//reg move_x; // {sign 'bx . 'bx}

reg last_touch, last_touch_nxt;

localparam	PLAYER1 = 1'b0,
			PLAYER2 = 1'b1;
			
localparam	BALL_SIZE = 64;
			
localparam	START_POSX_PL1 	= 12'd250,
			START_POSX_PL2 	= 12'd774,
			START_POSY 		= 12'd255;


localparam 	HANG = 4'b0001,
			BOUNCE = 4'b0010,
			FLIGHT = 4'b0100,
			WAIT = 4'b1000;

wire wall_col;

reg [3:0] ball_state, ball_state_nxt;
			
always @(posedge clk100Hz) begin
	if(rst_d) ball_state <= HANG;
	else ball_state <= ball_state_nxt;
end
	
always @* begin
	case(ball_state)
		HANG: begin
			if(pl1_col || pl2_col || wall_col) ball_state_nxt=BOUNCE;
			else ball_state_nxt=HANG;
		end
		BOUNCE: if(ovr_touch) ball_state_nxt=WAIT;
				else ball_state_nxt=FLIGHT;
		FLIGHT: begin
			if(pl1_col | pl2_col | wall_col | net_col) ball_state_nxt=BOUNCE;
			else if(gnd_col) ball_state_nxt=WAIT;
			else ball_state_nxt=FLIGHT;
		end
		WAIT: begin
			if(timer_done) ball_state_nxt=HANG;
			else ball_state_nxt=WAIT;
		end
		default: ball_state_nxt=ball_state;
	endcase
end

//checking collisions with objects
assign wall_col = ((ball_posx[11:0] <= 0) || (ball_posx[11:0] >= 1023 - BALL_SIZE)) ? 1'b1 : 1'b0;
assign gnd_col = (ball_posy[11:0] ==(767 - BALL_SIZE)) ? 1'b1 : 1'b0;

//ball move
always @(posedge clk100Hz) begin
	if(rst) ball_posx = START_POSX_PL1;
	else ball_posx = ball_posx_nxt;
end

always @(posedge clk100Hz) begin
	if(rst_d) ball_posy = START_POSY;
	else ball_posy = ball_posy_nxt;
end

always @* begin
	case(ball_state)
		HANG: begin
			ball_posx_nxt = {(last_touch==PLAYER1) ?  START_POSX_PL1 : START_POSX_PL2, 7'b0};
			ball_posy_nxt = {START_POSY, 7'b0};
		end
		FLIGHT: begin
			ball_posx_nxt = ball_posx + {(vel_x[0] ? 11'hFFF : 10'b0), vel_x};
			ball_posy_nxt = ball_posy + ~{(vel_y[0] ? 11'hFFF : 10'b0), vel_y} + 1;
		end
		default: begin
			ball_posx_nxt = ball_posx;
			ball_posy_nxt = ball_posy;
		end
	endcase
end

always @(posedge clk100Hz) begin
	if(rst_d) begin
		vel_x = 0;
		vel_y = 0;
	end
	else begin
		vel_x = vel_x_nxt;
		vel_y = vel_y_nxt;
	end
end

always @* begin
	case(ball_state)
		BOUNCE: begin
			//if(pl1_col) begin
				vel_x_nxt = (~(pl1_posx) + ball_posx[11:0] + (BALL_CENTER_POS + 1 - PL_CENTER_POSX));
				vel_y_nxt = (pl1_posy + (ball_posy[11:0]) + (PL_CENTER_POSY - BALL_CENTER_POS));
			//end
			/*else if(pl2_col) begin
				vel_x_nxt = (~(pl2_posx) + ball_posx[11:0] + (BALL_CENTER_POS + 1 - PL_CENTER_POSX));
				vel_y_nxt = (pl2_posy + (ball_posy[11:0]) + (PL_CENTER_POSY - BALL_CENTER_POS));
			end
			else begin
				vel_x_nxt = ~vel_x + 1;
				vel_y_nxt = vel_y;
			end*/
		end
		FLIGHT: begin
			vel_x_nxt = vel_x;
			if(vel_y==8'h80)  vel_y_nxt = vel_y;
			else vel_y_nxt = vel_y - 1;
		end
		default: begin
			vel_x_nxt = 0;
			vel_y_nxt = 0;
		end
	endcase
end

//WAIT time counter

always @(posedge clk100Hz) begin
	if(rst_d) timer = 0;
	else timer = timer_nxt;
end

always @* begin
	case(ball_state)
		WAIT: begin
			timer_nxt = timer + 1;
		end
		default: begin
			timer_nxt = 0;
		end
	endcase
end

assign timer_done = (timer==8'd250);

always @(posedge clk100Hz) begin
	if(rst_d) last_touch = PLAYER1;
	else last_touch = last_touch_nxt;
end

always @* begin
	case(ball_state)
		BOUNCE: begin
			if(pl1_col)	last_touch_nxt = PLAYER1;
			else if(pl2_col) last_touch_nxt = PLAYER2;
			else last_touch_nxt = last_touch;
		end
		default: last_touch_nxt = last_touch;
	endcase
end

endmodule