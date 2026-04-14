`timescale 1ns/1ps

module tb_sram_1KB_bank_lp;

    reg clk, cs_n, we_n, oe_n;
    reg [7:0] addr;
    reg [31:0] din;
    wire [31:0] dout;

    sram_1KB_bank_lp dut (
        .clk(clk), .cs_n(cs_n), .we_n(we_n), .oe_n(oe_n),
        .addr(addr), .din(din), .dout(dout)
    );

    // Slow clock → reduces dynamic power
    always #20 clk = ~clk;

    task write(input [7:0] a, input [31:0] d);
    begin
        @(posedge clk);
        cs_n=0; we_n=0; oe_n=1;
        addr=a; din=d;

        @(posedge clk);
        cs_n=1; we_n=1;
    end
    endtask

    task read(input [7:0] a);
    begin
        @(posedge clk);
        cs_n=0; we_n=1; oe_n=0;
        addr=a;

        @(posedge clk);
        @(posedge clk); // wait for output
        cs_n=1;
    end
    endtask

    initial begin
        clk=0; cs_n=1; we_n=1; oe_n=1;
        addr=0; din=0;

        repeat(5) @(posedge clk);

        // Minimal operations (LOW activity)
        write(8'h00, 32'hAAAA5555);
        write(8'h40, 32'h12345678); // different bank
        write(8'h80, 32'hDEADBEEF);
        write(8'hC0, 32'hCAFEBABE);

        read(8'h00);
        read(8'h40);

        // LONG IDLE → VERY IMPORTANT
        cs_n = 1;
        repeat(100) @(posedge clk);

        $finish;
    end

endmodule
