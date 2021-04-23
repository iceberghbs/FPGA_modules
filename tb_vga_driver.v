`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/02/14 16:01:15
// Design Name: 
// Module Name: tb_vga_driver
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


module tb_vga_driver(
    input               clk_vga,
  //  input               rst_n,
    input   [3:0]   red,
    input   [3:0]   green,
    input   [3:0]   blue,
    //output    reg       de,
    input           vs,
    input           hs
    );

    `include "header_bmp.v"
    `include "header_str.v"
    
 //   reg clk = 1;
  //  reg clk_vga = 1;

 //   reg rst_n = 0;
 //   initial begin
 //       #100
 //       rst_n = 1;
    //   for function test
    //   test_bmp_gen(640,480,{8'd255,8'd155,8d'55});
  //  end
 //   always #5 clk = ~clk;
 //   always #5 clk_vga = ~clk_vga;




    //******************************************************************************************
    // PORT MAP
    //******************************************************************************************
 //   wire [3:0] red;
//    wire [3:0] green;
 //   wire [3:0] blue;

    /*<your entity/module name> */              /*dont change*/
 //   VGA_Driver                                   inst(

 //   .clk    /*change to your clk name*/      (clk   /*dont change*/     ),
 //   .rst_n  /*change to your rstn name*/     (rst_n /*dont change*/     ),

  
 //   .red   /*change to your 4bit r bus name*/       (red   /*dont change*/  ),
 //   .green /*change to your 4bit g bus name*/       (green /*dont change*/  ),
 //   .blue  /*change to your 4bit b bus name*/       (blue  /*dont change*/  ),
 //   .vs    /*change to your vs wire name*/          (vs    /*dont change*/  ),
  //  .hs    /*change to your hs wire name*/          (hs    /*dont change*/  )
    // .de(de)
  //  );


   //******************************************************************************************






    //******************************************************************************************
    // dont change
    //******************************************************************************************
    
    parameter H_Back_porch = 57;
    parameter H_Data = 640;
    parameter V_Back_porch = 41;
    parameter V_Data = 480;

    reg [9:0] x = 0;
    reg [9:0] y = 0;

    reg [2:1] hs_delay = 0;
    reg [2:1] vs_delay = 0;

    reg flag_frame_detected = 0;
    reg data_enable = 0;

    always @(posedge clk_vga) begin   
        hs_delay = {hs_delay[1],hs};
        vs_delay = {vs_delay[1],vs};
    end

    always @(posedge clk_vga) begin
        if(!hs)
            x = 0;
        else
            x = x + 1;
        if(vs == 0)
            y = 0;
        else if (hs_delay == 'b01)
            y = y + 1;
    end

    always @(*) begin
        //guess start point
        if(y>V_Back_porch && y<=V_Back_porch + V_Data  && x>= H_Back_porch && x< H_Data + H_Back_porch)
            data_enable = 1;
        else
            data_enable = 0;
    end

    //draw bmp picture
    integer file_id;  
    integer i,j;
    integer width = 640; 
    integer height = 480;    
    reg [0:14*8-1] new_header = 0;
    reg [0:40*8-1] new_map = 0;
    reg [0:8*8-1] filename = "0000.bmp";
    reg [15:0] frame_num = 0;

    always @(negedge vs) begin
        if(flag_frame_detected) begin
            $fclose(file_id);
            frame_num = frame_num + 1;
        end
    end
    
    reg [7:0] tmp_red;
    reg [7:0] tmp_green;
    reg [7:0] tmp_blue;
    always @(posedge clk_vga) begin
        if(data_enable == 1 && flag_frame_detected) begin
        tmp_red = color_8bit(red);
        tmp_green = color_8bit(green);
        tmp_blue = color_8bit(blue);
        //write pix                                                                          
        $fwrite(file_id,"%c%c%c", color_8bit(blue),color_8bit(green),color_8bit(red)) ;//R   
        end
            
               
    end

    always @(posedge vs) begin
        //mark the start of frame
        flag_frame_detected = 1;     
        filename[0:31] = toNumStr(frame_num);

        //create file
        file_id =$fopen(filename,"wb+");	    

        //write header
        new_header = bmp_header_gen(width*height*3 + 54,54);
        for(i = 0; i < 14; i = i + 1) begin
            $fwrite(file_id,"%c", new_header[i*8 +: 8]) ;
        end
        
        //write map
        new_map = bmp_map_gen(width,-height,24,0);
        for(i = 0; i < 40; i = i + 1) begin
            $fwrite(file_id,"%c", new_map[i*8 +: 8]) ;
        end
    end








endmodule
