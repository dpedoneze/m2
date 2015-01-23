 .org    0x20
  
    rdctl et, ipending
    beq   et, r0, OTHER_EX
    subi  ea, ea, 4
    
    andi  r13, et, 2
    beq   r13, r0, OTHER_INT
    call  EXT_IRQ1
  OTHER_INT:
    br END_HANDLER
  OTHER_EX:
    br END_HANDLER
  END_HANDLER:
    eret
    
  .org 0x100
  EXT_IRQ1:
    ldwio r3, 0(r4)   # le valor do switch
    add   r5, r5, r3  # adiciona r3 em acumulador r5
    stwio r5, 0(r6)   # salva valor de r5 nos leds
    #aqui vai salvar no 7-seg
    movia r10, CODE_TABLE #move addr da tablea
    ldb  r11, 0(r10)       #le valor da tabela em r11 (HEX) - falta offset
    stwio r11, 0(r12)
    stwio r0, 0(r8)       #zera interrupcao do pushb
    ret
    
  .global _start
  .global CODE_TABLE
  _start:
    mov   r3, r0 #zera temp
    mov   r4, r0 #zera enderecador
    mov   r5, r0 #zera acumulador
    mov   r7, r0 #zera interrup pushbutton addr
    mov   r9, r0 #zera rAux
    mov   r12,r0 #zera
    movia r4, 0x10000040 #setta endereco switches
    movia r6, 0x10000010 #setta endereco g-leds
    movia r8, 0x1000005C #setta end de int do pushb
    movia r7, 0x10000058 #seta endereco de hab int do pushb
    movia r12,0x10000020 #7-dig addr
    
  #PIE do rStatus = 1 para aceitar interrup
    addi  r9,r0,0x01
    wrctl status, r9
  #bit 2 do r em ienable = 1 para habilitar interrup do btn
    mov   r9, r0
    addi  r9,r0,0x02
    wrctl ienable, r9
  #bit 1..3 do pushb = 1 para hab interr do btn
    stwio r9, 0(r7)
    END:
    br END
    
  CODE_TABLE:
  .byte 3F
  # TODO: finish lookup-table
  #lookup-table
  #0000 0011 1111 3F
  #0001 0000 0110 06
  #0010 0101 1011 5B
  #0011 0100 1111 4F
  #0100 0110 0110 66
  #0101 0110 1101 6D
  #0110 0111 1101 7D
  #0111 0000 0111 07
  #1000 0111 1111 7F
  #1001 0110 0111 67
