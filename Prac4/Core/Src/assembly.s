/*
 * assembly.s
 *
 */
 
 @ DO NOT EDIT
	.syntax unified
    .text
    .global ASM_Main
    .thumb_func

@ DO NOT EDIT
vectors:
	.word 0x20002000
	.word ASM_Main + 1

@ DO NOT EDIT label ASM_Main
ASM_Main:

	@ Some code is given below for you to start with
	LDR R0, RCC_BASE  		@ Enable clock for GPIOA and B by setting bit 17 and 18 in RCC_AHBENR
	LDR R1, [R0, #0x14]
	LDR R2, AHBENR_GPIOAB	@ AHBENR_GPIOAB is defined under LITERALS at the end of the code
	ORRS R1, R1, R2
	STR R1, [R0, #0x14]

	LDR R0, GPIOA_BASE		@ Enable pull-up resistors for pushbuttons
	MOVS R1, #0b01010101
	STR R1, [R0, #0x0C]
	LDR R1, GPIOB_BASE  	@ Set pins connected to LEDs to outputs
	LDR R2, MODER_OUTPUT
	STR R2, [R1, #0]
	MOVS R2, #0         	@ NOTE: R2 will be dedicated to holding the value on the LEDs

@ TODO: Add code, labels and logic for button checks and LED patterns

@ Initialize variables
MOVS R4, #0      @ R4 will hold the LED count
MOVS R5, #1      @ R5 will hold the increment value
LDR R6, LONG_DELAY_CNT  @ R6 will hold the current delay count

main_loop:
    @ Read switch state
    LDR R0, GPIOA_BASE
    LDR R3, [R0, #0x10]  @ Read input data register
    MVNS R3, R3          @ Invert because buttons are active-low
    MOVS R7, #0xF
    ANDS R3, R3, R7      @ Mask to get only the first 4 bits (SW0-SW3)

    @ Check SW2 (bit 2)
    MOVS R7, #4
    ANDS R7, R3
    BEQ check_sw3
    MOVS R2, #0xAA       @ Set LED pattern to 0xAA
    B write_leds

check_sw3:
    @ Check SW3 (bit 3)
    MOVS R7, #8
    ANDS R7, R3
    BNE write_leds    @ If SW3 is pressed, skip updating LEDs (freeze)

check_sw0_sw1:
    @ Check SW0 (bit 0) for increment value
    MOVS R7, #1
    ANDS R7, R3
    BEQ sw0_not_pressed
    MOVS R5, #2         @ If SW0 pressed, increment by 2
    B check_sw1
sw0_not_pressed:
    MOVS R5, #1         @ If SW0 not pressed, increment by 1

check_sw1:
    @ Check SW1 (bit 1) for delay value
    MOVS R7, #2
    ANDS R7, R3
    BEQ sw1_not_pressed
    LDR R6, SHORT_DELAY_CNT  @ If SW1 pressed, use short delay
    B update_leds
sw1_not_pressed:
    LDR R6, LONG_DELAY_CNT   @ If SW1 not pressed, use long delay

update_leds:
update_leds:
    @ Increment LED count
    ADDS R4, R4, R5
    MOVS R2, R4          @ Move LED count to R2 for display

write_leds:
    STR R2, [R1, #0x14]  @ Write to LEDs

    @ Delay loop
    MOVS R7, R6
delay_loop:
    SUBS R7, #1
    BNE delay_loop

    B main_loop

@ LITERALS; DO NOT EDIT
	.align
RCC_BASE: 			.word 0x40021000
AHBENR_GPIOAB: 		.word 0b1100000000000000000
GPIOA_BASE:  		.word 0x48000000
GPIOB_BASE:  		.word 0x48000400
MODER_OUTPUT: 		.word 0x5555

@ TODO: Add your own values for these delays
LONG_DELAY_CNT: .word 700000   @ Approximately 0.7 seconds at 8 MHz
SHORT_DELAY_CNT: .word 300000  @ Approximately 0.3 seconds at 8 MHz
