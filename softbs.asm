.386
IDEAL
MODEL small
STACK 200h
DATASEG
; --------------------------
	temp_float_testing dd 0


	temp_float dd 0
	length_of_points dw 0
	length_of_points_times_4 dw 0
	temp_integer dd 0
	mass dd 0.1
	gravity dd -10.0
	knormal dd 6.0
	dknormal dd 8.4852809906005859375
	k dd -1.0
	pi_div_2 dd 1.57079637050628662109375
	time_intervuls dd 0.002
	time_intervuls_squared_div_2 dd 0.000002
;--------------------------
	temp_float4 dd 0
	temp_float3 dd 0
	temp_float2 dd 0
	temp_float1 dd 0
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

	left_x dw 100,200;10 dup(0)
	left_y dw 100,80;10 dup(0)
	right_x dw 200,300;10 dup(0)
	right_y dw 70,50;10 dup(0)

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

	getting_input_massage db '                                        ',10,13
						  db '                                        ',10,13
						  db '                                        ',10,13
						  db '                                        ',10,13
						  db '                                        ',10,13
						  db '  please press two numbers between 2-9  ',10,13
						  db '     this will be your object size      ',10,13
						  db '                                        ',10,13
						  db '                                        ',10,13
						  db '                                        ',10,13
						  db '                                        ',10,13
						  db '                                        ',10,13,'$'


; --------------------------
;hello world
CODESEG
;=====================================================================================================
;[bp+4] = amount of cycles
proc timer
	push bp
	mov bp,sp
	push es
	push ax
	push bx
	push cx

	mov bx,6ch
	mov cx,[bp+4]

	mov ax, 40h
	mov es, ax

	timer_loop:
	mov ax, [es:bx]
	FirstTick:
	cmp ax, [es:bx]
	je FirstTick
	loop timer_loop

	pop cx
	pop bx
	pop ax
	pop es
	ret 2
endp timer
;=====================================================================================================
proc clear_screen
	push ax
	push bx
	push cx

	mov cx,0FA00h
	xor ax,ax
	xor bx,bx
	clear_screen_loop:
	mov [es:bx],al
	inc bx
	loop clear_screen_loop

	pop cx
	pop bx
	pop ax
	ret
endp clear_screen
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
;[bp+4] = x numbers of points in the x direction
;[bp+6] = y numbers of points in the y direction
;[bp+8] = offset of x_position in dataseg
;[bp+10] = offset of y_position in dataseg
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
	shl ax,2
	mov [bp+4],ax
	xor bx,bx
	mov di,[bp+28]
	spring_lop:

	push bx
	push [word ptr bp+6]
	push [di]
	push si
	push [word ptr bp+4]

	push [word ptr bp+26]
	call spring1_proc

	push [word ptr bp+24]
	call spring2_proc

	push [word ptr bp+22]
	call spring3_proc
	
	push [word ptr bp+20]
	call spring4_proc

	push [word ptr bp+18]
	call spring5_proc

	push [word ptr bp+16]
	call spring6_proc

	push [word ptr bp+14]
	call spring7_proc

	push [word ptr bp+12]
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
;[bp+4] = offset of left_y
;[bp+6] = offset of left_x
;[bp+8] = offset of right_y
;[bp+10] = offset of right_x
proc collision_mouse_maker
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di


	xor dx,dx
	xor si,si

	mov ax,0h
	int 33h
	mov ax,1h
	int 33h

	mouse_loop:
	mov ax,5h
	int 33h
	cmp bx, 01h
	jne mouse_loop
	shr cx,1

	mov bx,[bp+6]
	mov [bx],cx
	mov bx,[bp+4]
	mov [bx],dx

	push 4
	call timer

	mouse_loop2:
	mov ax,5h
	int 33h
	cmp bx, 01h
	jne mouse_loop2
	shr cx,1

	mov bx,[bp+10]
	mov [bx],cx
	mov bx,[bp+8]
	mov [bx],dx


	mov ax,2
	int 33h


	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 8
