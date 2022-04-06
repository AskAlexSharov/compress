// Code generated by command: go run gen.go -out seqdec_amd64.s -stubs delme.go -pkg=zstd. DO NOT EDIT.

//go:build !appengine && !noasm && gc && !noasm
// +build !appengine,!noasm,gc,!noasm

// func sequenceDecs_decode_amd64(s *sequenceDecs, br *bitReader, ctx *decodeAsmContext) int
// Requires: CMOV
TEXT ·sequenceDecs_decode_amd64(SB), $8-32
	MOVQ    br+8(FP), AX
	MOVQ    32(AX), DX
	MOVBQZX 40(AX), BX
	MOVQ    24(AX), SI
	MOVQ    (AX), AX
	ADDQ    SI, AX
	MOVQ    AX, (SP)
	MOVQ    ctx+16(FP), AX
	MOVQ    72(AX), DI
	MOVQ    80(AX), R8
	MOVQ    88(AX), R9
	MOVQ    104(AX), R10
	MOVQ    s+0(FP), AX
	MOVQ    144(AX), R11
	MOVQ    152(AX), R12
	MOVQ    160(AX), R13

sequenceDecs_decode_amd64_main_loop:
	MOVQ (SP), R14

	// Fill bitreader to have enough for the offset and match length.
	CMPQ SI, $0x08
	JL   sequenceDecs_decode_amd64_fill_byte_by_byte
	MOVQ BX, AX
	SHRQ $0x03, AX
	SUBQ AX, R14
	MOVQ (R14), DX
	SUBQ AX, SI
	ANDQ $0x07, BX
	JMP  sequenceDecs_decode_amd64_fill_end

sequenceDecs_decode_amd64_fill_byte_by_byte:
	CMPQ    SI, $0x00
	JLE     sequenceDecs_decode_amd64_fill_end
	CMPQ    BX, $0x07
	JLE     sequenceDecs_decode_amd64_fill_end
	SHLQ    $0x08, DX
	SUBQ    $0x01, R14
	SUBQ    $0x01, SI
	SUBQ    $0x08, BX
	MOVBQZX (R14), AX
	ORQ     AX, DX
	JMP     sequenceDecs_decode_amd64_fill_byte_by_byte

sequenceDecs_decode_amd64_fill_end:
	// Update offset
	MOVQ    R9, AX
	MOVQ    BX, CX
	MOVQ    DX, R15
	SHLQ    CL, R15
	MOVB    AH, CL
	ADDQ    CX, BX
	NEGL    CX
	SHRQ    CL, R15
	SHRQ    $0x20, AX
	TESTQ   CX, CX
	CMOVQEQ CX, R15
	ADDQ    R15, AX
	MOVQ    AX, 16(R10)

	// Update match length
	MOVQ    R8, AX
	MOVQ    BX, CX
	MOVQ    DX, R15
	SHLQ    CL, R15
	MOVB    AH, CL
	ADDQ    CX, BX
	NEGL    CX
	SHRQ    CL, R15
	SHRQ    $0x20, AX
	TESTQ   CX, CX
	CMOVQEQ CX, R15
	ADDQ    R15, AX
	MOVQ    AX, 8(R10)

	// Fill bitreader to have enough for the remaining
	CMPQ SI, $0x08
	JL   sequenceDecs_decode_amd64_fill_2_byte_by_byte
	MOVQ BX, AX
	SHRQ $0x03, AX
	SUBQ AX, R14
	MOVQ (R14), DX
	SUBQ AX, SI
	ANDQ $0x07, BX
	JMP  sequenceDecs_decode_amd64_fill_2_end

sequenceDecs_decode_amd64_fill_2_byte_by_byte:
	CMPQ    SI, $0x00
	JLE     sequenceDecs_decode_amd64_fill_2_end
	CMPQ    BX, $0x07
	JLE     sequenceDecs_decode_amd64_fill_2_end
	SHLQ    $0x08, DX
	SUBQ    $0x01, R14
	SUBQ    $0x01, SI
	SUBQ    $0x08, BX
	MOVBQZX (R14), AX
	ORQ     AX, DX
	JMP     sequenceDecs_decode_amd64_fill_2_byte_by_byte

sequenceDecs_decode_amd64_fill_2_end:
	// Update literal length
	MOVQ    DI, AX
	MOVQ    BX, CX
	MOVQ    DX, R15
	SHLQ    CL, R15
	MOVB    AH, CL
	ADDQ    CX, BX
	NEGL    CX
	SHRQ    CL, R15
	SHRQ    $0x20, AX
	TESTQ   CX, CX
	CMOVQEQ CX, R15
	ADDQ    R15, AX
	MOVQ    AX, (R10)

	// Fill bitreader for state updates
	MOVQ    R14, (SP)
	MOVQ    R9, AX
	SHRQ    $0x08, AX
	MOVBQZX AL, AX
	MOVQ    ctx+16(FP), CX
	CMPQ    96(CX), $0x00
	JZ      sequenceDecs_decode_amd64_skip_update

	// Update Literal Length State
	MOVBQZX DI, R14
	SHRQ    $0x10, DI
	MOVWQZX DI, DI
	CMPQ    R14, $0x00
	JZ      sequenceDecs_decode_amd64_llState_updateState_skip_zero
	MOVQ    BX, CX
	ADDQ    R14, BX
	MOVQ    DX, R15
	SHLQ    CL, R15
	MOVQ    R14, CX
	NEGQ    CX
	SHRQ    CL, R15
	ADDQ    R15, DI

sequenceDecs_decode_amd64_llState_updateState_skip_zero:
	// Load ctx.llTable
	MOVQ ctx+16(FP), CX
	MOVQ (CX), CX
	MOVQ (CX)(DI*8), DI

	// Update Match Length State
	MOVBQZX R8, R14
	SHRQ    $0x10, R8
	MOVWQZX R8, R8
	CMPQ    R14, $0x00
	JZ      sequenceDecs_decode_amd64_mlState_updateState_skip_zero
	MOVQ    BX, CX
	ADDQ    R14, BX
	MOVQ    DX, R15
	SHLQ    CL, R15
	MOVQ    R14, CX
	NEGQ    CX
	SHRQ    CL, R15
	ADDQ    R15, R8

