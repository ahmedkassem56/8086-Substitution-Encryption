.Model SMALL   ;programm size will be less than or equal to 64k

.STACK  100 ;  size of the stack in  the programm

.DATA   ;beginning of the data segment label


ENC   DB  71h,77h,65h,72h,74h,79h,75h,69h,6Fh,70h,61h,73h,64h,66h,67h,68h,6Ah,6Bh,6Ch,7Ah,78h,63h,76h,62h,6Eh,6Dh

IMSG DB "Enter your input string:$"
EMSG DB "Encrypted:$"
DMSG DB "Decrypted:$"  

EOUT DB 32 dup(0)
DOUT DB 32 dup(0)
OUT_INDX DB 0

NLINE DB 13,10, '$'


buff        db  32        ;MAX NUMBER OF CHARACTERS ALLOWED (32).
            db  ?         ;NUMBER OF CHARACTERS ENTERED BY USER.
            db  32 dup(0) ;CHARACTERS ENTERED BY USER.

.CODE

    MOV AX,@DATA ; we are loading the base adress of . DATA label
                 ; into register AX                           
    MOV DS,AX    ;initialise data segment to the .DATA label
       
main:LEA DX,IMSG   ; offset of the message to DX
    CALL OutString
    
    MOV AH, 0Ah   ; capture string from keyboard
    LEA DX, buff
    INT 21h 
      
    CALL NewLine
    
    MOV CL,buff+1    ; CL = number of entered characters
    MOV CH,0
    
    MOV SI, offset buff+2   ; SI points to the beginning of the input string
    MOV AH,0  
    MOV DI,0         
           
loop1: MOV AL, [si]      ; read the character
       CALL Encrypt
       CALL Decrypt
       INC SI            ; increasing SI to point to the next char 
       INC DI            ; increasing DI to point to the next empty char
       LOOP loop1        ; looping over the string                
    
    ; adding '$' to EOUT and DOUT
    MOV EOUT[DI+1],'$'   
    MOV DOUT[DI+1],'$'
    
    ; printing outputs
    
    LEA DX,EMSG
    CALL OutString
    LEA DX,EOUT 
    CALL OutString 
    
    CALL NewLine
    
    LEA DX,DMSG
    CALL OutString
    LEA DX,DOUT 
    CALL OutString    
    
    CALL NewLine             
    
jmp main   
        
ret
 
PROC Encrypt NEAR
    PUSH AX
    PUSH BX
    SUB AL, 61h       ; index relative to 'a'
    LEA BX, ENC       ; table B contains the encrypted characters
    XLATB             
    MOV EOUT[DI],AL   ; save to memory
    POP BX                   
    POP AX
    RET
ENDP Encrypt

PROC Decrypt NEAR
    PUSH AX
    PUSH CX
    PUSH SI
    
    MOV SI,0
    LEA BX,ENC
    MOV CL,26
    
loop2: CMP ENC[SI], AL
       JE found
       INC SI
       LOOP loop2 
found: MOV AX,SI ; AL = index of the character
       ADD AL,61h ; convert to ASCII (add 'a')
       MOV DOUT[DI],AL
             
    POP SI
    POP CX
    POP AX
    RET
ENDP Encrypt

 
PROC NewLine NEAR
    LEA DX,NLINE
    MOV AH,09H
    INT 21h  
    RET
ENDP NewLine  


PROC OutChar NEAR     ; character is in DL
    MOV AH,02H
    INT 21H 
    RET
ENDP OutChar  

PROC OutString NEAR   ; offset of msg is in DX
    MOV AH,09H
    INT 21H 
    RET
ENDP OutString