endp collision_mouse_maker
;=====================================================================================================
;[bp+4] = x dirrection
;[bp+6] = y dirrection
proc getting_size_of_object
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	mov dx,offset getting_input_massage
	mov ah,9
	int 21h

	getting_size_of_object_loop1:
	mov ah,0
	int 16h
	sub al,30h
	cmp al,10
	jnb getting_size_of_object_loop1

	mov ah,0
	mov [bp+4],ax

	getting_size_of_object_loop2:
	mov ah,0
	int 16h
	sub al,30h
	cmp al,10
	jnb getting_size_of_object_loop2

	mov ah,0
	mov [bp+6],ax

	call clear_screen

	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
endp getting_size_of_object
;=====================================================================================================
;[bp+4] = x numbers of points in the x direction
;[bp+6] = y numbers of points in the y direction
;[bp+8] = offset of x_position in dataseg
;[bp+10] = offset of y_position in dataseg
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
;[bp+36] = offset of left_y
;[bp+38] = offset of left_x
;[bp+40] = offset of right_y
;[bp+42] = offset of right_x
proc init_of_objects
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	; --------------------------getting the collision objects
	;	push [bp+42]
	;	push [bp+40]
	;	push [bp+38]
	;	push [bp+36]
	;	call collision_mouse_maker
	; -------------------------- getting the size of the object
	push 0
	push 0
	call getting_size_of_object
	pop bx
	pop ax

	mov [bp+4],bx
	mov [bp+6],ax
	; --------------------------making the object
	mov di,[bp+30]
	mul bx
	mov [di],ax
	mov bx,4
	mul bx
	mov di,[bp+28]
	mov [di],ax

	push 0
	push [word ptr bp+34]
	push [word ptr bp+32]
	push [word ptr bp+30]
	push [word ptr bp+28]
	push [word ptr bp+26]
	push [word ptr bp+24]
	push [word ptr bp+22]
	push [word ptr bp+20]
	push [word ptr bp+18]
	push [word ptr bp+16]
	push [word ptr bp+14]
	push [word ptr bp+12]
	push [word ptr bp+10]
	push [word ptr bp+8]
	push [word ptr bp+6]
	push [word ptr bp+4]
	call make_squre
	; --------------------------
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 40
endp init_of_objects
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
;x+v*t+a*t^2/2
;[bp+4] = offset x
;[bp+6] = offset v
;[bp+8] = offset t
;[bp+10] = offset a
;[bp+12] = offset t^2/2
;[bp+14] = offset result
;[bp+16] = offset temp_float
proc new_position_equation
	push bp
	mov bp,sp
	push si
	push di

	mov di,[bp+16];the temp float 
	
	;mul v and t and add x
	mov si,[bp+6]
	fld [dword ptr si]
	mov si,[bp+8]
	fmul [dword ptr si]
	mov si,[bp+4]
	fadd [dword ptr si]

	;mul a and t^2/2 and add the previos calc to this
	mov si,[bp+10]
	fld [dword ptr si]
	mov si,[bp+12]
	fmul [dword ptr si]

	fadd
	mov si,[bp+14]
	fstp [dword ptr si]
	fstp [dword ptr di]


	pop di
	pop si
	pop bp
	ret 14
endp new_position_equation
;=====================================================================================================
;[bp+4] = offset of xp
;[bp+6] = offset of yp
;[bp+8] = offset of xf
;[bp+10] = offset of xv
;[bp+12] = offset of yf
;[bp+14] = offset of yv
;[bp+16] = offset of xa
;[bp+18] = offset of ya
;[bp+20] = offset of time_intervals
;[bp+22] = offset of time_intervals squared div 2
;[bp+24] = offset of length of points
;[bp+26] = offset of temp_float
proc new_position
	push bp
	mov bp,sp
	push ax
	push cx
	push si

	mov si,[bp+24]
	mov cx,[si]
	xor ax,ax
	new_position_loop:
	push [word ptr bp+26]
	mov si,[bp+4]
	add si,ax
	push si
	push [word ptr bp+22]
	mov si,[bp+16]
	add si,ax
	push si
	push [word ptr bp+20]
	mov si,[bp+10]
	add si,ax
	push si
	mov si,[bp+4]
	add si,ax
	push si
	call new_position_equation


	push [word ptr bp+26]
	mov si,[bp+6]
	add si,ax
	push si
	push [word ptr bp+22]
	mov si,[bp+18]
	add si,ax
	push si
	push [word ptr bp+20]
	mov si,[bp+14]
	add si,ax
	push si
	mov si,[bp+6]
	add si,ax
	push si
	call new_position_equation

	add ax,4
	loop new_position_loop


	pop si
	pop cx
	pop ax
	pop bp
	ret 24
