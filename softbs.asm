IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
	length_of_points dw 0
	length_of_points_times_4 dw 0
	temp_integer dw 0
	temp_float dd 0
	mass dd 0.1
	gravity dd 10.0
;--------------------------
	step_flag dw 0
	

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

	left_x dw 10 dup(0)
	left_y dw 10 dup(0)
	right_x dw 10 dup(0)
	right_y dw 10 dup(0)

	massage_opening db '                                            c                                  ',10,13
	db '                                            c                                  ',10,13
	db '                                            c                                  ',10,13
	db '                                            c                                  ',10,13
	db '                                            c                                  ',10,13
	db '                                            c                                  ',10,13
	db '                                            c                                  ',10,13
	db '                                            c                                  ',10,13
	db '                                            c                                  ',10,13
	db '                                            c                                  ',10,13
	db '                                            c                                  ',10,13
	db '                                            c                                  ',10,13
	db '                                            c                                  ',10,13
	db '                                            c                                  ',10,13
	db '                                            c                                  ',10,13
	db '                                            c                                  ',10,13
	db '                                            c                                  ',10,13
	db '                                            c                                  ',10,13
	db '                                            c                                  ',10,13
	db '                                            c                                  ',10,13
	db '                                            c                                  ',10,13
	db '                                            c                                  ',10,13
	db '                                            c                                  ',10,13,'$'
	
	massage_info db '                                            d                                  ',10,13
	db '                                            d                                  ',10,13
	db '                                            d                                  ',10,13
	db '                                            d                                  ',10,13
	db '                                            d                                  ',10,13
	db '                                            d                                  ',10,13
	db '                                            d                                  ',10,13
	db '                                            d                                  ',10,13
	db '                                            d                                  ',10,13
	db '                                            d                                  ',10,13
	db '                                            d                                  ',10,13
	db '                                            d                                  ',10,13
	db '                                            d                                  ',10,13
	db '                                            d                                  ',10,13
	db '                                            d                                  ',10,13
	db '                                            d                                  ',10,13
	db '                                            d                                  ',10,13
	db '                                            d                                  ',10,13
	db '                                            d                                  ',10,13
	db '                                            d                                  ',10,13
	db '                                            d                                  ',10,13
	db '                                            d                                  ',10,13
	db '                                            d                                  ',10,13,'$'


; --------------------------
;hello world
CODESEG
;=====================================================================================================
;[bp+12] = number of points in the y direction
;[bp+10] = total number of points times 4
;[bp+8] = point
;[bp+6] = number of points in the x direction times 4
;[bp+4] = offset spring1
proc spring1_proc
	push bp
	mov bp,sp
	push ax
	push bx
	push si
	push di
	push dx
	
	mov si,[bp+8]
	cmp si,[bp+6]
	jb spring1_not_ok
	mov bx,[bp+6]
	mov ax,si
	xor dx,dx
	div bx
	cmp dx,0
	je spring1_not_ok
	mov ax,[bp+6]
	sub si,ax
	sub si,4
	mov di,[bp+4]
	mov dx,[bp+14]
	add di,dx
	mov [di],si
	spring1_not_ok:

	pop dx
	pop di
	pop si
	pop bx
	pop ax
	pop bp
	ret 2
endp spring1_proc
;=====================================================================================================
;[bp+12] = number of points in the y direction
;[bp+10] = total number of points times 4
;[bp+8] = point
;[bp+6] = number of points in the x direction times 4
;[bp+4] = offset spring2
proc spring2_proc
	push bp
	mov bp,sp
	push ax
	push bx
	push si
	push di
	push dx

	mov si,[bp+8]
	cmp si,[bp+6]
	jb spring2_not_ok
	mov ax,[bp+6]
	sub si,ax
	mov di,[bp+4]
	mov dx,[bp+14]
	add di,dx
	mov [di],si
	spring2_not_ok:

	pop dx
	pop di
	pop si
	pop bx
	pop ax
	pop bp
	ret 2
endp spring2_proc
;=====================================================================================================
;[bp+12] = number of points in the y direction
;[bp+10] = total number of points times 4
;[bp+8] = point
;[bp+6] = number of points in the x direction times 4
;[bp+4] = offset spring3
proc spring3_proc
	push bp
	mov bp,sp
	push ax
	push bx
	push si
	push di
	push dx

	mov si,[bp+8]
	cmp si,[bp+6]
	jb spring3_not_ok
	mov bx,[bp+6]
	mov ax,si
	xor dx,dx
	div bx
	mov ax,[bp+6]
	sub ax,4
	cmp dx,ax
	je spring3_not_ok
	mov ax,[bp+6]
	sub si,ax
	add si,4
	mov di,[bp+4]
	mov dx,[bp+14]
	add di,dx
	mov [di],si
	spring3_not_ok:


	pop dx
	pop di
	pop si
	pop bx
	pop ax
	pop bp
	ret 2
