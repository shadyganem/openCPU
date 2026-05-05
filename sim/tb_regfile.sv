`timescale 1ns/1ps

module tb_regfile;
    logic        clk = 0;
    logic        we = 0;
    logic [4:0]  rs1_addr = 0;
    logic [4:0]  rs2_addr = 0;
    logic [4:0]  rd_addr = 0;
    logic [31:0] rd_data = 0;
    logic [31:0] rs1_data;
    logic [31:0] rs2_data;
    int          errors = 0;

    regfile dut (.*);

    always #5 clk = ~clk;

    initial begin
        @(negedge clk);
        we = 1; rd_addr = 5'd1; rd_data = 32'hDEADBEEF;
        @(negedge clk);
        we = 1; rd_addr = 5'd2; rd_data = 32'h12345678;
        @(negedge clk);
        we = 0;
        rs1_addr = 5'd1; rs2_addr = 5'd2;
        #1;
        if (rs1_data !== 32'hDEADBEEF) begin
            $display("FAIL: x1 = %h, expected DEADBEEF", rs1_data);
            errors++;
        end
        if (rs2_data !== 32'h12345678) begin
            $display("FAIL: x2 = %h, expected 12345678", rs2_data);
            errors++;
        end

        // x0 must read as zero even if a write was attempted to it
        @(negedge clk);
        we = 1; rd_addr = 5'd0; rd_data = 32'hCAFEBABE;
        @(negedge clk);
        we = 0;
        rs1_addr = 5'd0;
        #1;
        if (rs1_data !== 32'd0) begin
            $display("FAIL: x0 = %h, expected 0", rs1_data);
            errors++;
        end

        if (errors == 0) $display("PASS: regfile");
        else             $display("FAIL: %0d error(s)", errors);
        $finish;
    end
endmodule
