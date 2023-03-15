; code by Neil Parker;

Divide:
    LDA #$00
    STA remainder
    STA remainder + 1
    LDX #$10
L1:
    ASL dividend
    ROL dividend + 1
    ROL remainder
    ROL remainder + 1
    LDA remainder
    SEC
    SBC divisor
    TAY
    LDA remainder + 1
    SBC divisor + 1
    BCC L2
    STA remainder + 1
    STY remainder
    INC dividend
L2:
    DEX
    BNE L1
    RTS