sequenceDecs_decode_amd64_mlState_updateState_skip_zero:
	// Load ctx.mlTable
	MOVQ ctx+16(FP), CX
	MOVQ 24(CX), CX
	MOVQ (CX)(R8*8), R8

	// Update Offset State
	MOVBQZX R9, R14
	SHRQ    $0x10, R9
	MOVWQZX R9, R9
	CMPQ    R14, $0x00
	JZ      sequenceDecs_decode_amd64_ofState_updateState_skip_zero
	MOVQ    BX, CX
	ADDQ    R14, BX
	MOVQ    DX, R15
	SHLQ    CL, R15
	MOVQ    R14, CX
	NEGQ    CX
	SHRQ    CL, R15
	ADDQ    R15, R9

sequenceDecs_decode_amd64_ofState_updateState_skip_zero:
	// Load ctx.ofTable
	MOVQ ctx+16(FP), CX
	MOVQ 48(CX), CX
	MOVQ (CX)(R9*8), R9

sequenceDecs_decode_amd64_skip_update:
	// Adjust offset
	MOVQ 16(R10), CX
	CMPQ AX, $0x01
	JBE  sequenceDecs_decode_amd64_adjust_offsetB_1_or_0
	MOVQ R12, R13
	MOVQ R11, R12
	MOVQ CX, R11
	JMP  sequenceDecs_decode_amd64_adjust_end

sequenceDecs_decode_amd64_adjust_offsetB_1_or_0:
	CMPQ (R10), $0x00000000
	JNE  sequenceDecs_decode_amd64_adjust_offset_maybezero
	INCQ CX
	JMP  sequenceDecs_decode_amd64_adjust_offset_nonzero

sequenceDecs_decode_amd64_adjust_offset_maybezero:
	TESTQ CX, CX
	JNZ   sequenceDecs_decode_amd64_adjust_offset_nonzero
	MOVQ  R11, CX
	JMP   sequenceDecs_decode_amd64_adjust_end

sequenceDecs_decode_amd64_adjust_offset_nonzero:
	CMPQ CX, $0x01
	JB   sequenceDecs_decode_amd64_adjust_zero
	JEQ  sequenceDecs_decode_amd64_adjust_one
	CMPQ CX, $0x02
	JA   sequenceDecs_decode_amd64_adjust_three
	JMP  sequenceDecs_decode_amd64_adjust_two

sequenceDecs_decode_amd64_adjust_zero:
	MOVQ R11, AX
	JMP  sequenceDecs_decode_amd64_adjust_test_temp_valid

sequenceDecs_decode_amd64_adjust_one:
	MOVQ R12, AX
	JMP  sequenceDecs_decode_amd64_adjust_test_temp_valid

sequenceDecs_decode_amd64_adjust_two:
	MOVQ R13, AX
	JMP  sequenceDecs_decode_amd64_adjust_test_temp_valid

sequenceDecs_decode_amd64_adjust_three:
	LEAQ -1(R11), AX

sequenceDecs_decode_amd64_adjust_test_temp_valid:
	TESTQ AX, AX
	JNZ   sequenceDecs_decode_amd64_adjust_temp_valid
	MOVQ  $0x00000001, AX

sequenceDecs_decode_amd64_adjust_temp_valid:
	CMPQ    CX, $0x01
	CMOVQNE R12, R13
	MOVQ    R11, R12
	MOVQ    AX, R11
	MOVQ    AX, CX

sequenceDecs_decode_amd64_adjust_end:
	MOVQ CX, 16(R10)

	// Check values
	MOVQ  8(R10), AX
	MOVQ  (R10), R14
	LEAQ  (AX)(R14*1), R15
	MOVQ  s+0(FP), BP
	ADDQ  R15, 256(BP)
	MOVQ  ctx+16(FP), R15
	SUBQ  R14, 128(R15)
	CMPQ  AX, $0x00020002
	JA    sequenceDecs_decode_amd64_error_match_len_too_big
	TESTQ CX, CX
	JNZ   sequenceDecs_decode_amd64_match_len_ofs_ok
	TESTQ AX, AX
	JNZ   sequenceDecs_decode_amd64_error_match_len_ofs_mismatch

sequenceDecs_decode_amd64_match_len_ofs_ok:
	ADDQ $0x18, R10
	MOVQ ctx+16(FP), AX
	DECQ 96(AX)
	JNS  sequenceDecs_decode_amd64_main_loop
	MOVQ s+0(FP), AX
	MOVQ R11, 144(AX)
	MOVQ R12, 152(AX)
	MOVQ R13, 160(AX)
	MOVQ br+8(FP), AX
	MOVQ DX, 32(AX)
	MOVB BL, 40(AX)
	MOVQ SI, 24(AX)

	// Return success
	MOVQ $0x00000000, ret+24(FP)
	RET

	// Return with match length error
sequenceDecs_decode_amd64_error_match_len_ofs_mismatch:
	MOVQ $0x00000001, ret+24(FP)
	RET

	// Return with match too long error
sequenceDecs_decode_amd64_error_match_len_too_big:
	MOVQ $0x00000002, ret+24(FP)
	RET

// func sequenceDecs_decode_56_amd64(s *sequenceDecs, br *bitReader, ctx *decodeAsmContext) int
// Requires: CMOV
TEXT ·sequenceDecs_decode_56_amd64(SB), $8-32
	MOVQ    br+8(FP), AX
	MOVQ    32(AX), DX
	MOVBQZX 40(AX), BX
	MOVQ    24(AX), SI
	MOVQ    (AX), AX
	ADDQ    SI, AX
	MOVQ    AX, (SP)
	MOVQ    ctx+16(FP), AX
	MOVQ    72(AX), DI
	MOVQ    80(AX), R8
	MOVQ    88(AX), R9
	MOVQ    104(AX), R10
	MOVQ    s+0(FP), AX
	MOVQ    144(AX), R11
	MOVQ    152(AX), R12
	MOVQ    160(AX), R13