endp spring3_proc
;=====================================================================================================
;[bp+12] = number of points in the y direction
;[bp+10] = total number of points times 4
;[bp+8] = point
;[bp+6] = number of points in the x direction times 4
;[bp+4] = offset spring4
proc spring4_proc
	push bp
	mov bp,sp
	push ax
	push bx
	push si
	push di
	push dx

	mov si,[bp+8]
	mov bx,[bp+6]
	mov ax,si
	xor dx,dx
	div bx
	mov ax,[bp+6]
	sub ax,4
	cmp dx,ax
	je spring4_not_ok
	add si,4
	mov di,[bp+4]
	mov dx,[bp+14]
	add di,dx
	mov [di],si
	spring4_not_ok:

	pop dx
	pop di
	pop si
	pop bx
	pop ax
	pop bp
	ret 2
endp spring4_proc
;=====================================================================================================
;[bp+12] = number of points in the y direction
;[bp+10] = total number of points times 4
;[bp+8] = point
;[bp+6] = number of points in the x direction times 4
;[bp+4] = offset spring5
proc spring5_proc
	push bp
	mov bp,sp
	push ax
	push bx
	push si
	push di
	push dx

	mov si,[bp+8]
	mov ax,[bp+6]
	mov bx,[bp+12]
	mul bx
	mov bx,ax
	mov ax,[bp+6]
	sub bx,ax
	cmp si,bx
	jnb spring5_not_ok
	mov bx,[bp+6]
	mov ax,si
	xor dx,dx
	div bx
	mov ax,[bp+6]
	sub ax,4
	cmp dx,ax
	je spring5_not_ok
	mov ax,[bp+6]
	add si,ax
	add si,4
	mov di,[bp+4]
	mov dx,[bp+14]
	add di,dx
	mov [di],si
	spring5_not_ok:


	pop dx
	pop di
	pop si
	pop bx
	pop ax
	pop bp
	ret 2
endp spring5_proc
;=====================================================================================================
;[bp+12] = number of points in the y direction
;[bp+10] = total number of points times 4
;[bp+8] = point
;[bp+6] = number of points in the x direction times 4
;[bp+4] = offset spring6
proc spring6_proc
	push bp
	mov bp,sp
	push ax
	push bx
	push si
	push di
	push dx

	mov si,[bp+8]
	mov ax,[bp+6]
	mov bx,[bp+12]
	mul bx
	mov bx,ax
	mov ax,[bp+6]
	sub bx,ax
	cmp si,bx
	jnb spring6_not_ok
	mov ax,[bp+6]
	add si,ax
	mov di,[bp+4]
	mov dx,[bp+14]
	add di,dx
	mov [di],si
	spring6_not_ok:


	pop dx
	pop di
	pop si
	pop bx
	pop ax
	pop bp
	ret 2
endp spring6_proc
;=====================================================================================================
;[bp+12] = number of points in the y direction
;[bp+10] = total number of points times 4
;[bp+8] = point
;[bp+6] = number of points in the x direction times 4
;[bp+4] = offset spring7
proc spring7_proc
	push bp
	mov bp,sp
	push ax
	push bx
	push si
	push di
	push dx

	mov si,[bp+8]
	mov ax,[bp+6]
	mov bx,[bp+12]
	mul bx
	mov bx,ax
	mov ax,[bp+6]
	sub bx,ax
	cmp si,bx
	jnb spring7_not_ok
	mov bx,[bp+6]
	mov ax,si
	xor dx,dx
	div bx
	cmp dx,0
	je spring7_not_ok
	mov ax,[bp+6]
	add si,ax
	sub si,4
	mov di,[bp+4]
	mov dx,[bp+14]
	add di,dx
	mov [di],si
	spring7_not_ok:


	pop dx
	pop di
	pop si
	pop bx
	pop ax
	pop bp
	ret 2
endp spring7_proc
;=====================================================================================================
;[bp+14] = the ideresion of the point
;[bp+12] = number of points in the y direction
;[bp+10] = total number of points times 4
;[bp+8] = point
;[bp+6] = number of points in the x direction times 4
;[bp+4] = offset spring8
proc spring8_proc
	push bp
	mov bp,sp
	push ax
	push bx
	push si
	push di
	push dx

	mov si,[bp+8]
	mov bx,[bp+6]
	mov ax,si
	xor dx,dx
	div bx
	cmp dx,0
	je spring8_not_ok
	sub si,4
	mov di,[bp+4]
	mov dx,[bp+14]
	add di,dx
	mov [di],si
	spring8_not_ok:


	pop dx
	pop di
	pop si
	pop bx
	pop ax
	pop bp
	ret 12
