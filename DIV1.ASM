message macro msg							;declaring macro 
mov ah,09h
lea dx,msg
int 21h
endm

.model small

.data
n1 dw 0000h
n2 dw 0000h
n3 dw 0000h
m1 db 0Ah,0Dh,"Enter first number $"
m2 db 0Ah,0Dh,"Enter second number $"
m3 db 0Ah,0Dh,"The quotient is $"
m4 db 0Ah,0Dh,"The remainder is $"

.code
mov ax,@data
mov ds,ax

message m1                                  ;calling macro m1(Enter first number)
call accept									;calling accept procedure
ror al,04h									;rotating the number to get it on ten's place of bh
mov bh,al									;TENS PLACE OF BH

call accept				
add bh,al									;BH FILLED

call accept
ror al,04h									;rotating al to get ten's place of bl
mov bl,al									;TENS PLACE OF BL

call accept
add bl,al									;BL FILLED     

mov n1,bx									;BX MOVED TO N1(1ST PART OF 32 BIT NUMBER)
											;(2ND PART OF NUMBER TO BE ACCEPTED NOW)

call accept									;calling accept procedure
ror al,04h									;rotating the number to get it on ten's place of bh
mov bh,al									;TENS PLACE OF BH

call accept				
add bh,al									;BH FILLED

call accept
ror al,04h									;rotating al to get ten's place of bl
mov bl,al									;TENS PLACE OF BL

call accept
add bl,al									;BL FILLED     

mov n2,bx									;BX MOVED TO N2
											;32 BIT NUMBER(8 DIGITS) IS N1+N2
											;2ND NUMBER (16BIT) (4 DIGITS)

message m2									;calling macro(Enter second number)
call accept									;calling accept procedure
ror al,04h									;rotating the number to get it on ten's place of bh
mov bh,al									;TENS PLACE OF BH

call accept				
add bh,al									;BH FILLED

call accept
ror al,04h									;rotating al to get ten's place of bl
mov bl,al									;TENS PLACE OF BL

call accept
add bl,al									;BL FILLED     

mov n3,bx									;BX MOVED TO N3

mov dx,n1									;moving n1 in dx
mov ax,n2									;moving n2 in ax
div n3										;divide them by n3

mov n1,ax									;moving quotient in n1
mov n2,dx									;moving remainder in n2

message m3									;Displaying the quotient now
mov cx,n1									;moving quotient in cx register 
mov bh,cl									;moving cl to bh to use it later

mov bl,ch									;moving ch to bl to print it first
ror bl,4									;in bl print the tens place first
call disp

ror bl,4									;in bl print the units place 
call disp

mov bl,bh									;printing bh now
ror bl,4									;printing tens place of bh first
call disp

ror bl,4									;printing units place of bh 
call disp

message m4									;printing remainder
mov cx,n2									;same procedure as done for quotient
mov bh,cl

mov bl,ch
ror bl,4
call disp

ror bl,4
call disp

mov bl,bh
ror bl,4
call disp

ror bl,4
call disp

mov ah,4ch
int 21h

accept proc near        					;defining the procedure accept
mov ah,01h               					;accepting one digit in al register
int 21h
cmp al,3Ah               					;comapring the ascii value of digit with 3A
JC down1                 					;If no.<3A CF=1 -> skip till down1
											;If no.>3A CF=0 -> execute all instructions 
sub AL,07h              					;If no.>3A, subtract 07 from it to get for eg. 3B from 42
down1:and al,0Fh         					;Anding the obtained number/ascii value with 0F to get the original digit entered 
ret                      					;return back to the code segment to execute next instruction 
endp                     					;Procedure end

disp proc near
mov cl,bl                					;Moving the number to cl register to retain it in bl register after operations done in cl register
and cl,0Fh               					;Getting the digit at ones place
cmp cl,0Ah               					;comparing it with 0A
JC down2                 					;If no.>0A CF=0 -> execute all instructions
											;If no.<0A CF=1 -> skip till down2
Add cl,07h               					;adding 07 to the number
down2: add cl,30h        					;adding 30 to the number to obtain its ascii value
mov dl,cl                					;moving the obtained ascii value in dl register
mov ah,02h               					;displaying data in dl register
int 21h
ret                      					;returning to the code segment to execute further instuctions
endp                     					;end of procedure
end