endp new_position
;=====================================================================================================
;v+a*t
;[bp+4] = offset v
;[bp+6] = offset t
;[bp+8] = offset a
;[bp+10] = offset result
proc new_velocity_equation
	push bp
	mov bp,sp
	push si

	;mul a and t and add v
	mov si,[bp+8]
	fld [dword ptr si]
	mov si,[bp+6]
	fmul [dword ptr si]
	mov si,[bp+4]
	fadd [dword ptr si]
	mov si,[bp+10]
	fstp [dword ptr si]

	pop si
	pop bp
	ret 8
endp new_velocity_equation
;=====================================================================================================
;[bp+4] = offset of xv
;[bp+6] = offset of yv
;[bp+8] = offset of xa
;[bp+10] = offset of ya
;[bp+12] = offset of time_intervals
;[bp+14] = offset of length of points
proc new_velocity
	push bp
	mov bp,sp
	push ax
	push cx
	push si

	mov si,[bp+14]
	mov cx,[si]
	xor ax,ax
	new_velocity_loop:
	mov si,[bp+4]
	add si,ax
	push si
	mov si,[bp+8]
	add si,ax
	push si
	push [word ptr bp+12]
	mov si,[bp+4]
	add si,ax
	push si
	call new_velocity_equation

	mov si,[bp+6]
	add si,ax
	push si
	mov si,[bp+10]
	add si,ax
	push si
	push [word ptr bp+12]
	mov si,[bp+6]
	add si,ax
	push si
	call new_velocity_equation

	add ax,4
	loop new_velocity_loop


	pop si
	pop cx
	pop ax
	pop bp
	ret 12
endp new_velocity
;=====================================================================================================
;[bp+4] = offset of xf
;[bp+6] = offset of yf
;[bp+8] = offset of length_of_points
proc reset_forces
	push bp
	mov bp,sp
	push si
	push di
	push cx
	push ax

	mov si,[bp+4]
	mov di,[bp+8]
	mov cx,[di]
	shl cx,1
	mov di,[bp+6]
	xor ax,ax
	reset_forces_loop:
	mov [di],ax
	mov [si],ax
	add si,2
	add di,2
	loop reset_forces_loop

	pop ax
	pop cx
	pop di
	pop si
	pop bp
	ret 6
endp reset_forces
;=====================================================================================================
;[bp+4] = offset of xa
;[bp+6] = offset of ya
;[bp+8] = offset of xf
;[bp+10] = offset of yf
;[bp+12] = offset of mass
;[bp+14] = offset of length of points
proc calc_acceleration
	push bp
	mov bp,sp
	push ax
	push cx
	push si

	xor ax,ax
	mov si,[bp+14]
	mov cx,[si]

	calc_acceleration_loop:
	mov si,[bp+8]
	add si,ax
	fld [dword ptr si]
	mov si,[bp+12]
	fdiv [dword ptr si]
	mov si,[bp+4]
	add si,ax
	fstp [dword ptr si]

	mov si,[bp+10]
	add si,ax
	fld [dword ptr si]
	mov si,[bp+12]
	fdiv [dword ptr si]
	mov si,[bp+6]
	add si,ax
	fstp [dword ptr si]

	add ax,4
	loop calc_acceleration_loop

	pop si
	pop cx
	pop ax
	pop bp
	ret 12
endp calc_acceleration
;=====================================================================================================
;[bp+4] = offset of gravity
;[bp+6] = offset of mass
;[bp+8] = offset of yf
;[bp+10] = offset of langth_of_points
;[bp+12] = offset of temp_float
proc gravity_force
	push bp
	mov bp,sp
	push cx
	push si
	push di

	mov si,[bp+4]
	fld [dword ptr si]
	mov si,[bp+6]
	fmul [dword ptr si]
	mov di,[bp+12]
	fstp [dword ptr di]

	mov si,[bp+10]
	mov cx,[si]
	mov si,[bp+8]

	gravity_forces_loop:
	fld [dword ptr si]
	fadd [dword ptr di]
	fstp [dword ptr si]
	add si,4
	loop gravity_forces_loop


	pop di
	pop si
	pop cx
	pop bp
	ret 10
