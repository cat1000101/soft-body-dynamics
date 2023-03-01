IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
	length_of_points dw 0
	temp_integer dw 0
	temp_float dd 0
	mass dd 0.1
	gravity dd 10.0

	xp dd 0
	dd 100 dup(?)
	pxp dd 0
	dd 100 dup(?)
	xf dd 0
	dd 100 dup(0)
	xv dd 0
	dd 100 dup(0)
	xa dd 0
	dd 100 dup(0)
	yp dd 0
	dd 100 dup(?)
	pyp dd 0
	dd 100 dup(?)
	yf dd 0
	dd 100 dup(0)
	yv dd 0
	dd 100 dup(0)
	ya dd 0
	dd 100 dup(0)

	spring1 dw 0ffffh
	dw 100 dup(0ffffh)
	spring2 dw 0ffffh
	dw 100 dup(0ffffh)
	spring3 dw 0ffffh
	dw 100 dup(0ffffh)
	spring4 dw 0ffffh
	dw 100 dup(0ffffh)
	spring5 dw 0ffffh
	dw 100 dup(0ffffh)
	spring6 dw 0ffffh
	dw 100 dup(0ffffh)
	spring7 dw 0ffffh
	dw 100 dup(0ffffh)
	spring8 dw 0ffffh
	dw 100 dup(0ffffh)
; --------------------------
;hello world
CODESEG
;=====================================================================================================
proc spring1_proc
	xor ax,ax
	xor bx,bx
	xor dx,dx
	xor si,si


	ret
endp spring1_proc
;=====================================================================================================
;[bp+4] = x numbers of points in the x direction
;[bp+6] = y numbers of points in the y direction
;[bp+8] = x_position in dataseg
;[bp+10] = y_position in dataseg
;[bp+12] = spring8 the list of springs in diffrent dirrection
;[bp+14] = spring7 the list of springs in diffrent dirrection
;[bp+16] = spring6 the list of springs in diffrent dirrection
;[bp+18] = spring5 the list of springs in diffrent dirrection
;[bp+20] = spring4 the list of springs in diffrent dirrection
;[bp+22] = spring3 the list of springs in diffrent dirrection
;[bp+24] = spring2 the list of springs in diffrent dirrection
;[bp+26] = spring1 the list of springs in diffrent dirrection
proc make_squre
	push bp
	mov bp,sp

	push ax
	push bx
	push cx
	push si
	push di
	push dx
	; --------------------------
	xor dx,dx
	xor ax,ax
	mov cx,[bp+6]
	mov si,[bp+8] ;xp
	mov di,[bp+10] ;yp
	mov bx,160
	mov al,[bp+4]
	mov dx,3
	mul dx
	sub bx,ax
	mov dx,bx
	mov ax,dx
	mov bx,160
	
	y_position_loop:
	push cx
	mov cx,[bp+4]
	x_position_loop:
	mov [si],ax
	mov [di],bx
	;make the numbers to flaot numbers
	fild [word ptr si]
	fstp [dword ptr si]
	fild [word ptr di]
	fstp [dword ptr di]

	add si,4
	add di,4
	add ax,6
	loop x_position_loop
	pop cx
	mov ax,dx
	sub bx,6
	loop y_position_loop

	xor ax,ax
	xor bx,bx
	xor dx,dx
	xor si,si
	mov cx,[length_of_points]
	mov ax,[bp+4]
	mov bx,4
	mul bx
	mov [bp+4],ax
	spring_lop:

	cmp si,[bp+4]
	ja spring1_not_ok
	mov ax,[bp+4]
	xor dx,dx
	div si
	cmp ax,0
	je spring1_not_ok
	mov ax,[bp+4]
	mov bx,4
	mul ax
	mov dx,si
	sub dx,ax
	sub dx,4
	mov di,offset spring1
	mov [di],dx
	spring1_not_ok:

	cmp si,[bp+4]
	ja spring2_not_ok
	mov ax,[bp+4]
	mov bx,4
	mul ax
	mov dx,si
	sub dx,ax
	mov di,offset spring2
	mov [di],dx
	spring2_not_ok:

	cmp si,[bp+4]
	ja spring3_not_ok
	mov ax,[bp+4]
	xor dx,dx
	div si
	mov dx,[bp+4]
	sub dx,4
	cmp ax,dx
	je spring3_not_ok
	mov ax,[bp+4]
	mov bx,4
	mul ax
	mov dx,si
	sub dx,ax
	add dx,4
	mov di,offset spring3
	mov [di],dx
	spring3_not_ok:

;not good
	mov ax,[bp+4]
	xor dx,dx
	div si
	mov dx,[bp+4]
	dec dx
	cmp ax,dx
	je spring4_ok
	jmp spring4_not_ok
	spring4_ok:
	mov di,offset spring4
	mov [di],si
	spring4_not_ok:



	add si,4
	loop spring_lop 


	; --------------------------
	pop dx
	pop di
	pop si
	pop cx
	pop bx
	pop ax
	pop bp
	ret 24
endp make_squre

;=====================================================================================================

proc draw
	push bp
	mov bp,sp

	push ax
	push bx
	push cx
	push dx
	push si
	push di
	; --------------------------
	mov cx,[length_of_points]
	mov di,offset xp
	mov si,offset yp
	draw_loop:
	xor ax,ax
	xor bx,bx
	xor dx,dx
	fld [dword ptr si]
	frndint
	fistp [word ptr temp_integer]
	mov bx,[word ptr temp_integer]

	mov ax,200
	sub ax,bx
	mov bx,320
	mul bx
	xor bx,bx
	fld [dword ptr di]
	frndint
	fistp [word ptr temp_integer]
	mov bx,[word ptr temp_integer]
	add bx,ax
	mov [byte ptr es:bx],4
	add di,4
	add si,4
	loop draw_loop


	; --------------------------
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 
endp draw

;=====================================================================================================
start:
	mov ax, @data
	mov ds, ax
    mov ax, 0a000h
    mov es, ax
    ; Graphic mode
	mov ax, 13h
	int 10h
; --------------------------

;[bp+4] = x numbers of points in the x direction
;[bp+6] = y numbers of points in the y direction
;[bp+8] = x_position in dataseg
;[bp+10] = y_position in dataseg
	xor ax,ax
	mov al,5
	mov bl,5
	mul bl
	mov [length_of_points],ax


	push offset spring1
	push offset spring2
	push offset spring3
	push offset spring4
	push offset spring5
	push offset spring6
	push offset spring7
	push offset spring8
	push offset yp
	push offset xp
	push 5
	push 5
	call make_squre
	call draw




mov ah,1
int 21h
; --------------------------
    ; Return to text mode
	mov ah, 0
	mov al, 2
	int 10h
exit:
	mov ax, 4c00h
	int 21h
END start


