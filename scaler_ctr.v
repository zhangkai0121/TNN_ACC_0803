`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/02/2018 11:26:05 AM
// Design Name: 
// Module Name: scaler_ctr
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module scaler_ctr(
        clk,
        rst_n,
        state,
        scaler_mem_addr,
        scaler_wire
    );
input clk;
input rst_n;
input state;
input scaler_mem_addr;
output scaler_wire;

wire [9:0]          scaler_mem_addr;
reg                 scaler_mem_enable;
reg                 scaler_mem_enable_p;
wire [31:0]         scaler_mem_dout;
reg                 scaler_wire_ready;
reg  [31:0]         scaler_buf;
wire [31:0]         scaler_wire;
    
scaler_mem_gen scaler_mem (
  .clka(clk),    // input wire clka
  .ena(scaler_mem_enable),      // input wire ena
  .addra(scaler_mem_addr[3:0]),  // input wire [3 : 0] addra
  .douta(scaler_mem_dout)  // output wire [31 : 0] douta
);
    
    
always@(posedge clk or negedge rst_n)
    if(!rst_n)
        scaler_mem_enable_p <= 0;
    else
        scaler_mem_enable_p <= scaler_mem_enable;    

always@(posedge clk or negedge rst_n)
    if(!rst_n)
        begin
            scaler_mem_enable <= 0;
            scaler_wire_ready <= 0;
        end
    else 
        if(state == 0)
            begin
                scaler_mem_enable <= 0;
                scaler_wire_ready <= 0;
            end    
        else    
            if(scaler_wire_ready == 0)
                begin
                    scaler_mem_enable <= 1;
                    scaler_wire_ready <= 1;
                end
            else
                begin
                    scaler_mem_enable <= 0;  
                end     
                

always@(posedge clk or negedge rst_n)
    if(!rst_n)
        scaler_buf <= 0;
    else
        if((scaler_mem_enable_p == 1) && (scaler_mem_enable == 0))
            scaler_buf <= scaler_mem_dout;    
        else
           ;


assign scaler_wire = scaler_buf;    
    
    
endmodule
