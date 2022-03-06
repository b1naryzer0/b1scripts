include masm32rt.inc

.data
	notepad db "c:\windows\system32\notepad.exe",0
	
.code

main:	
	push ebx				    ; save ebx
	mov ebx, 3				  ; count to 3
loopy:						    ; loop start
	push SW_SHOWNORMAL
	push offset notepad
	call WinExec
	dec ebx					    ; decrease ebx
	jnz loopy				    ; loop until ebx is 0
	
	pop ebx					    ; restore ebx

end main