sequenceDecs_decode_56_amd64_main_loop:
	MOVQ (SP), R14

	// Fill bitreader to have enough for the offset and match length.
	CMPQ SI, $0x08
	JL   sequenceDecs_decode_56_amd64_fill_byte_by_byte
	MOVQ BX, AX
	SHRQ $0x03, AX
	SUBQ AX, R14
	MOVQ (R14), DX
	SUBQ AX, SI
	ANDQ $0x07, BX
	JMP  sequenceDecs_decode_56_amd64_fill_end

sequenceDecs_decode_56_amd64_fill_byte_by_byte:
	CMPQ    SI, $0x00
	JLE     sequenceDecs_decode_56_amd64_fill_end
	CMPQ    BX, $0x07
	JLE     sequenceDecs_decode_56_amd64_fill_end
	SHLQ    $0x08, DX
	SUBQ    $0x01, R14
	SUBQ    $0x01, SI
	SUBQ    $0x08, BX
	MOVBQZX (R14), AX
	ORQ     AX, DX
	JMP     sequenceDecs_decode_56_amd64_fill_byte_by_byte

sequenceDecs_decode_56_amd64_fill_end:
	// Update offset
	MOVQ    R9, AX
	MOVQ    BX, CX
	MOVQ    DX, R15
	SHLQ    CL, R15
	MOVB    AH, CL
	ADDQ    CX, BX
	NEGL    CX
	SHRQ    CL, R15
	SHRQ    $0x20, AX
	TESTQ   CX, CX
	CMOVQEQ CX, R15
	ADDQ    R15, AX
	MOVQ    AX, 16(R10)

	// Update match length
	MOVQ    R8, AX
	MOVQ    BX, CX
	MOVQ    DX, R15
	SHLQ    CL, R15
	MOVB    AH, CL
	ADDQ    CX, BX
	NEGL    CX
	SHRQ    CL, R15
	SHRQ    $0x20, AX
	TESTQ   CX, CX
	CMOVQEQ CX, R15
	ADDQ    R15, AX
	MOVQ    AX, 8(R10)

	// Update literal length
	MOVQ    DI, AX
	MOVQ    BX, CX
	MOVQ    DX, R15
	SHLQ    CL, R15
	MOVB    AH, CL
	ADDQ    CX, BX
	NEGL    CX
	SHRQ    CL, R15
	SHRQ    $0x20, AX
	TESTQ   CX, CX
	CMOVQEQ CX, R15
	ADDQ    R15, AX
	MOVQ    AX, (R10)

	// Fill bitreader for state updates
	MOVQ    R14, (SP)
	MOVQ    R9, AX
	SHRQ    $0x08, AX
	MOVBQZX AL, AX
	MOVQ    ctx+16(FP), CX
	CMPQ    96(CX), $0x00
	JZ      sequenceDecs_decode_56_amd64_skip_update

	// Update Literal Length State
	MOVBQZX DI, R14
	SHRQ    $0x10, DI
	MOVWQZX DI, DI
	CMPQ    R14, $0x00
	JZ      sequenceDecs_decode_56_amd64_llState_updateState_skip_zero
	MOVQ    BX, CX
	ADDQ    R14, BX
	MOVQ    DX, R15
	SHLQ    CL, R15
	MOVQ    R14, CX
	NEGQ    CX
	SHRQ    CL, R15
	ADDQ    R15, DI

sequenceDecs_decode_56_amd64_llState_updateState_skip_zero:
	// Load ctx.llTable
	MOVQ ctx+16(FP), CX
	MOVQ (CX), CX
	MOVQ (CX)(DI*8), DI

	// Update Match Length State
	MOVBQZX R8, R14
	SHRQ    $0x10, R8
	MOVWQZX R8, R8
	CMPQ    R14, $0x00
	JZ      sequenceDecs_decode_56_amd64_mlState_updateState_skip_zero
	MOVQ    BX, CX
	ADDQ    R14, BX
	MOVQ    DX, R15
	SHLQ    CL, R15
	MOVQ    R14, CX
	NEGQ    CX
	SHRQ    CL, R15
	ADDQ    R15, R8

sequenceDecs_decode_56_amd64_mlState_updateState_skip_zero:
	// Load ctx.mlTable
	MOVQ ctx+16(FP), CX
	MOVQ 24(CX), CX
	MOVQ (CX)(R8*8), R8

	// Update Offset State
	MOVBQZX R9, R14
	SHRQ    $0x10, R9
	MOVWQZX R9, R9
	CMPQ    R14, $0x00
	JZ      sequenceDecs_decode_56_amd64_ofState_updateState_skip_zero
	MOVQ    BX, CX
	ADDQ    R14, BX
	MOVQ    DX, R15
	SHLQ    CL, R15
	MOVQ    R14, CX
	NEGQ    CX
	SHRQ    CL, R15
	ADDQ    R15, R9

sequenceDecs_decode_56_amd64_ofState_updateState_skip_zero:
	// Load ctx.ofTable
	MOVQ ctx+16(FP), CX
	MOVQ 48(CX), CX
	MOVQ (CX)(R9*8), R9

sequenceDecs_decode_56_amd64_skip_update:
	// Adjust offset
	MOVQ 16(R10), CX
	CMPQ AX, $0x01
	JBE  sequenceDecs_decode_56_amd64_adjust_offsetB_1_or_0
	MOVQ R12, R13
	MOVQ R11, R12
	MOVQ CX, R11
	JMP  sequenceDecs_decode_56_amd64_adjust_end

sequenceDecs_decode_56_amd64_adjust_offsetB_1_or_0:
	CMPQ (R10), $0x00000000
	JNE  sequenceDecs_decode_56_amd64_adjust_offset_maybezero
	INCQ CX
	JMP  sequenceDecs_decode_56_amd64_adjust_offset_nonzero