endp gravity_force
;=====================================================================================================
;[bp+4] = offset of xp
;[bp+6] = offset of yp
;[bp+8] = offset of pxp
;[bp+10] = offset of pyp
;[bp+12] = offset of length_of_points
proc reset_place_values
	push bp
	mov bp,sp
	push ax
	push cx
	push si

	xor ax,ax
	mov si,[bp+12]
	mov cx,[si]
	reset_place_values_loop:
	mov si,[bp+4]
	add si,ax
	fld [dword ptr si]
	mov si,[bp+8]
	add si,ax
	fstp [dword ptr si]

	mov si,[bp+6]
	add si,ax
	fld [dword ptr si]
	mov si,[bp+10]
	add si,ax
	fstp [dword ptr si]

	add ax,4
	loop reset_place_values_loop

	pop si
	pop cx
	pop ax
	pop bp
	ret 10
endp reset_place_values
;=====================================================================================================
;/-(ax-bx)^2+(ay-by)^2
;[bp+4] = offset ax
;[bp+6] = offset ay
;[bp+8] = offset bx
;[bp+10] = offset by
;[bp+12] = offset result
;[bp+14] = offset temp_float
proc distance_equation
	push bp
	mov bp,sp
	push si
	push di

	mov di,[bp+14];the temp float 

	;substract ax-bx and multiply by itself
	mov si,[bp+4]
	fld [dword ptr si]
	mov si,[bp+8]
	fsub [dword ptr si]
	fst [dword ptr di]
	fmul [dword ptr di]

	;substract ay-by and multiply by itself
	mov si,[bp+6]
	fld [dword ptr si]
	mov si,[bp+10]
	fsub [dword ptr si]
	fst [dword ptr di]
	fmul [dword ptr di]

	;ads the two numbers together and square root them and store in the result
	faddp
	fsqrt
	mov si,[bp+12]
	fstp [dword ptr si]

	pop di
	pop si
	pop bp
	ret 12
endp distance_equation
;=====================================================================================================
;[bp+4] = offset of result
;[bp+6] = offset of input of x
;[bp+8] - offset of temp value
proc arctan
	push bp
	mov bp,sp
	push si
	push ax
	push di
	push cx
	push bx
	push dx

	mov cx,5
	xor ax,ax
	mov dx,1
	mov di,[bp+6]
	mov si,[bp+8]
	mov bx,[bp+4]
	mov [dword ptr bx],0
	large_loop_arctan:

	push cx
	fld [dword ptr di]
	mov cx,dx
	cmp dx,1
	je there_is_a_zero_in_arctan
	dec cx

	arctan_x_loop:
fst [dword ptr temp_float_testing]
	fmul [dword ptr di]
fst [dword ptr temp_float_testing]
	loop arctan_x_loop

	there_is_a_zero_in_arctan:
	pop cx

	mov [word ptr si],dx
fst [dword ptr temp_float_testing]
	fidiv [word ptr si]
fst [dword ptr temp_float_testing]

	cmp ax,0
	je not_negetive_now
	fchs
	mov ax,0
	jmp negetive_now
	not_negetive_now:
	mov ax,1
	negetive_now:

fst [dword ptr temp_float_testing]
	fadd [dword ptr bx]
fst [dword ptr temp_float_testing]
	fstp [dword ptr bx]

	add dx,2
loop large_loop_arctan

	pop dx
	pop bx
	pop cx
	pop di
	pop ax
	pop si
	pop bp
	ret 6
endp arctan
;=====================================================================================================
;F=-K*X (k is already negative)
;X=distance - nk
;cx = bx-ax
;cy = by-ay
;[bp+4] = offset ax
;[bp+6] = offset ay
;[bp+8] = offset bx
;[bp+10] = offset by
;[bp+12] = offset knormal
;[bp+14] = offset K
;[bp+16] = offset temp_float
;[bp+18] = offset of C-+?
;[bp+20] = ;offset of fx
;[bp+22] = ;offset of fy
;[bp+24] = ;offset of temp_float3
;[bp+26] = ;offset of temp_float4
proc spring_force_calc
	push bp
	mov bp,sp
	push si
	push ax
	push di

	mov di,offset temp_float_testing

	push [word ptr bp+16]
	push [word ptr bp+16]
	push [word ptr bp+10]
	push [word ptr bp+8]
	push [word ptr bp+6]
	push [word ptr bp+4]
	call distance_equation

	;;;;;;;;;;;;;;;;;;;;;;;; getting distance of l
	mov si,[bp+16]
	fld [dword ptr si]
	mov si,[bp+12]
	fsub [dword ptr si]
	mov si,[bp+16]
	mov [dword ptr si],2
	fidiv [dword ptr si]

	mov si,[bp+14]
	fmul [dword ptr si]
	mov si,[bp+16]
	fstp [dword ptr si]

	;;;;;;;;;;;;;;;;;;;;;;;; getting cx
	mov si,[bp+8]
	fld [dword ptr si]
	mov si,[bp+4]
	fsub [dword ptr si]
	mov si,[bp+20]

