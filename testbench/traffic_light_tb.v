//=============================================================================
// Testbench: traffic_light_tb
// Description: Testbench for Traffic Light Controller FSM
// Author: Daggolu Hari Krishna
//=============================================================================

`timescale 1ns / 1ps

module traffic_light_tb;

    parameter GREEN_TIME  = 10;
    parameter YELLOW_TIME = 3;
    parameter PED_TIME    = 5;

    reg        clk;
    reg        rst_n;
    reg        ped_request;
    reg        emergency;
    wire [2:0] ns_light;
    wire [2:0] ew_light;
    wire       ns_ped_walk;
    wire       ew_ped_walk;
    wire [3:0] current_state;

    integer pass_count = 0;
    integer fail_count = 0;
    integer test_num   = 0;

    // Light encoding
    localparam RED    = 3'b100;
    localparam YELLOW = 3'b010;
    localparam GREEN  = 3'b001;

    // State encoding
    localparam NS_GREEN       = 4'd0;
    localparam NS_YELLOW      = 4'd1;
    localparam NS_PED         = 4'd2;
    localparam EW_GREEN       = 4'd3;
    localparam EW_YELLOW      = 4'd4;
    localparam EW_PED         = 4'd5;
    localparam EMERGENCY_MODE = 4'd6;

    traffic_light_fsm #(
        .GREEN_TIME  (GREEN_TIME),
        .YELLOW_TIME (YELLOW_TIME),
        .PED_TIME    (PED_TIME)
    ) uut (
        .clk              (clk),
        .rst_n            (rst_n),
        .ped_request      (ped_request),
        .emergency        (emergency),
        .ns_light         (ns_light),
        .ew_light         (ew_light),
        .ns_ped_walk      (ns_ped_walk),
        .ew_ped_walk      (ew_ped_walk),
        .current_state_out(current_state)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    task check;
        input [119:0] test_name;
        input         condition;
    begin
        test_num = test_num + 1;
        if (condition) begin
            $display("[PASS] Test %0d: %s", test_num, test_name);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] Test %0d: %s (state=%0d, NS=%b, EW=%b)",
                     test_num, test_name, current_state, ns_light, ew_light);
            fail_count = fail_count + 1;
        end
    end
    endtask

    function [39:0] light_name;
        input [2:0] light;
    begin
        case (light)
            RED:    light_name = "RED   ";
            YELLOW: light_name = "YELLOW";
            GREEN:  light_name = "GREEN ";
            default: light_name = "UNKNWN";
        endcase
    end
    endfunction

    initial begin
        $dumpfile("traffic_light_tb.vcd");
        $dumpvars(0, traffic_light_tb);

        $display("============================================================");
        $display("   TRAFFIC LIGHT CONTROLLER TESTBENCH");
        $display("   Author: Daggolu Hari Krishna");
        $display("============================================================");
        $display("");

        // Initialize
        rst_n       = 1'b0;
        ped_request = 1'b0;
        emergency   = 1'b0;
        #20;
        rst_n = 1'b1;

        // ---- Test: Initial state (NS_GREEN) ----
        $display("--- Normal Operation ---");
        #10;
        check("Init: NS=GREEN           ", ns_light === GREEN && ew_light === RED);

        // Wait for NS_GREEN to finish
        #(GREEN_TIME * 10);
        @(posedge clk); #1;
        check("NS_YELLOW after green    ", ns_light === YELLOW && ew_light === RED);

        // Wait for NS_YELLOW
        #(YELLOW_TIME * 10);
        @(posedge clk); #1;
        check("EW_GREEN after NS yellow ", ns_light === RED && ew_light === GREEN);

        // Wait for EW_GREEN
        #(GREEN_TIME * 10);
        @(posedge clk); #1;
        check("EW_YELLOW after green    ", ns_light === RED && ew_light === YELLOW);

        // Wait for EW_YELLOW → back to NS_GREEN
        #(YELLOW_TIME * 10);
        @(posedge clk); #1;
        check("NS_GREEN cycle complete  ", ns_light === GREEN && ew_light === RED);

        // ---- Test: Pedestrian request ----
        $display("");
        $display("--- Pedestrian Crossing ---");
        ped_request = 1'b1;
        @(posedge clk);
        ped_request = 1'b0;

        // Wait for current NS_GREEN to end, then NS_YELLOW, then NS_PED
        #(GREEN_TIME * 10);
        #(YELLOW_TIME * 10 + 20);
        @(posedge clk); #1;
        check("Pedestrian walk active   ", ns_ped_walk === 1'b1 || ew_ped_walk === 1'b1);

        // ---- Test: Emergency override ----
        $display("");
        $display("--- Emergency Override ---");
        #(PED_TIME * 10 + 50);
        emergency = 1'b1;
        #30;
        @(posedge clk); #1;
        check("Emergency: ALL RED       ", ns_light === RED && ew_light === RED);

        // Release emergency
        emergency = 1'b0;
        #20;
        @(posedge clk); #1;
        check("Post-emergency: NS_GREEN ", current_state === NS_GREEN);

        // Summary
        $display("");
        $display("============================================================");
        $display("  TEST SUMMARY: %0d PASSED, %0d FAILED out of %0d tests",
                 pass_count, fail_count, test_num);
        $display("============================================================");
        if (fail_count == 0)
            $display("  >>> ALL TESTS PASSED! <<<");
        else
            $display("  >>> SOME TESTS FAILED! <<<");
        $display("");
        $finish;
    end

endmodule
