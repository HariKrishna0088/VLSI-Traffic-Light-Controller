//=============================================================================
// Module: traffic_light_fsm
// Description: FSM-based Traffic Light Controller for 4-way intersection
// Author: Daggolu Hari Krishna
//
// Features:
//   - 4-way intersection control (North-South, East-West)
//   - Pedestrian crossing request support
//   - Configurable timing for each phase
//   - Yellow (amber) transition states
//   - Emergency vehicle override mode
//=============================================================================

module traffic_light_fsm #(
    parameter GREEN_TIME  = 20, // Clock cycles for green
    parameter YELLOW_TIME = 5,  // Clock cycles for yellow
    parameter PED_TIME    = 10  // Clock cycles for pedestrian crossing
)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       ped_request,  // Pedestrian crossing button
    input  wire       emergency,    // Emergency vehicle override

    // North-South traffic lights
    output reg  [2:0] ns_light,     // {Red, Yellow, Green}

    // East-West traffic lights
    output reg  [2:0] ew_light,     // {Red, Yellow, Green}

    // Pedestrian signals
    output reg        ns_ped_walk,  // NS pedestrian walk signal
    output reg        ew_ped_walk,  // EW pedestrian walk signal

    // State debug output
    output reg  [3:0] current_state_out
);

    // Light encoding: {Red, Yellow, Green}
    localparam RED    = 3'b100;
    localparam YELLOW = 3'b010;
    localparam GREEN  = 3'b001;

    // FSM States
    localparam [3:0]
        NS_GREEN       = 4'd0,
        NS_YELLOW      = 4'd1,
        NS_PED         = 4'd2,
        EW_GREEN       = 4'd3,
        EW_YELLOW      = 4'd4,
        EW_PED         = 4'd5,
        EMERGENCY_MODE = 4'd6;

    reg [3:0]  state, next_state;
    reg [7:0]  timer;
    reg        ped_latch; // Latched pedestrian request

    // Timer counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            timer <= 8'd0;
        end else if (state != next_state) begin
            timer <= 8'd0; // Reset timer on state change
        end else begin
            timer <= timer + 1;
        end
    end

    // Latch pedestrian request until serviced
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            ped_latch <= 1'b0;
        else if (ped_request)
            ped_latch <= 1'b1;
        else if (state == NS_PED || state == EW_PED)
            ped_latch <= 1'b0;
    end

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= NS_GREEN;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        next_state = state; // Default: stay in current state

        if (emergency) begin
            next_state = EMERGENCY_MODE;
        end else begin
            case (state)
                NS_GREEN: begin
                    if (timer >= GREEN_TIME - 1)
                        next_state = NS_YELLOW;
                end

                NS_YELLOW: begin
                    if (timer >= YELLOW_TIME - 1) begin
                        if (ped_latch)
                            next_state = NS_PED;
                        else
                            next_state = EW_GREEN;
                    end
                end

                NS_PED: begin
                    if (timer >= PED_TIME - 1)
                        next_state = EW_GREEN;
                end

                EW_GREEN: begin
                    if (timer >= GREEN_TIME - 1)
                        next_state = EW_YELLOW;
                end

                EW_YELLOW: begin
                    if (timer >= YELLOW_TIME - 1) begin
                        if (ped_latch)
                            next_state = EW_PED;
                        else
                            next_state = NS_GREEN;
                    end
                end

                EW_PED: begin
                    if (timer >= PED_TIME - 1)
                        next_state = NS_GREEN;
                end

                EMERGENCY_MODE: begin
                    if (!emergency)
                        next_state = NS_GREEN;
                end

                default: next_state = NS_GREEN;
            endcase
        end
    end

    // Output logic
    always @(*) begin
        // Defaults
        ns_light    = RED;
        ew_light    = RED;
        ns_ped_walk = 1'b0;
        ew_ped_walk = 1'b0;
        current_state_out = state;

        case (state)
            NS_GREEN: begin
                ns_light = GREEN;
                ew_light = RED;
            end

            NS_YELLOW: begin
                ns_light = YELLOW;
                ew_light = RED;
            end

            NS_PED: begin
                ns_light    = RED;
                ew_light    = RED;
                ns_ped_walk = 1'b1;
            end

            EW_GREEN: begin
                ns_light = RED;
                ew_light = GREEN;
            end

            EW_YELLOW: begin
                ns_light = RED;
                ew_light = YELLOW;
            end

            EW_PED: begin
                ns_light    = RED;
                ew_light    = RED;
                ew_ped_walk = 1'b1;
            end

            EMERGENCY_MODE: begin
                // All red — clear intersection for emergency vehicle
                ns_light = RED;
                ew_light = RED;
            end
        endcase
    end

endmodule