fst [dword ptr di]

	fstp [dword ptr si]
	;;;;;;;;;;;;;;;;;;;;;;;; getting cy

	mov si,[bp+10]
	fld [dword ptr si]
	mov si,[bp+6]
	fsub [dword ptr si]
	mov si,[bp+22]
	
fst [dword ptr di]

	fst [dword ptr si]
	;;;;;;;;;;;;;;;;;;;;;;;; arctan

	mov si,[bp+20]
	fld [dword ptr si]

	fdivp
	mov si,[bp+26]
	fstp [dword ptr si]

	push [word ptr bp+24]
	push [word ptr bp+26]
	push [word ptr bp+18]
	call arctan


	mov si,[bp+18]
	fld [dword ptr si]
	fld [dword ptr si]

	;;;;;;;;;;;;;;;;;;;;;;;; y force
fst [dword ptr di]

	fsin

fst [dword ptr di]

	mov si,[bp+16]
	fmul [dword ptr si]

fst [dword ptr di]

	mov si,[bp+22]
	fld [dword ptr si]

fst [dword ptr di]

	fldz

	fcompp
	fnstsw ax
	sahf
	ja y_is_not_negetive
	fchs

fst [dword ptr di]

	y_is_not_negetive:
	fstp [dword ptr si]

	;;;;;;;;;;;;;;;;;;;;;;;; x forces
fst [dword ptr di]
	fadd [dword ptr pi_div_2]
	fsin

fst [dword ptr di]

	mov si,[bp+16]
	fmul [dword ptr si]

fst [dword ptr di]

	mov si,[bp+20]
	fld [dword ptr si]

fst [dword ptr di]

	fldz

	fcompp
	fnstsw ax
	sahf
	ja x_is_not_negetive
	fchs

fst [dword ptr di]

	x_is_not_negetive:
	fstp [dword ptr si]


	pop di
	pop ax
	pop si
	pop bp
	ret 24
endp spring_force_calc
;=====================================================================================================
;[bp+4] = offset knormal
;[bp+6] = offset of spring
;[bp+8] = offset K
;[bp+10] = offset of xp
;[bp+12] = offset of yp
;[bp+14] = offset temp_float
;[bp+16] = offset of C-+?
;[bp+18] = offset of fx_spring
;[bp+20] = offset of fy_spring
;[bp+22] = loop counter
;[bp+24] = offset of fx
;[bp+26] = offset of fy
;[bp+28] = offset of temp_float3
;[bp+30] = offset of temp_float4
proc shorten_the_spring_calc
	push bp
	mov bp,sp
	push ax
	push bx
	push si


	mov si,[bp+6]
	add si,[bp+22]
	mov si,[si]
	cmp si,0ffffh
	je shorten_the_spring_calc_exit

	mov bx,[bp+22]
	shl bx,1
	mov ax,[bp+22]

	push [word ptr bp+30]
	push [word ptr bp+28]
	push [word ptr bp+20]
	push [word ptr bp+18]
	push [word ptr bp+16]
	push [word ptr bp+14]
	push [word ptr bp+8]
	push [word ptr bp+4]

	mov si,[bp+6]
	add si,ax
	mov si,[si]
	add si,[bp+12]
	push si

	mov si,[bp+6]
	add si,ax
	mov si,[si]
	add si,[bp+10]
	push si

	mov si,[bp+12]
	add si,bx
	push si

	mov si,[bp+10]
	add si,bx
	push si

	call spring_force_calc

	push [word ptr bp+22]
	push [word ptr bp+20]
	push [word ptr bp+26]
	push [word ptr bp+18]
	push [word ptr bp+24]
	call spring_direction_add

	shorten_the_spring_calc_exit:


	pop si
	pop bx
	pop ax
	pop bp
	ret 4
