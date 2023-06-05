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
	time_intervuls dd 0.2;0.002
	time_intervuls_squared_div_2 dd 0.02;0.000002
;--------------------------
	temp_float2 dd 0
	temp_float1 dd 0
	arctan_lookup_table_q dd 0.01 ;the max number / number of elements in the table || 1/100 = 0.01
	arctan_lookup_table dd 0,0.00999967,0.01999733,0.029991,0.03997869,0.0499584,0.05992816,0.069886,0.07982999,0.08975817,0.09966865,0.10955953,0.11942893,0.129275,0.13909594,0.14888995,0.15865526,0.16839016,0.17809294,0.18776195,0.19739556,0.20699219,0.2165503,0.22606839,0.23554498,0.24497866,0.25436806,0.26371183,0.2730087,0.28225742,0.29145679,0.30060567,0.30970294,0.31874756,0.32773851,0.33667482,0.34555558,0.35437992,0.36314701,0.37185607,0.38050638,0.38909723,0.39762799,0.40609806,0.41450687,0.42285393,0.43113874,0.43936089,0.44751998,0.45561565,0.46364761,0.47161557,0.47951929,0.48735858,0.49513326,0.50284321,0.51048832,0.51806853,0.52558379,0.53303411,0.5404195,0.54774001,0.55499573,0.56218674,0.56931319,0.57637522,0.58337301,0.59030675,0.59717666,0.60398298,0.61072596,0.61740589,0.62402305,0.63057776,0.63707033,0.64350111,0.64987045,0.65617872,0.66242629,0.66861357,0.67474094,0.68080883,0.68681765,0.69276784,0.69865982,0.70449406,0.71027101,0.71599111,0.72165485,0.72726269,0.7328151,0.73831257,0.74375558,0.74914462,0.75448018,0.75976275,0.76499283,0.77017091,0.7752975,0.78037308
;--------------------------
	step_flag dw 0

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
;[bp+4] = offset table starting place
;[bp+6] = byte the place in the table dd
;[bp+8] = return offset value
proc return_value_from_table
	push ax
	push bx
	push cx

	mov bx, [bp+4]
	mov cx, [bp+6]
	mov ax,4
	mul cx
	add bx,ax
	fld [dword ptr bx]
	mov bx,[bp+8]
	fstp [dword ptr bx]

	pop cx
	pop bx
	pop ax
	ret 6
endp return_value_from_table
;=====================================================================================================
;[bp+4] = offset the number that we are looking up
;[bp+6] = offset of temp float
;[bp+8] = offset of the result
proc arctan
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	mov bx, offset arctan_lookup_table
	mov di, offset arctan_lookup_table_q

	mov si, [bp+4]
	fld [dword ptr si]
	fabs
	fld1
	fcomp
    fnstsw ax
    sahf
	jna arctan_is_above_1
	fld1
	frdiv
arctan_is_above_1:
	fdiv [dword ptr di]
	frndint
	mov di,[bp+6]
	fstp [dword ptr di]
;[bp+4] = offset table starting place
;[bp+6] = byte the place in the table dd
;[bp+8] = return offset value
	call return_value_from_table
	fld [dword ptr di]

	fld [dword ptr si]
	fld1
	fcomp
    fnstsw ax
    sahf
	jna arctan_is_above_1_2
	fadd [dword ptr pi_div_2]
arctan_is_above_1_2:

	fld [dword ptr si]
	fabs
	fldz
	fcomp
    fnstsw ax
    sahf
	jna arctan_is_posetive
	fchs
arctan_is_posetive:
	mov bx,[bp+8]
	fstp [dword ptr bx]

	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret
endp arctan
;=====================================================================================================
start:
	mov ax, @data
	mov ds, ax
    mov ax, 0a000h
    mov es, ax

; --------------------------

; --------------------------
    ; Return to text mode
	mov ah, 0
	mov al, 2
	int 10h
exit:
	mov ax, 4c00h
	int 21h
END start