sequenceDecs_decode_56_amd64_adjust_offset_maybezero:
	TESTQ CX, CX
	JNZ   sequenceDecs_decode_56_amd64_adjust_offset_nonzero
	MOVQ  R11, CX
	JMP   sequenceDecs_decode_56_amd64_adjust_end

sequenceDecs_decode_56_amd64_adjust_offset_nonzero:
	CMPQ CX, $0x01
	JB   sequenceDecs_decode_56_amd64_adjust_zero
	JEQ  sequenceDecs_decode_56_amd64_adjust_one
	CMPQ CX, $0x02
	JA   sequenceDecs_decode_56_amd64_adjust_three
	JMP  sequenceDecs_decode_56_amd64_adjust_two

sequenceDecs_decode_56_amd64_adjust_zero:
	MOVQ R11, AX
	JMP  sequenceDecs_decode_56_amd64_adjust_test_temp_valid

sequenceDecs_decode_56_amd64_adjust_one:
	MOVQ R12, AX
	JMP  sequenceDecs_decode_56_amd64_adjust_test_temp_valid

sequenceDecs_decode_56_amd64_adjust_two:
	MOVQ R13, AX
	JMP  sequenceDecs_decode_56_amd64_adjust_test_temp_valid

sequenceDecs_decode_56_amd64_adjust_three:
	LEAQ -1(R11), AX

sequenceDecs_decode_56_amd64_adjust_test_temp_valid:
	TESTQ AX, AX
	JNZ   sequenceDecs_decode_56_amd64_adjust_temp_valid
	MOVQ  $0x00000001, AX

sequenceDecs_decode_56_amd64_adjust_temp_valid:
	CMPQ    CX, $0x01
	CMOVQNE R12, R13
	MOVQ    R11, R12
	MOVQ    AX, R11
	MOVQ    AX, CX

sequenceDecs_decode_56_amd64_adjust_end:
	MOVQ CX, 16(R10)

	// Check values
	MOVQ  8(R10), AX
	MOVQ  (R10), R14
	LEAQ  (AX)(R14*1), R15
	MOVQ  s+0(FP), BP
	ADDQ  R15, 256(BP)
	MOVQ  ctx+16(FP), R15
	SUBQ  R14, 128(R15)
	CMPQ  AX, $0x00020002
	JA    sequenceDecs_decode_56_amd64_error_match_len_too_big
	TESTQ CX, CX
	JNZ   sequenceDecs_decode_56_amd64_match_len_ofs_ok
	TESTQ AX, AX
	JNZ   sequenceDecs_decode_56_amd64_error_match_len_ofs_mismatch

sequenceDecs_decode_56_amd64_match_len_ofs_ok:
	ADDQ $0x18, R10
	MOVQ ctx+16(FP), AX
	DECQ 96(AX)
	JNS  sequenceDecs_decode_56_amd64_main_loop
	MOVQ s+0(FP), AX
	MOVQ R11, 144(AX)
	MOVQ R12, 152(AX)
	MOVQ R13, 160(AX)
	MOVQ br+8(FP), AX
	MOVQ DX, 32(AX)
	MOVB BL, 40(AX)
	MOVQ SI, 24(AX)

	// Return success
	MOVQ $0x00000000, ret+24(FP)
	RET

	// Return with match length error
sequenceDecs_decode_56_amd64_error_match_len_ofs_mismatch:
	MOVQ $0x00000001, ret+24(FP)
	RET

	// Return with match too long error
sequenceDecs_decode_56_amd64_error_match_len_too_big:
	MOVQ $0x00000002, ret+24(FP)
	RET

// func sequenceDecs_decode_bmi2(s *sequenceDecs, br *bitReader, ctx *decodeAsmContext) int
// Requires: BMI, BMI2, CMOV
TEXT ·sequenceDecs_decode_bmi2(SB), $8-32
	MOVQ    br+8(FP), CX
	MOVQ    32(CX), AX
	MOVBQZX 40(CX), DX
	MOVQ    24(CX), BX
	MOVQ    (CX), CX
	ADDQ    BX, CX
	MOVQ    CX, (SP)
	MOVQ    ctx+16(FP), CX
	MOVQ    72(CX), SI
	MOVQ    80(CX), DI
	MOVQ    88(CX), R8
	MOVQ    104(CX), R9
	MOVQ    s+0(FP), CX
	MOVQ    144(CX), R10
	MOVQ    152(CX), R11
	MOVQ    160(CX), R12

sequenceDecs_decode_bmi2_main_loop:
	MOVQ (SP), R13

	// Fill bitreader to have enough for the offset and match length.
	CMPQ BX, $0x08
	JL   sequenceDecs_decode_bmi2_fill_byte_by_byte
	MOVQ DX, CX
	SHRQ $0x03, CX
	SUBQ CX, R13
	MOVQ (R13), AX
	SUBQ CX, BX
	ANDQ $0x07, DX
	JMP  sequenceDecs_decode_bmi2_fill_end

sequenceDecs_decode_bmi2_fill_byte_by_byte:
	CMPQ    BX, $0x00
	JLE     sequenceDecs_decode_bmi2_fill_end
	CMPQ    DX, $0x07
	JLE     sequenceDecs_decode_bmi2_fill_end
	SHLQ    $0x08, AX
	SUBQ    $0x01, R13
	SUBQ    $0x01, BX
	SUBQ    $0x08, DX
	MOVBQZX (R13), CX
	ORQ     CX, AX
	JMP     sequenceDecs_decode_bmi2_fill_byte_by_byte

