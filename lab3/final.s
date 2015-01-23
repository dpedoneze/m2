.equ TEST_NUM, 0xAAA    /*  The number to be tested */

.global _start
_start:
  movia r8, TEST_NUM        /* Load r8 with the number to be tested */
  mov   r9, r8            /* Copy the number to r9 */
  mov   r12, r0     /* clear r12 */
  mov   r13, r0     /* clear r13 */
  mov   r14, r0     /* clear r14 - used as subroutine counter */
  mov   r17, r0
  mov   r18, r0
  mov   r19, r0
  addi  r18, r18, 0b01
  addi  r17, r17, 0b10
  addi  r12, r12, 0x555 /* add xor mask to r12 */
  addi  r13, r13, 0xAAA /* add xor mask2 to r13 */
  
  xor   r8, r8, r13
  mov   r19, r8
  br    STRING_COUNTER

XOR2:  
  xor   r9, r9, r12 /* apply xor mask to r9 */
  mov   r19, r9
  
STRING_COUNTER:
  mov    r10, r0            /* Clear the counter to zero */
STRING_COUNTER_LOOP:                
  beq   r19, r0, END_STRING_COUNTER  /* Loop until r9 contains no more 1s   */
  srli  r11, r19, 0x01        /* Calculate the number of 1s by shifting the number */
  and   r19, r19, r11            /*    and ANDing it with the shifted result          */
  addi  r10, r10, 0x01        /* Increment the counter */
  br    STRING_COUNTER_LOOP
END_STRING_COUNTER:
  beq   r14, r18, ADD_2
  mov   r16, r10
  addi  r14, r14, 0x01
  br    XOR2
ADD_2:
  mov   r17, r10

  bgt   r16, r17, END /* se r16 > r17 */
  mov   r16, r17  
  
END:
  br    END                /* Wait here when the program has completed */

.end
