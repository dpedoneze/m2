.global PLAYBACK

.equ    SEG, 1
.equ  AUDIO_ADDR,    0x10003040

PLAYBACK:
  movia r8,  AUDIO_ADDR
  movia r15, 0x08
  stwio r15, (r8)           # habilita limpeza de buffer
  movia r15, 0x00
  stwio r15, (r8)           # desabilita limpeza de buffer
  movia r17, SAMPLES        # inicializa com inicio array
  movia r11, 0x00
  movia r14, 96000*SEG
  
  WHILE:
    ldwio r9,  4(r8)        # carrega fifospace register
    andhi r10, r9, 0xFFFF   # mascara para pegar WSLC e WSRC
    beq   r10, r0, WHILE
    
    ldw   r9,  0(r17)       # carrego valor do array em r9
    stwio r9,  8(r8)        # salvo valor do array em leftdata
    ldw   r9,  4(r17)       # carrego valor do array+4 em r9
    stwio r9,  12(r8)       # salvo valor do array+4 em rightdata
    addi  r17, r17, 0x08    # incrementa o array em 0x02
    addi  r11, r11, 1       # incrementa counter +1
    blt  r11, r14, WHILE
ret

.end
