mess macro msg
mov ah,09h
lea dx,msg
int 21h
 
.model small

.data
msg1 db 0ah,0dh,"MENU -$"                                  ;0ah moves cursor to the next line
msg2 db 0ah,0dh,"1.ADDITION -$"                            ;0dh moves cursor to beginning of the current row
msg3 db 0ah,0dh,"2.SUBTRACTION -$"
msg4 db 0ah,0dh,"3.MULTIPLICATION -$"
msg5 db 0ah,0dh,"ENTER YOUR CHOICE -$"
msg6 db 0ah,0dh,"ENTER FIRST NUMBER -$"
msg7 db 0ah,0dh,"ENTER SECOND NUMBER -$"
msg8 db 0ah,0dh,"THE ADDITION IS -$"
msg9 db 0ah,0dh,"THE SUBTRACTION IS -$"
msg10 db 0ah,0dh,"THE MULTIPLICATION IS -$"

n1 db 00h
n2 dw 0000h

.code
mov ax,@data
mov ds,ax

mess msg1
mess msg2
mess msg3
mess msg4
mess msg5
mov ah,01h
int 21h

cmp al,31h
jne ch1

call addition
jmp ch3

ch1: cmp al,32h
	 jne ch2
	 
	 call subtraction 
	 jmp ch3
	 
ch2: cmp al,33h
	 jne ch3
	 
	 call multiplication
	 jmp ch3
	 
	 
ch3: mov ah,4ch
	 int 21h
	 
accept proc near
mov ah,01h               ;accepting one digit in al register
int 21h
cmp al,3Ah               ;comapring the ascii value of digit with 3A
JC down1                 ;If no.<3A CF=1 -> skip till down1
                         ;If no.>3A CF=0 -> execute all instructions 
sub AL,07h               ;If no.>3A, subtract 07 from it to get for eg. 3B from 42
down1:and al,0Fh         ;Anding the obtained number/ascii value with 0F to get the original digit entered 
ret                      ;return back to the code segment to execute next instruction 
endp   

display1 proc near
mov cl,bl                ;Moving the number to cl register to retain it in bl register after operations done in cl register
and cl,0Fh               ;Getting the digit at ones place
cmp cl,0Ah               ;comparing it with 0A
JC down2                 ;If no.>0A CF=0 -> execute all instructions
                         ;If no.<0A CF=1 -> skip till down2
Add cl,07h               ;adding 07 to the number
down2: add cl,30h        ;adding 30 to the number to obtain its ascii value
mov dl,cl                ;moving the obtained ascii value in dl register
mov ah,02h               ;displaying data in dl register
int 21h
ret                      ;returning to the code segment to execute further instuctions
endp                     ;end of procedure

addition proc near

mess msg6
call accept				;accepting 1st number ten's place
ror al,4
mov bl,al

call accept				;accepting 1st number unit's place
add bl,al

mess msg7
call accept				;accepting 2nd number ten's place
ror al,4
mov cl,al

call accept				;accepting 2nd number unit's place
add cl,al     
	 
add bl,cl				;add bl and cl and store in bl
mess msg8
mov n1,bl

ror bl,4
call display1			;displaying ten's place of result

mov bl,n1
call display1			;displaying unit's place of result

ret
endp

subtraction proc near

mess msg6
call accept				;accepting 1st number tens place
ror al,4
mov bl,al

call accept				;accepting 1st number unit's place
add bl,al

mess msg7
call accept				;accepting 2nd number tens place
ror al,4
mov cl,al

call accept				;accepting 2nd number unit's place
add cl,al     
	 
sub bl,cl				;subtracting cl from bl and saving result in bl
mess msg9
mov n1,bl

ror bl,4
call display1			;displaying ten's place of result

mov bl,n1
call display1			;displaying unit's place of result

ret
endp

multiplication proc near

mess msg6
call accept				;accepting 1st number ten's place
ror al,4
mov bl,al

call accept				;accepting 1st number unit's place
add bl,al

mess msg7
call accept				;accepting 2nd number ten's place
ror al,4
mov cl,al

call accept				;accepting 2nd number unit's place
add cl,al 

mov al,bl
mul cl					;multiplying al and cl and storing result in ax

mov n2,ax
mov bx,ax

mess msg10


mov bl,bh
ror bl,4
call display1			;displaying thousand's place of result

mov bx,n2
mov bl,bh
call display1			;displaying hundred's place of result

mov bx,n2
ror bl,4
call display1			;displaying ten's place of result

mov bx,n2
call display1			;displaying unit's place of result

ret 
endp
end




