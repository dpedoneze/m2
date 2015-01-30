.equ  BTN_ADDR,     0x10000050
.equ  AUDIO_ADDR,   0x10003040
.equ  SEG, 1   

.global SAMPLES
.global _start
_start:
    movia r2,  BTN_ADDR
    movia r3,  AUDIO_ADDR
  
  WAIT:
    ldwio r4, 12(r2)
    andi  r5, r4, 0x02      # mascara para pegar key1
    bne   r5, r0, CALLREC 
    andi  r5, r4, 0x04      # mascara para pegar key2
    bne   r5, r0, CALLPLAY
    beq   r5, r0, WAIT

  CALLREC:
    call RECORD
    stwio r0, 12(r2)
    br WAIT
  
  CALLPLAY:
    call PLAYBACK
    stwio r0, 12(r2)
    br WAIT


SAMPLES:
  .skip 96000*SEG*4*2       # freq de amostras x SEG x 4 bits registrador x 2 canais

.end