sequenceDecs_decode_bmi2_fill_end:
	// Update offset
	MOVQ   $0x00000808, CX
	BEXTRQ CX, R8, R14
	MOVQ   AX, R15
	LEAQ   (DX)(R14*1), CX
	ROLQ   CL, R15
	BZHIQ  R14, R15, R15
	MOVQ   CX, DX
	MOVQ   R8, CX
	SHRQ   $0x20, CX
	ADDQ   R15, CX
	MOVQ   CX, 16(R9)

	// Update match length
	MOVQ   $0x00000808, CX
	BEXTRQ CX, DI, R14
	MOVQ   AX, R15
	LEAQ   (DX)(R14*1), CX
	ROLQ   CL, R15
	BZHIQ  R14, R15, R15
	MOVQ   CX, DX
	MOVQ   DI, CX
	SHRQ   $0x20, CX
	ADDQ   R15, CX
	MOVQ   CX, 8(R9)

	// Fill bitreader to have enough for the remaining
	CMPQ BX, $0x08
	JL   sequenceDecs_decode_bmi2_fill_2_byte_by_byte
	MOVQ DX, CX
	SHRQ $0x03, CX
	SUBQ CX, R13
	MOVQ (R13), AX
	SUBQ CX, BX
	ANDQ $0x07, DX
	JMP  sequenceDecs_decode_bmi2_fill_2_end

sequenceDecs_decode_bmi2_fill_2_byte_by_byte:
	CMPQ    BX, $0x00
	JLE     sequenceDecs_decode_bmi2_fill_2_end
	CMPQ    DX, $0x07
	JLE     sequenceDecs_decode_bmi2_fill_2_end
	SHLQ    $0x08, AX
	SUBQ    $0x01, R13
	SUBQ    $0x01, BX
	SUBQ    $0x08, DX
	MOVBQZX (R13), CX
	ORQ     CX, AX
	JMP     sequenceDecs_decode_bmi2_fill_2_byte_by_byte

sequenceDecs_decode_bmi2_fill_2_end:
	// Update literal length
	MOVQ   $0x00000808, CX
	BEXTRQ CX, SI, R14
	MOVQ   AX, R15
	LEAQ   (DX)(R14*1), CX
	ROLQ   CL, R15
	BZHIQ  R14, R15, R15
	MOVQ   CX, DX
	MOVQ   SI, CX
	SHRQ   $0x20, CX
	ADDQ   R15, CX
	MOVQ   CX, (R9)

	// Fill bitreader for state updates
	MOVQ   R13, (SP)
	MOVQ   $0x00000808, CX
	BEXTRQ CX, R8, R13
	MOVQ   ctx+16(FP), CX
	CMPQ   96(CX), $0x00
	JZ     sequenceDecs_decode_bmi2_skip_update

	// Update Literal Length State
	MOVBQZX SI, R14
	MOVQ    $0x00001010, CX
	BEXTRQ  CX, SI, SI
	LEAQ    (DX)(R14*1), CX
	MOVQ    AX, R15
	MOVQ    CX, DX
	ROLQ    CL, R15
	BZHIQ   R14, R15, R15
	ADDQ    R15, SI

	// Load ctx.llTable
	MOVQ ctx+16(FP), CX
	MOVQ (CX), CX
	MOVQ (CX)(SI*8), SI

	// Update Match Length State
	MOVBQZX DI, R14
	MOVQ    $0x00001010, CX
	BEXTRQ  CX, DI, DI
	LEAQ    (DX)(R14*1), CX
	MOVQ    AX, R15
	MOVQ    CX, DX
	ROLQ    CL, R15
	BZHIQ   R14, R15, R15
	ADDQ    R15, DI

	// Load ctx.mlTable
	MOVQ ctx+16(FP), CX
	MOVQ 24(CX), CX
	MOVQ (CX)(DI*8), DI

	// Update Offset State
	MOVBQZX R8, R14
	MOVQ    $0x00001010, CX
	BEXTRQ  CX, R8, R8
	LEAQ    (DX)(R14*1), CX
	MOVQ    AX, R15
	MOVQ    CX, DX
	ROLQ    CL, R15
	BZHIQ   R14, R15, R15
	ADDQ    R15, R8

	// Load ctx.ofTable
	MOVQ ctx+16(FP), CX
	MOVQ 48(CX), CX
	MOVQ (CX)(R8*8), R8

sequenceDecs_decode_bmi2_skip_update:
	// Adjust offset
	MOVQ 16(R9), CX
	CMPQ R13, $0x01
	JBE  sequenceDecs_decode_bmi2_adjust_offsetB_1_or_0
	MOVQ R11, R12
	MOVQ R10, R11
	MOVQ CX, R10
	JMP  sequenceDecs_decode_bmi2_adjust_end

sequenceDecs_decode_bmi2_adjust_offsetB_1_or_0:
	CMPQ (R9), $0x00000000
	JNE  sequenceDecs_decode_bmi2_adjust_offset_maybezero
	INCQ CX
	JMP  sequenceDecs_decode_bmi2_adjust_offset_nonzero

sequenceDecs_decode_bmi2_adjust_offset_maybezero:
	TESTQ CX, CX
	JNZ   sequenceDecs_decode_bmi2_adjust_offset_nonzero
	MOVQ  R10, CX
	JMP   sequenceDecs_decode_bmi2_adjust_end

sequenceDecs_decode_bmi2_adjust_offset_nonzero:
	CMPQ CX, $0x01
	JB   sequenceDecs_decode_bmi2_adjust_zero
	JEQ  sequenceDecs_decode_bmi2_adjust_one
	CMPQ CX, $0x02
	JA   sequenceDecs_decode_bmi2_adjust_three
	JMP  sequenceDecs_decode_bmi2_adjust_two

sequenceDecs_decode_bmi2_adjust_zero:
	MOVQ R10, R13
	JMP  sequenceDecs_decode_bmi2_adjust_test_temp_valid

sequenceDecs_decode_bmi2_adjust_one:
	MOVQ R11, R13
	JMP  sequenceDecs_decode_bmi2_adjust_test_temp_valid

sequenceDecs_decode_bmi2_adjust_two:
	MOVQ R12, R13
	JMP  sequenceDecs_decode_bmi2_adjust_test_temp_valid

sequenceDecs_decode_bmi2_adjust_three:
	LEAQ -1(R10), R13

sequenceDecs_decode_bmi2_adjust_test_temp_valid:
	TESTQ R13, R13
	JNZ   sequenceDecs_decode_bmi2_adjust_temp_valid
	MOVQ  $0x00000001, R13

