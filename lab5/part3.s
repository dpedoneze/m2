# NIOS 2 

.equ     TEMP_ADDR, 0x10002000
.equ     UART_ADDR, 0x10001000


.org    0x20
    rdctl et, ipending
    beq   et, r0, OTHER_EX
    subi  ea, ea, 4
   
    andi  r13, et, 1
    beq   r13, r0, OTHER_INT
    call  EXT_IRQ0

  OTHER_INT:
    br END_HANDLER
  OTHER_EX:
    br END_HANDLER
  END_HANDLER:
    eret
   
.org 0x100
  EXT_IRQ0:
    ldwio r4, 0(r20)
    andi  r4, r4, 0xFF
    stwio r4, 0(r20)    
    addi  r9, r0, 0x00
    stwio r9, 0(r2)
    ret
    
.global _start
_start:
    movia    r2,  TEMP_ADDR
    movia   r20, UART_ADDR
    movia    r8,  25000000
  
  # PIE do rStatus = 1 para aceitar interrup

    addi  r9,r0,0x01
    wrctl status, r9
    
  # bit 1 do r em ienable = 1 para habilitar interrup do temporizador
    addi  r9,r0,0x01
    wrctl ienable, r9
    
  # carrega o counter do temporizador
    andi  r10, r8, 0xFFFF
    stwio r10, 8(r2)
    srli  r10, r8, 16
    stwio r10, 12(r2)
    
  # bit 1 do pushb = 1 para hab interr do temporizador
    addi  r9, r0, 0x07
    stwio r9, 4(r2)
    
  WAIT:
    ldwio r3, 0(r20) # le valor do Control register
    andi  r4, r3, 0b00000000000000001000000000000000
    beq      r4, r0, WAIT

    # ldwio r4, 0(r20)
    andi  r3, r3, 0b00000000000000000000000011111111
    stwio r3, 0(r20)    

    br WAIT
    
.end