endp shorten_the_spring_calc
;=====================================================================================================
;[bp+4] = offset of fx
;[bp+6] = offset of fx_of_spring
;[bp+8] = offset of fy
;[bp+10] = offset of fy_of_spring
;[bp+12] = loop counter
proc spring_direction_add
	push bp
	mov bp,sp
	push si
	push ax

	mov ax,[bp+12]
	shl ax,1

	mov si,[bp+10]
	fld [dword ptr si]
	mov si,[bp+8]
	add si,ax
	fadd [dword ptr si]
	fstp [dword ptr si]

	mov si,[bp+6]
	fld [dword ptr si]
	mov si,[bp+4]
	add si,ax
	fadd [dword ptr si]
	fstp [dword ptr si]

	pop ax
	pop si
	pop bp
	ret 10
endp spring_direction_add
;=====================================================================================================
;[bp+4] = offset length_of_points
;[bp+6] = offset xp
;[bp+8] = offset yp
;[bp+10] = offset knormal
;[bp+12] = offset dknormal
;[bp+14] = offset K
;[bp+16] = offset of spring8
;[bp+18] = offset of spring7
;[bp+20] = offset of spring6
;[bp+22] = offset of spring5
;[bp+24] = offset of spring4
;[bp+26] = offset of spring3
;[bp+28] = offset of spring2
;[bp+30] = offset of spring1
;[bp+32] = offset temp_float
;[bp+34] = offset temp_float1
;[bp+36] = offset temp_float2
;[bp+38] = offset temp_integer
;[bp+40] = offset fx
;[bp+42] = offset fy
;[bp+44] = random
;[bp+46] = offset of temp_float3
;[bp+48] = offset of temp_float4
proc spring_calc
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push si

	mov si,[bp+4]
	mov cx,[si]
	xor ax,ax

	spring_calc_loop:
	mov [bp+44],ax

	push [word ptr bp+48]
	push [word ptr bp+46]
	push [word ptr bp+42]
	push [word ptr bp+40]
	push [word ptr bp+44]
	push [word ptr bp+36]
	push [word ptr bp+34]
	push [word ptr bp+38]
	push [word ptr bp+32]
	push [word ptr bp+8]
	push [word ptr bp+6]
	push [word ptr bp+14]

	push [word ptr bp+16]
	push [word ptr bp+10]
	call shorten_the_spring_calc
	;;;;;;;;;;;;;;
	push [word ptr bp+18]
	push [word ptr bp+12]
	call shorten_the_spring_calc
	;;;;;;;;;;;;;;
	push [word ptr bp+20]
	push [word ptr bp+10]
	call shorten_the_spring_calc
	;;;;;;;;;;;;;;
	push [word ptr bp+22]
	push [word ptr bp+12]
	call shorten_the_spring_calc
	;;;;;;;;;;;;;;
	push [word ptr bp+24]
	push [word ptr bp+10]
	call shorten_the_spring_calc
	;;;;;;;;;;;;;;
	push [word ptr bp+26]
	push [word ptr bp+12]
	call shorten_the_spring_calc
	;;;;;;;;;;;;;;
	push [word ptr bp+28]
	push [word ptr bp+10]
	call shorten_the_spring_calc
	;;;;;;;;;;;;;;
	push [word ptr bp+30]
	push [word ptr bp+12]
	call shorten_the_spring_calc
	;;;;;;;;;;;;;;

	pop bx
	pop bx
	pop bx
	pop bx
	pop bx
	pop bx
	pop bx
	pop bx
	pop bx
	pop bx
	pop bx
	pop bx



	add ax,2
	loop spring_calc_loop


	pop si
	pop cx
	pop bx
	pop ax
	pop bp
	ret 46
