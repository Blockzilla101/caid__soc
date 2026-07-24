module mux3 (
    input [31:0] A,
    input [31:0] B,
    input [31:0] C,
    input [2:0] sel,
    output reg [31:0] F
);

    always @(*) begin
        case (sel)
            0: F <= A;
            1: F <= B;
            2: F <= C;
            default: F <= 32'hzzzz_zzzz;
        endcase
    end

endmodule;