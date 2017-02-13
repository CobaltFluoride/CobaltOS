BITS 16
org 0x7C00

start:
	call SetupVideo
	mov si, WelcomeMessage
	call print
	call LoadKernel
	jmp $

LoadKernel:
	mov si, AttemptToRead
	call print
	mov si, DiskInfo
	call print

	mov dl, 0x0	;Drive 0 = Floppy 1
	mov dh, 0x0	;head (0=base)
	mov ch, 0x0	;track/cylinder
	mov cl, 0x02	;Sector (Starts at 1, not 0!)
	mov bx, 0x1000	;For kernel (Random?) Place in ram.
	mov es, bx 	;Bx in pointer es
	mov bx, 0x0	;Ram positioning
	
	call ReadDisk

	ret

ReadDisk:
	mov ah, 0x02
	mov al, 0x01
	int 0x13
	jc ReadDisk	;In case of fail, try again!

	mov ax, 0x1000
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	jmp 0x1000:0x0



	ret

drawBox:
	mov ah, 0x0e
.widthSides:
	mov si, TopLeftCorner
	lodsb
	mov bl, 0
	int 0x10
.heightSides:

	ret


print:
	mov ah, 0x0E
.loop:
	lodsb
	cmp al, 0
	je .done
	mov bl, 0
	int 0x10
	jmp .loop
.done:
	ret

SetupVideo:
	mov ah, 0x00
	mov al, 0x07
	int 0x10
	ret

end:

	TopLeftCorner db 0xC9
	TopWall db 0xCD
	TopRightCorner db 0xBB
	BottomLeftCorner db 0xC8
	BottomRightCorner db 0xBC
	WelcomeMessage db 0xC9, 0xCD, 0xCD, 0xCD, 0xCD, 0xCD, 0xCD, 0xCD, 0xCD, 0xBB, 0x0a, 0x0d, 0xBA, "CobaltOS", 0xBA, 0x0a, 0x0d, 0xC8, 0xCD, 0xCD, 0xCD, 0xCD, 0xCD, 0xCD, 0xCD, 0xCD, 0xBC, 0x0a, 0x0d, 0
	AttemptToRead db "Will now attempt to read the disk, and load kernel into memory!", 0x0a, 0x0d, 0
	DiskInfo db "Gathering disk information...", 0x0a, 0x0d, 0

	times 510 - ($-$$) db 0x00
	db 0x55, 0xAA