endp spring_calc
;=====================================================================================================
;[bp+4] = offset of length_of_points
;[bp+6] = offset of xp
;[bp+8] = offset of yp
;[bp+10] = offset of pxp
;[bp+12] = offset of pyp
;[bp+14] = offset of spring8
;[bp+16] = offset of spring7
;[bp+18] = offset of spring6
;[bp+20] = offset of spring5
;[bp+22] = offset of spring4
;[bp+24] = offset of spring3
;[bp+26] = offset of spring2
;[bp+28] = offset of spring1
;[bp+30] = offset of gravity
;[bp+32] = offset of mass
;[bp+34] = offset of temp_integer
;[bp+36] = offset of temp_float
;[bp+38] = offset of xf
;[bp+40] = offset of xv
;[bp+42] = offset of yf
;[bp+44] = offset of yv
;[bp+46] = offset of time_intervuls squared divided by 2
;[bp+48] = offset of xa
;[bp+50] = offset of ya
;[bp+52] = offset of time_intervuls
;[bp+54] = offset of knormal
;[bp+56] = offset of dknormal
;[bp+58] = offset of temp_float1
;[bp+60] = offset of k
;[bp+62] = offset of temp_float2
;[bp+64] = offset of temp_float3
;[bp+66] = offset of temp_float4
proc math
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	push [word ptr bp+4]
	push [word ptr bp+42]
	push [word ptr bp+38]
	call reset_forces

	push [word ptr bp+4]
	push [word ptr bp+12]
	push [word ptr bp+10]
	push [word ptr bp+8]
	push [word ptr bp+6]
	call reset_place_values

	push [word ptr bp+36]
	push [word ptr bp+4]
	push [word ptr bp+42]
	push [word ptr bp+32]
	push [word ptr bp+30]
	call gravity_force

	push [word ptr bp+66]
	push [word ptr bp+64]
	push 0
	push [word ptr bp+42]
	push [word ptr bp+38]
	push [word ptr bp+34]
	push [word ptr bp+62]
	push [word ptr bp+58]
	push [word ptr bp+36]
	push [word ptr bp+28]
	push [word ptr bp+26]
	push [word ptr bp+24]
	push [word ptr bp+22]
	push [word ptr bp+20]
	push [word ptr bp+18]
	push [word ptr bp+16]
	push [word ptr bp+14]
	push [word ptr bp+60]
	push [word ptr bp+56]
	push [word ptr bp+54]
	push [word ptr bp+8]
	push [word ptr bp+6]
	push [word ptr bp+4]
	call spring_calc

	push [word ptr bp+4]
	push [word ptr bp+32]
	push [word ptr bp+42]
	push [word ptr bp+38]
	push [word ptr bp+50]
	push [word ptr bp+48]
	call calc_acceleration

	push [word ptr bp+36]
	push [word ptr bp+4]
	push [word ptr bp+46]
	push [word ptr bp+52]
	push [word ptr bp+50]
	push [word ptr bp+48]
	push [word ptr bp+44]
	push [word ptr bp+42]
	push [word ptr bp+40]
	push [word ptr bp+38]
	push [word ptr bp+8]
	push [word ptr bp+6]
	call new_position

	push [word ptr bp+4]
	push [word ptr bp+52]
	push [word ptr bp+50]
	push [word ptr bp+48]
	push [word ptr bp+44]
	push [word ptr bp+40]
	call new_velocity

	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 64
endp math
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
;[bp+18] = offset temp_float
;[bp+16] = offset of yv
;[bp+14] = offset of xv
;[bp+12] = offset of pyp
;[bp+10] = offset of pxp
;[bp+8] = offset of yp
;[bp+6] = offset of xp
;[bp+4] = offset of length_of_points
proc check_border_collision
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push si

	xor bx,bx
	mov si,[bp+4]
	mov cx,[si]

	check_y_collision_loop:
	mov si,[bp+8]
	add si,bx
	fld [dword ptr si]

	mov si,[bp+18]
	mov [dword ptr si],1
	fild [dword ptr si]

	fcompp
	fnstsw ax
	sahf
	jb y_direction_collision_is_ok

	mov si,[bp+16]
	add si,bx
	fld [dword ptr si]
	fchs
	fstp [dword ptr si]

	mov si,[bp+10]
	add si,bx
	fld [dword ptr si]

	mov si,[bp+6]
	add si,bx
	fadd [dword ptr si]

	mov si,[bp+18]
	mov [dword ptr si],2
	fidiv [dword ptr si]

	mov si,[bp+6]
	add si,bx
	fstp [dword ptr si]
	y_direction_collision_is_ok:
	add bx,4
	loop check_y_collision_loop

	;----------------------------------------------------------------

	xor bx,bx
	mov si,[bp+4]
	mov cx,[si]

	check_y_up_collision_loop:
	mov si,[bp+8]
	add si,bx
	fld [dword ptr si]

	mov si,[bp+18]
	mov [dword ptr si],200
	fild [dword ptr si]

	fcompp
	fnstsw ax
	sahf
	ja y_up_direction_collision_is_ok

	mov si,[bp+16]
	add si,bx
	fld [dword ptr si]
	fchs
	fstp [dword ptr si]

	mov si,[bp+10]
	add si,bx
	fld [dword ptr si]

	mov si,[bp+6]
	add si,bx
	fadd [dword ptr si]

	mov si,[bp+18]
	mov [dword ptr si],2
	fidiv [dword ptr si]

	mov si,[bp+6]
	add si,bx
	fstp [dword ptr si]
	y_up_direction_collision_is_ok:
	add bx,4
	loop check_y_up_collision_loop

 
	pop si
	pop cx
	pop bx
	pop ax
	pop bp
	ret 16
