.Model SMALL   ;programm size will be less than or equal to 64k

.STACK  100 ;  size of the stack in  the programm

.DATA   ;beginning of the data segment label


ENC   DB  71h,77h,65h,72h,74h,79h,75h,69h,6Fh,70h,61h,73h,64h,66h,67h,68h,6Ah,6Bh,6Ch,7Ah,78h,63h,76h,62h,6Eh,6Dh

IMSG DB "Enter your input string:$"
EMSG DB "Encrypted:$"
DMSG DB "Decrypted:$"  

EOUT DB 32 dup(0)
DOUT DB 32 dup(0)

NLINE DB 13,10, '$'


buff        db  32        ;MAX NUMBER OF CHARACTERS ALLOWED (32).
            db  ?         ;NUMBER OF CHARACTERS ENTERED BY USER.
            db  32 dup(0) ;CHARACTERS ENTERED BY USER.

.CODE

    MOV AX,@DATA ; we are loading the base adress of . DATA label
                 ; into register AX                           
    MOV DS,AX    ;initialise data segment to the .DATA label
       
    LEA DX,IMSG   ; offset of the message to DX
    CALL OutString
    
    MOV AH, 0Ah   ; capture string from keyboard
    LEA DX, buff
    INT 21h 
    
    CALL NewLine  
    LEA DX,EMSG
    CALL OutString   

    MOV CL,buff+1    ; CL = number of entered characters
    MOV CH,0
    
    MOV SI, offset buff+2   ; SI points to the beginning of the input string
    MOV AH,0  
             
; encrypting             
loop1: MOV AL, [si]      ; read the character
       SUB AL, 61h       ; index relative to 'a'
       LEA BX, ENC       ; table B contains the encrypted characters
       ADD BL, AL        ; add index
       MOV DL, [BX]      ; printing encrypted character
       CALL OutChar
       INC si            ; increasing SI to point to the next char
       LOOP loop1        ; looping over the string                
       
; decrypting (assuming that the input text is the encrypted one)  
    
      
    
here: jmp here   
        
ret
 
PROC Encrypt NEAR
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