sequenceDecs_decode_bmi2_adjust_temp_valid:
	CMPQ    CX, $0x01
	CMOVQNE R11, R12
	MOVQ    R10, R11
	MOVQ    R13, R10
	MOVQ    R13, CX

sequenceDecs_decode_bmi2_adjust_end:
	MOVQ CX, 16(R9)

	// Check values
	MOVQ  8(R9), R13
	MOVQ  (R9), R14
	LEAQ  (R13)(R14*1), R15
	MOVQ  s+0(FP), BP
	ADDQ  R15, 256(BP)
	MOVQ  ctx+16(FP), R15
	SUBQ  R14, 128(R15)
	CMPQ  R13, $0x00020002
	JA    sequenceDecs_decode_bmi2_error_match_len_too_big
	TESTQ CX, CX
	JNZ   sequenceDecs_decode_bmi2_match_len_ofs_ok
	TESTQ R13, R13
	JNZ   sequenceDecs_decode_bmi2_error_match_len_ofs_mismatch

sequenceDecs_decode_bmi2_match_len_ofs_ok:
	ADDQ $0x18, R9
	MOVQ ctx+16(FP), CX
	DECQ 96(CX)
	JNS  sequenceDecs_decode_bmi2_main_loop
	MOVQ s+0(FP), CX
	MOVQ R10, 144(CX)
	MOVQ R11, 152(CX)
	MOVQ R12, 160(CX)
	MOVQ br+8(FP), CX
	MOVQ AX, 32(CX)
	MOVB DL, 40(CX)
	MOVQ BX, 24(CX)

	// Return success
	MOVQ $0x00000000, ret+24(FP)
	RET

	// Return with match length error
sequenceDecs_decode_bmi2_error_match_len_ofs_mismatch:
	MOVQ $0x00000001, ret+24(FP)
	RET

	// Return with match too long error
sequenceDecs_decode_bmi2_error_match_len_too_big:
	MOVQ $0x00000002, ret+24(FP)
	RET

// func sequenceDecs_decode_56_bmi2(s *sequenceDecs, br *bitReader, ctx *decodeAsmContext) int
// Requires: BMI, BMI2, CMOV
TEXT ·sequenceDecs_decode_56_bmi2(SB), $8-32
	MOVQ    br+8(FP), CX
	MOVQ    32(CX), AX
	MOVBQZX 40(CX), DX
	MOVQ    24(CX), BX
	MOVQ    (CX), CX
	ADDQ    BX, CX
	MOVQ    CX, (SP)
	MOVQ    ctx+16(FP), CX
	MOVQ    72(CX), SI
	MOVQ    80(CX), DI
	MOVQ    88(CX), R8
	MOVQ    104(CX), R9
	MOVQ    s+0(FP), CX
	MOVQ    144(CX), R10
	MOVQ    152(CX), R11
	MOVQ    160(CX), R12

sequenceDecs_decode_56_bmi2_main_loop:
	MOVQ (SP), R13

	// Fill bitreader to have enough for the offset and match length.
	CMPQ BX, $0x08
	JL   sequenceDecs_decode_56_bmi2_fill_byte_by_byte
	MOVQ DX, CX
	SHRQ $0x03, CX
	SUBQ CX, R13
	MOVQ (R13), AX
	SUBQ CX, BX
	ANDQ $0x07, DX
	JMP  sequenceDecs_decode_56_bmi2_fill_end

sequenceDecs_decode_56_bmi2_fill_byte_by_byte:
	CMPQ    BX, $0x00
	JLE     sequenceDecs_decode_56_bmi2_fill_end
	CMPQ    DX, $0x07
	JLE     sequenceDecs_decode_56_bmi2_fill_end
	SHLQ    $0x08, AX
	SUBQ    $0x01, R13
	SUBQ    $0x01, BX
	SUBQ    $0x08, DX
	MOVBQZX (R13), CX
	ORQ     CX, AX
	JMP     sequenceDecs_decode_56_bmi2_fill_byte_by_byte

sequenceDecs_decode_56_bmi2_fill_end:
	// Update offset
	MOVQ   $0x00000808, CX
	BEXTRQ CX, R8, R14
	MOVQ   AX, R15
	LEAQ   (DX)(R14*1), CX
	ROLQ   CL, R15
	BZHIQ  R14, R15, R15
	MOVQ   CX, DX
	MOVQ   R8, CX
	SHRQ   $0x20, CX
	ADDQ   R15, CX
	MOVQ   CX, 16(R9)

	// Update match length
	MOVQ   $0x00000808, CX
	BEXTRQ CX, DI, R14
	MOVQ   AX, R15
	LEAQ   (DX)(R14*1), CX
	ROLQ   CL, R15
	BZHIQ  R14, R15, R15
	MOVQ   CX, DX
	MOVQ   DI, CX
	SHRQ   $0x20, CX
	ADDQ   R15, CX
	MOVQ   CX, 8(R9)

	// Update literal length
	MOVQ   $0x00000808, CX
	BEXTRQ CX, SI, R14
	MOVQ   AX, R15
	LEAQ   (DX)(R14*1), CX
	ROLQ   CL, R15
	BZHIQ  R14, R15, R15
	MOVQ   CX, DX
	MOVQ   SI, CX
	SHRQ   $0x20, CX
	ADDQ   R15, CX
	MOVQ   CX, (R9)

	// Fill bitreader for state updates
	MOVQ   R13, (SP)
	MOVQ   $0x00000808, CX
	BEXTRQ CX, R8, R13
	MOVQ   ctx+16(FP), CX
	CMPQ   96(CX), $0x00
	JZ     sequenceDecs_decode_56_bmi2_skip_update

	// Update Literal Length State
	MOVBQZX SI, R14
	MOVQ    $0x00001010, CX
	BEXTRQ  CX, SI, SI
	LEAQ    (DX)(R14*1), CX
	MOVQ    AX, R15
	MOVQ    CX, DX
	ROLQ    CL, R15
	BZHIQ   R14, R15, R15
	ADDQ    R15, SI

	// Load ctx.llTable
	MOVQ ctx+16(FP), CX
	MOVQ (CX), CX
	MOVQ (CX)(SI*8), SI

	// Update Match Length State
	MOVBQZX DI, R14
	MOVQ    $0x00001010, CX
	BEXTRQ  CX, DI, DI
	LEAQ    (DX)(R14*1), CX
	MOVQ    AX, R15
	MOVQ    CX, DX
	ROLQ    CL, R15
	BZHIQ   R14, R15, R15
	ADDQ    R15, DI

	// Load ctx.mlTable
	MOVQ ctx+16(FP), CX
	MOVQ 24(CX), CX
	MOVQ (CX)(DI*8), DI

	// Update Offset State
	MOVBQZX R8, R14
	MOVQ    $0x00001010, CX
	BEXTRQ  CX, R8, R8
	LEAQ    (DX)(R14*1), CX
	MOVQ    AX, R15
	MOVQ    CX, DX
	ROLQ    CL, R15
	BZHIQ   R14, R15, R15
	ADDQ    R15, R8

	// Load ctx.ofTable
	MOVQ ctx+16(FP), CX
	MOVQ 48(CX), CX
	MOVQ (CX)(R8*8), R8