endp spring8_proc
;=====================================================================================================
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
;[bp+28] = offset total number of points times 4
;[bp+30] = offset total number of points
;[bp+32] = offset of pxp
;[bp+34] = offset of pyp
;[bp+36] = random
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
	mov bx,160
	mov al,[bp+4]
	mov dx,3
	mul dx
	sub bx,ax
	mov dx,bx
	mov ax,dx
	mov bx,160
	mov [bp+36],dx
	xor dx,dx
	
	y_position_loop:
	push cx
	mov cx,[bp+4]
	x_position_loop:
	mov si,[bp+8] ;xp
	mov di,[bp+10] ;yp
	add si,dx
	add di,dx
	mov [si],ax
	mov [di],bx
	;make the numbers to flaot numbers
	fild [word ptr si]
	fst [dword ptr si]
	mov si,[bp+32]
	add si,dx
	fstp [dword ptr si]
	fild [word ptr di]
	fst [dword ptr di]
	mov di,[bp+34]
	add di,dx
	fstp [dword ptr di]

	add dx,4
	add ax,6
	loop x_position_loop
	pop cx
	mov ax,[bp+36]
	sub bx,6
	loop y_position_loop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;spring section;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	xor ax,ax
	xor bx,bx
	xor dx,dx
	xor si,si
	mov bx,[bp+30]
	mov cx,[bx]
	mov ax,[bp+4]
	mov bx,4
	mul bx
	mov [bp+4],ax
	xor bx,bx
	mov di,[bp+28]
	spring_lop:

	push bx
	push [bp+6]
	push [di]
	push si
	push [bp+4]

	push [bp+26]
	call spring1_proc

	push [bp+24]
	call spring2_proc

	push [bp+22]
	call spring3_proc
	
	push [bp+20]
	call spring4_proc

	push [bp+18]
	call spring5_proc

	push [bp+16]
	call spring6_proc

	push [bp+14]
	call spring7_proc

	push [bp+12]
	call spring8_proc


	add si,4
	add bx,2
	loop spring_lop 


	; --------------------------
	pop dx
	pop di
	pop si
	pop cx
	pop bx
	pop ax
	pop bp
	ret 34
endp make_squre

;=====================================================================================================
;[bp+10] = yp offset
;[bp+8] = xp offset
;[bp+6] = temp_integer
;[bp+4] = length of points
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
	mov cx,[bp+4]
	mov di,[bp+8]
	mov si,[bp+10]
	draw_loop:
	xor ax,ax
	xor bx,bx
	xor dx,dx
	fld [dword ptr si]
	frndint
	mov bx,[bp+6]
	fistp [word ptr bx]
	mov bx,[word ptr bx]

	mov ax,200
	sub ax,bx
	mov bx,320
	mul bx
	xor bx,bx
	fld [dword ptr di]
	frndint
	mov bx,[bp+6]
	fistp [word ptr bx]
	mov bx,[word ptr bx]
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
	ret 8
endp draw
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
;[bp+28] = offset of total number of points times 4
;[bp+30] = offset of total number of points
;[bp+32] = offset of pxp
;[bp+34] = offset of pyp
proc init_of_object
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	mov di,[bp+30]
	xor ax,ax
	mov al,5
	mov bl,5
	mul bl
	mov [di],ax
	mov bx,4
	mul bx
	mov di,[bp+28]
	mov [di],ax

	push 0
	push [bp+34]
	push [bp+32]
	push [bp+30]
	push [bp+28]
	push [bp+26]
	push [bp+24]
	push [bp+22]
	push [bp+20]
	push [bp+18]
	push [bp+16]
	push [bp+14]
	push [bp+12]
	push [bp+10]
	push [bp+8]
	push 5 ;y
	push 5 ;x
	call make_squre


	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 32
endp init_of_object
;=====================================================================================================
proc init_manu
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	; Go to text mode
	mov ah, 0
	mov al, 2
	int 10h


	mov dx,offset massage_opening
	mov ah,9
	int 21h

	manu_input_loop:
	mov ah,0
	int 16h

	cmp al,'s'
	je manu_exit
	cmp al,'i'
	jne manu_input_loop

	mov dx,offset massage_info
	mov ah,9
	int 21h

	mov ah,0
	int 16h
	manu_exit:

	; Graphic mode
	mov ax, 13h
	int 10h

	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
endp init_manu
;=====================================================================================================
proc check_input
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di


	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
endp check_input
;=====================================================================================================
proc math
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di


	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
endp math
;=====================================================================================================
proc check_collision
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di


	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
endp check_collision
;=====================================================================================================
start:
	mov ax, @data
	mov ds, ax
    mov ax, 0a000h
    mov es, ax
; --------------------------

;start_again_the_main_loop:
	call init_manu


	push offset pyp
	push offset pxp
	push offset length_of_points
	push offset length_of_points_times_4
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
	call init_of_object

;main_lop:

	call check_input

	call math

	call check_collision

	push offset yp
	push offset xp
	push offset temp_integer
	push [word ptr length_of_points]
	call draw

;jmp main_lop


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


