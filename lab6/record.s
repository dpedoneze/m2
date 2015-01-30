.global RECORD

.equ    SEG, 1
.equ  AUDIO_ADDR,    0x10003040

RECORD:
  movia r8,  AUDIO_ADDR
  movia r15, 0x04
  stwio r15, (r8)           # habilita limpeza de buffer
  movia r15, 0x00
  stwio r15, (r8)           # desabilita limpeza de buffer
  movia r16, SAMPLES        # inicializa com inicio array
  movia r11, 0x00
  movia r14, 96000*SEG
  
  WHILE:
    ldwio r9,  4(r8)        # carrega fifospace register
    andi  r10, r9, 0xFFFF   # mascara para pegar RARC e RALC
    beq   r10, r0, WHILE
    
    ldwio r9,  8(r8)        # carrega leftdata register
    stw   r9,  0(r16)       # salva no array (pos r12) o valor de r9 (leftdata)
    ldwio r9,  12(r8)       # carrega rightdata register
    stw   r9,  4(r16)       # salva no array (pos12) o valor de r9 (rightdata)
    addi  r16, r16,  0x08   # incrementa o array em 0x08
    addi  r11, r11, 1       # incrementa counter +1
    blt   r11, r14, WHILE
ret

.end