sequenceDecs_decode_56_bmi2_skip_update:
	// Adjust offset
	MOVQ 16(R9), CX
	CMPQ R13, $0x01
	JBE  sequenceDecs_decode_56_bmi2_adjust_offsetB_1_or_0
	MOVQ R11, R12
	MOVQ R10, R11
	MOVQ CX, R10
	JMP  sequenceDecs_decode_56_bmi2_adjust_end

sequenceDecs_decode_56_bmi2_adjust_offsetB_1_or_0:
	CMPQ (R9), $0x00000000
	JNE  sequenceDecs_decode_56_bmi2_adjust_offset_maybezero
	INCQ CX
	JMP  sequenceDecs_decode_56_bmi2_adjust_offset_nonzero

sequenceDecs_decode_56_bmi2_adjust_offset_maybezero:
	TESTQ CX, CX
	JNZ   sequenceDecs_decode_56_bmi2_adjust_offset_nonzero
	MOVQ  R10, CX
	JMP   sequenceDecs_decode_56_bmi2_adjust_end

sequenceDecs_decode_56_bmi2_adjust_offset_nonzero:
	CMPQ CX, $0x01
	JB   sequenceDecs_decode_56_bmi2_adjust_zero
	JEQ  sequenceDecs_decode_56_bmi2_adjust_one
	CMPQ CX, $0x02
	JA   sequenceDecs_decode_56_bmi2_adjust_three
	JMP  sequenceDecs_decode_56_bmi2_adjust_two

sequenceDecs_decode_56_bmi2_adjust_zero:
	MOVQ R10, R13
	JMP  sequenceDecs_decode_56_bmi2_adjust_test_temp_valid

sequenceDecs_decode_56_bmi2_adjust_one:
	MOVQ R11, R13
	JMP  sequenceDecs_decode_56_bmi2_adjust_test_temp_valid

sequenceDecs_decode_56_bmi2_adjust_two:
	MOVQ R12, R13
	JMP  sequenceDecs_decode_56_bmi2_adjust_test_temp_valid

sequenceDecs_decode_56_bmi2_adjust_three:
	LEAQ -1(R10), R13

sequenceDecs_decode_56_bmi2_adjust_test_temp_valid:
	TESTQ R13, R13
	JNZ   sequenceDecs_decode_56_bmi2_adjust_temp_valid
	MOVQ  $0x00000001, R13

sequenceDecs_decode_56_bmi2_adjust_temp_valid:
	CMPQ    CX, $0x01
	CMOVQNE R11, R12
	MOVQ    R10, R11
	MOVQ    R13, R10
	MOVQ    R13, CX

sequenceDecs_decode_56_bmi2_adjust_end:
	MOVQ CX, 16(R9)

	// Check values
	MOVQ  8(R9), R13
	MOVQ  (R9), R14
	LEAQ  (R13)(R14*1), R15
	MOVQ  s+0(FP), BP
	ADDQ  R15, 256(BP)
	MOVQ  ctx+16(FP), R15
	SUBQ  R14, 128(R15)
	CMPQ  R13, $0x00020002
	JA    sequenceDecs_decode_56_bmi2_error_match_len_too_big
	TESTQ CX, CX
	JNZ   sequenceDecs_decode_56_bmi2_match_len_ofs_ok
	TESTQ R13, R13
	JNZ   sequenceDecs_decode_56_bmi2_error_match_len_ofs_mismatch

sequenceDecs_decode_56_bmi2_match_len_ofs_ok:
	ADDQ $0x18, R9
	MOVQ ctx+16(FP), CX
	DECQ 96(CX)
	JNS  sequenceDecs_decode_56_bmi2_main_loop
	MOVQ s+0(FP), CX
	MOVQ R10, 144(CX)
	MOVQ R11, 152(CX)
	MOVQ R12, 160(CX)
	MOVQ br+8(FP), CX
	MOVQ AX, 32(CX)
	MOVB DL, 40(CX)
	MOVQ BX, 24(CX)

	// Return success
	MOVQ $0x00000000, ret+24(FP)
	RET

	// Return with match length error
sequenceDecs_decode_56_bmi2_error_match_len_ofs_mismatch:
	MOVQ $0x00000001, ret+24(FP)
	RET

	// Return with match too long error
sequenceDecs_decode_56_bmi2_error_match_len_too_big:
	MOVQ $0x00000002, ret+24(FP)
	RET

// func sequenceDecs_executeSimple_amd64(ctx *executeAsmContext) bool
// Requires: SSE
TEXT ·sequenceDecs_executeSimple_amd64(SB), $8-9
	MOVQ  ctx+0(FP), DI
	MOVQ  8(DI), CX
	TESTQ CX, CX
	JZ    empty_seqs
	MOVQ  (DI), AX
	MOVQ  24(DI), DX
	MOVQ  32(DI), BX
	MOVQ  40(DI), SI
	MOVQ  80(DI), SI
	MOVQ  104(DI), R8
	MOVQ  120(DI), R9
	MOVQ  56(DI), R10
	MOVQ  64(DI), DI
	ADDQ  DI, R10

	// seqsBase += 24 * seqIndex
	LEAQ (DX)(DX*2), R11
	SHLQ $0x03, R11
	ADDQ R11, AX

	// outBase += outPosition
	ADDQ R8, BX

