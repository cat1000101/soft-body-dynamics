IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
	length_of_points dw 0
	temp_place1 dd 0
	temp_place2 dd 0

	xp db 0
	db 100 dup(?)
	xf dd 0
	dd 100 dup(0)
	xv dd 0
	dd 100 dup(0)
	yp db 0
	db 100 dup(?)
	yf dd 0
	dd 100 dup(0)
	yv dd 0
	dd 100 dup(0)

; --------------------------
;hello world
CODESEG
;=====================================================================================================
;[bp+4] = x numbers of points in the x direction
;[bp+6] = y numbers of points in the y direction
;[bp+8] = x_position in dataseg
;[bp+10] = y_position in dataseg
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
	mov cx,[bp+6]
	mov si,[bp+8] ;xp
	mov di,[bp+10] ;yp
	mov bl,160
	mov bh,160
	mov al,[bp+4]
	mov dl,3
	mul dl
	sub bl,al
	mov dl,bl

	y_position_loop:
	push cx
	mov cx,[bp+4]
	x_position_loop:
	mov [si],bl
	mov [di],bh
	add si,1
	add di,1
	add bl,6
	loop x_position_loop
	pop cx
	mov bl,dl
	sub bh,6
	loop y_position_loop

	; --------------------------
	pop dx
	pop di
	pop si
	pop cx
	pop bx
	pop ax
	pop bp
	ret 8
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
	mov bl,[si]
	mov al,200
	sub al,bl
	mov bx,320
	mul bx
	xor bx,bx
	mov bl,[di]
	add ax,bx
	mov bx,ax
	mov [es:bx],4
	inc di
	inc si
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


