`timescale 1ns/1ps

module sram_1KB_bank_lp (
    input clk,
    input cs_n,//chip select
    input we_n,//write enable
    input oe_n,//output enable
    input [7:0] addr,//address lines
    input [31:0] din,//input
    output reg [31:0] dout//output
);

    wire cs = ~cs_n;
    wire we = ~we_n;
    wire oe = ~oe_n;

    // ── BANK SELECTION (2 MSB select bank) ─────────────────────
    wire [1:0] bank_sel = addr[7:6];
    wire [5:0] row_addr = addr[5:0];

    // ── 4 BANKS (64 x 32 each) ────────────────────────────────
    (* ram_style = "block" *) reg [31:0] mem0 [0:63];
    (* ram_style = "block" *) reg [31:0] mem1 [0:63];
    (* ram_style = "block" *) reg [31:0] mem2 [0:63];
    (* ram_style = "block" *) reg [31:0] mem3 [0:63];

    // ── REGISTER INPUTS ONLY WHEN ACTIVE ──────────────────────
    reg [5:0] addr_r;
    reg [31:0] din_r;
    reg [1:0] bank_r;
    reg we_r, oe_r;

    always @(posedge clk) begin
        if (cs) begin
            addr_r <= row_addr;
            din_r <= din;
            bank_r <= bank_sel;
            we_r <= we;
            oe_r <= oe;
        end
    end

    // ── WRITE (ONLY ONE BANK ACTIVE) ──────────────────────────
    always @(posedge clk) begin
        if (cs && we_r) begin
            case (bank_r)
                2'b00: if (mem0[addr_r] != din_r) mem0[addr_r] <= din_r;
                2'b01: if (mem1[addr_r] != din_r) mem1[addr_r] <= din_r;
                2'b10: if (mem2[addr_r] != din_r) mem2[addr_r] <= din_r;
                2'b11: if (mem3[addr_r] != din_r) mem3[addr_r] <= din_r;
            endcase
        end
    end

    // ── READ (ONLY ONE BANK ACTIVE) ───────────────────────────
    always @(posedge clk) begin
        if (cs && oe_r && !we_r) begin
            case (bank_r)
                2'b00: dout <= mem0[addr_r];
                2'b01: dout <= mem1[addr_r];
                2'b10: dout <= mem2[addr_r];
                2'b11: dout <= mem3[addr_r];
            endcase
        end
    end

endmodule
