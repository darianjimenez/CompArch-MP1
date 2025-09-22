// Computer Architecture Mini-Project 1 

module mpone #(
    parameter CLK_FREQ = 12000000, // CLK freq is 12MHz, so 6,000,000 cycles is 0.5s
    parameter STEP_INTERVAL = CLK_FREQ/6 
)(
    input logic     clk, 
    input logic     sw1,
    input logic     sw2,
    output logic    red, 
    output logic    green, 
    output logic    blue
);

    // Define state variable values
    localparam RED     = 3'b000;
    localparam YELLOW  = 3'b001;
    localparam GREEN   = 3'b010;
    localparam CYAN    = 3'b011;
    localparam BLUE    = 3'b100;
    localparam MAGENTA = 3'b101;

    // Declare state variables
    logic [2:0] current_state = RED;
    logic [2:0] next_state;

    // Declare next output variables
    logic next_red, next_green, next_blue;
    
    // Declare counter variables
    logic [$clog2(STEP_INTERVAL) - 1:0] count = 0;
    logic tick;

    // Make sure everything is within 1 sec
    // Register the next state of the FSM
    always_ff @(posedge clk) begin
        if (count == STEP_INTERVAL-1) begin
            count <= 0;
            tick <= 1;
        end else begin
            count <= count + 1;
            tick <= 0;
        end
    end

    always_ff @(posedge clk) begin
        if (tick)
            current_state <= next_state;
    end

    // Compute the next state of the FSM
    always_comb begin
        next_state = current_state;
        case (current_state)
            RED:
                next_state = YELLOW;
            YELLOW:
                next_state = GREEN;
            GREEN:
                next_state = CYAN;
            CYAN:
                next_state = BLUE;
            BLUE:
                next_state = MAGENTA;
            MAGENTA:
                next_state = RED;
        endcase
    end
    
    // Register the FSM outputs
    always_ff @(posedge clk) begin
        red <= next_red;
        green <= next_green;
        blue <= next_blue;
    end

    // Compute next output values
    always_comb begin
        next_red = 1'b0;
        next_green = 1'b0;
        next_blue = 1'b0;
        case (current_state)
            RED:
                next_red = 1'b1;
            YELLOW: begin
                next_red = 1'b1; next_green = 1'b1;
            end
            GREEN:
                next_green = 1'b1;
            CYAN: begin
                next_green = 1'b1; next_blue = 1'b1;
            end
            BLUE:
                next_blue = 1'b1;
            MAGENTA: begin
                next_red = 1'b1; next_blue = 1'b1;
            end
        endcase
    end

endmodule