jmp start

;==============================
db bb ;przerwanie sprzêtowe 02
db bb ;przerwanie sprzêtowe 03
db b8 ;przerwanie sprzêtowe 04

;==============================
;G³ówny program
start:
	
;==============================
; Obs³uga wyboru pola
	mov cl,6f
rozpocznij:
	mov al,40
nasluch:
	sti
	out 08
	cmp al,3a
	jns nasluch
	call 1d
	call 4b
	cmp bl,9
	js rozpocznij

;==============================
; Wprowadzanie znaku na pole
org 1d
	add al,8f
	cmp al,c3
	js wyswietl
	add al,d
	cmp al,d3
	js wyswietl
	add al,d
wyswietl:
	mov dl,[al]
	cmp dl,20
	jnz wyjscie
	mov [al],cl
	inc bl
	cmp cl,6f
	jz krzyz
	mov cl,6f
	jmp wyjscie
krzyz:
	mov cl,78
wyjscie:
ret

;==============================
; Sprawdzanie warunków zwyciêstwa
org 4b
	push bl
poczatek:
	cmp dl,f0
	mov dl,c0
	mov al,[dl]
pobierz:
	push dl
	jz pion
	cmp al,20
	jz przejscie
petla:
	inc dl
	int b7
	jnz przejscie
	push dl
	and dl,2
	cmp dl,2
	pop dl
	jnz petla
potwierdz:
	pop dl
	pop bl
	mov bl,10
	jmp koniectu
przejscie:
	pop dl
	add dl,10
	cmp dl,f0
	jz poczatek
	jmp pobierz
pion:
	cmp al,20
	jz tutututu
	add dl,10
	int b7
	jz pion
tutututu:
	push dl
	and dl,f0
	cmp dl,f0
	pop dl
	jz potwierdz
	and dl,c3
	inc dl
	mov al,[dl]
	cmp dl,c2
	jnz pion
	pop dl
	pop bl
koniectu:
ret

;==============================
; Porównanie liczb
org b0
	mov bl,[dl]
	cmp al,bl
iret
;==============================
; Obs³uga klawiatury numerycznej	
org b7
db b0
	cli
	in 08
iret

end