main_loop:
	MOVQ (AX), R13
	MOVQ 8(AX), R11
	MOVQ 16(AX), R12

	// Copy literals
	TESTQ R13, R13
	JZ    check_offset
	XORQ  R14, R14

copy_1:
	MOVUPS (SI)(R14*1), X0
	MOVUPS X0, (BX)(R14*1)
	ADDQ   $0x10, R14
	CMPQ   R14, R13
	JB     copy_1
	ADDQ   R13, SI
	ADDQ   R13, BX
	ADDQ   R13, R8

	// Malformed input if seq.mo > t+len(hist) || seq.mo > s.windowSize)
check_offset:
	LEAQ (R8)(DI*1), R13
	CMPQ R12, R13
	JG   error_match_off_too_big
	CMPQ R12, R9
	JG   error_match_off_too_big

	// Copy match from history
	MOVQ  R12, R13
	SUBQ  R8, R13
	JLS   copy_match
	MOVQ  R10, R14
	SUBQ  R13, R14
	CMPQ  R11, R13
	JGE   copy_all_from_history
	XORQ  R12, R12
	TESTQ $0x00000001, R11
	JZ    copy_4_word
	MOVB  (R14)(R12*1), R13
	MOVB  R13, (BX)(R12*1)
	ADDQ  $0x01, R12

copy_4_word:
	TESTQ $0x00000002, R11
	JZ    copy_4_dword
	MOVW  (R14)(R12*1), R13
	MOVW  R13, (BX)(R12*1)
	ADDQ  $0x02, R12

copy_4_dword:
	TESTQ $0x00000004, R11
	JZ    copy_4_qword
	MOVL  (R14)(R12*1), R13
	MOVL  R13, (BX)(R12*1)
	ADDQ  $0x04, R12

copy_4_qword:
	TESTQ $0x00000008, R11
	JZ    copy_4_test
	MOVQ  (R14)(R12*1), R13
	MOVQ  R13, (BX)(R12*1)
	ADDQ  $0x08, R12
	JMP   copy_4_test

copy_4:
	MOVUPS (R14)(R12*1), X0
	MOVUPS X0, (BX)(R12*1)
	ADDQ   $0x10, R12

copy_4_test:
	CMPQ R12, R11
	JB   copy_4
	ADDQ R11, R8
	ADDQ R11, BX
	ADDQ $0x18, AX
	INCQ DX
	CMPQ DX, CX
	JB   main_loop
	JMP  loop_finished

copy_all_from_history:
	XORQ  R15, R15
	TESTQ $0x00000001, R13
	JZ    copy_5_word
	MOVB  (R14)(R15*1), BP
	MOVB  BP, (BX)(R15*1)
	ADDQ  $0x01, R15

copy_5_word:
	TESTQ $0x00000002, R13
	JZ    copy_5_dword
	MOVW  (R14)(R15*1), BP
	MOVW  BP, (BX)(R15*1)
	ADDQ  $0x02, R15

copy_5_dword:
	TESTQ $0x00000004, R13
	JZ    copy_5_qword
	MOVL  (R14)(R15*1), BP
	MOVL  BP, (BX)(R15*1)
	ADDQ  $0x04, R15

copy_5_qword:
	TESTQ $0x00000008, R13
	JZ    copy_5_test
	MOVQ  (R14)(R15*1), BP
	MOVQ  BP, (BX)(R15*1)
	ADDQ  $0x08, R15
	JMP   copy_5_test

copy_5:
	MOVUPS (R14)(R15*1), X0
	MOVUPS X0, (BX)(R15*1)
	ADDQ   $0x10, R15

copy_5_test:
	CMPQ R15, R13
	JB   copy_5
	ADDQ R13, BX
	ADDQ R13, R8
	SUBQ R13, R11

	// Copy match from the current buffer
copy_match:
	TESTQ R11, R11
	JZ    handle_loop
	MOVQ  BX, R13
	SUBQ  R12, R13

	// ml <= mo
	CMPQ R11, R12
	JA   copy_overlapping_match

	// Copy non-overlapping match
	XORQ R12, R12

copy_2:
	MOVUPS (R13)(R12*1), X0
	MOVUPS X0, (BX)(R12*1)
	ADDQ   $0x10, R12
	CMPQ   R12, R11
	JB     copy_2
	ADDQ   R11, BX
	ADDQ   R11, R8
	JMP    handle_loop

	// Copy overlapping match
copy_overlapping_match:
	XORQ R12, R12

copy_slow_3:
	MOVB (R13)(R12*1), R14
	MOVB R14, (BX)(R12*1)
	INCQ R12
	CMPQ R12, R11
	JB   copy_slow_3
	ADDQ R11, BX
	ADDQ R11, R8

handle_loop:
	ADDQ $0x18, AX
	INCQ DX
	CMPQ DX, CX
	JB   main_loop

loop_finished:
	// Return value
	MOVB $0x01, ret+8(FP)

	// Update the context
	MOVQ ctx+0(FP), AX
	MOVQ DX, 24(AX)
	MOVQ R8, 104(AX)
	MOVQ 80(AX), CX
	SUBQ CX, SI
	MOVQ SI, 112(AX)
	RET

error_match_off_too_big:
	// Return value
	MOVB $0x00, ret+8(FP)

	// Update the context
	MOVQ ctx+0(FP), AX
	MOVQ DX, 24(AX)
	MOVQ R8, 104(AX)
	MOVQ 80(AX), CX
	SUBQ CX, SI
	MOVQ SI, 112(AX)
	RET

empty_seqs:
	// Return value
	MOVB $0x01, ret+8(FP)
	RET
