IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------

; --------------------------
;hello world
CODESEG
;=====================================================================================================


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




; --------------------------
    ; Return to text mode
	mov ah, 0
	mov al, 2
	int 10h
exit:
	mov ax, 4c00h
	int 21h
END start