endp check_border_collision
;=====================================================================================================
;[bp+20] = offset of yv
;[bp+18] = offset of xv
;[bp+16] = offset of temp_integer
;[bp+14] = offset of temp_float
;[bp+12] = offset of pyp
;[bp+10] = offset of pxp
;[bp+8] = offset of yp
;[bp+6] = offset of xp
;[bp+4] = offset of length_of_points
proc check_collision
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	push [word ptr bp+14]
	push [word ptr bp+20]
	push [word ptr bp+18]
	push [word ptr bp+12]
	push [word ptr bp+10]
	push [word ptr bp+8]
	push [word ptr bp+6]
	push [word ptr bp+4]
	call check_border_collision

	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 18
endp check_collision
;=====================================================================================================
;[bp+4] = offset of left_y
;[bp+6] = offset of left_x
;[bp+8] = offset of right_y
;[bp+10] = offset of right_x
proc draw_square
	push bp
	mov bp,sp
	push ax
	push bx
	push si
	push di
	push dx



	pop dx
	pop di
	pop si
	pop bx
	pop ax
	pop bp
	ret
endp draw_square
;=====================================================================================================
;[bp+14] = pyp
;[bp+12] = pxp
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
	mov di,[bp+12]
	mov si,[bp+14]
	draw_loop_clear:
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
	mov [byte ptr es:bx],0
	add di,4
	add si,4
	loop draw_loop_clear

	; ----------------------------------------------------------------

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
start:
	mov ax, @data
	mov ds, ax
    mov ax, 0a000h
    mov es, ax
; --------------------------

;start_again_the_main_loop:
	call init_manu

	push offset right_x
	push offset right_y
	push offset left_x
	push offset left_y
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
	push 0
	push 0
	call init_of_objects

main_lop:

	call check_input

	push offset temp_float4
	push offset temp_float3
	push offset temp_float2
	push offset k
	push offset temp_float1
	push offset dknormal
	push offset knormal
	push offset time_intervuls
	push offset ya
	push offset xa
	push offset time_intervuls_squared_div_2
	push offset yv
	push offset yf
	push offset xv
	push offset xf
	push offset temp_float
	push offset temp_integer
	push offset mass
	push offset gravity
	push offset spring1
	push offset spring2
	push offset spring3
	push offset spring4
	push offset spring5
	push offset spring6
	push offset spring7
	push offset spring8
	push offset pyp
	push offset pxp
	push offset yp
	push offset xp
	push offset length_of_points
	call math

	push offset yv
	push offset xv
	push offset temp_integer
	push offset temp_float
	push offset pyp
	push offset pxp
	push offset yp
	push offset xp
	push offset length_of_points
	call check_collision

	push offset	pyp
	push offset pxp
	push offset yp
	push offset xp
	push offset temp_integer
	push [word ptr length_of_points]
	call draw

	mov ah,1
	int 16h
	jz no_exiting
	mov ah,0 ;stop the program to see what is going on
	int 16h
	cmp al,27
	je exit_main_loop
	no_exiting:

jmp main_lop
exit_main_loop:
; --------------------------
    ; Return to text mode
	mov ah, 0
	mov al, 2
	int 10h
exit:
	mov ax, 4c00h
	int 21h
END start


