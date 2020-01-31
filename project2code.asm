.include "m16def.inc"
.cseg

.def code=r20           ; kataxwritis ston opoio apothikevoume ton kwdiko tou sistimatos

ldi r16,low(ramend)     ;initialize stack poionter
out spl,r16
ldi r16,high(ramend)
out sph,r16             ;end

;entoles genikou tupou
rcall initialize

rcall set_code
rcall part2
rcall part2_1
rjmp loop

;telos entolwn genikou tupou


initialize:
clr r0            ;midenismos twn registers gia na mhn exoun akures times ston 
clr r1            ;alithino epexergasti
clr r2
clr r3
clr r4
clr r5
clr r6
clr r7
clr r8
clr r9
clr r10
clr r11
clr r12
clr r13
clr r14
clr r15
clr r16
clr r17
clr r18
clr r19
clr r20
clr r21
ldi r21,255
ldi r22,255
ldi r23,255
clr r24
clr r25
clr r26
clr r27
clr r28
clr r29
clr r30
clr r31
ldi r16, 0b11111111    ;portb=exodos
out ddrb,r16
ldi r16, 0b00000000
out ddrd,r16           ;,portd=eisodos
ldi r16,255
out portb,r16
out portd,r16
ret




set_code:           ;thetoume ton kwdiko tou sistimatos (part1)
rcall set_delay     ;to delay eiani gia na exei xrono o xristis na patisei paralila ola ta koumpia
in   r17,pind           ;ston r17 pernaei i eisodos tou xristi apo to pind        
cpi  r17,0b11111111     ;an einai isos me ena den exei patithei tipota ara ksanaperimenei na patithei kati
breq set_code
mov  r18,r17            ;elegxoume an pathithikan mi epitrepta pliktra
andi r18,0b11100001
cpi  r18,0b11100001     ; an nai branch stin arxi tou set code kai ksana elegxos
brne set_code
switch_7:
in r18,pind             ;ston r18 apothikevoume tin eisodo sto pind
andi r18,0b10000000     ; an patithike to sw7 tote o kwdikos apothikevetai
cpi  r18,0b10000000     
breq switch_7           ; alliws ksana stin arxi tou loop kai perimenoume na patithei
ori r17, 0b11100001        ;or ston kwdiko gia na parw ta psifeia pou thelw kai ta alla apatita
mov code,r17             ;metakinisi tou kwdikou ston register code(r20)
ret

reset: ; simeio ekkinisis kanonikis leitourgias (kai epanekkinisi meta apo reset)
part2_1:

insert_signal:  ;sayto to simeio perimenoume na patithei o sw0 gia na anapsei i endeiksi
in r17,pind     ; kai na eisagoume sti sinexeia ton kwdiko
cpi r17,0b11111110   ;an den exei patithei o sw0 ksana anixnefsi
brne insert_signal
ldi r19,0b11111110   
out portb,r19 ;endeiksi sto led0 oti boroume na eisagoume kwdiko


part2:
ldi r31,80           ; oi 3 entoles ldi stin arxi tou part 2 kai oi 3 entoles meiwsis sto telos
w3:                  ; twn label "insert_password" einai to delay twn 5 deyteroleptwn pou
ldi r30,118          ; exei sti diathesi tou o xristis gia na patisei ton kwdiko
w2:
ldi r29,190
w1:  
insert_pass1:       ;elegxos gia to an patithike to sw1
  
in r17,pind         ; eisodos
mov r18,r17
andi r18,0b00000011 ; apenergopoiw ta bit tou kwd ektos apo sw1 kai vlepw an exei patithei to  sw1
cpi r18,0b00000001
breq pressed1

insert_pass2:     ;elegxos gia to an patithike to sw2   

                    ;sayto to simeio ftanoume eitai apo to pressed1 me rjmp eite epeidi
                     ; de patithike o sw1 kai sinexise kanonika opote ananewnoume tin eisodo
					  ;o xronos tou avr einai poli grigoroteros opote prolavainei na kanei ton elegxo sta
					  ;"pressed" labels gia lathos patima  prin patithoun oi ypoloipoi diakoptes.

in r17,pind
mov r18,r17
andi r18,0b00000101 ;apomonosi tou psifeiou sti thesi 2 me andi
cpi r18,0b00000001  ;elegxos an patithike o sw2
breq pressed2       ; an nai branch sto label pressed2

insert_pass3:       ;elegxos gia to an patithike to sw3

in r17,pind
mov r18,r17
andi r18,0b00001001  ;apomonosi tou psifeiou sti thesi 3 me andi
cpi r18, 0b00000001
breq pressed3     ;an nai branch sto pressed3

insert_pass4:    ; elegxos gia to an patithike to sw4
in r17,pind 
mov r18,r17
andi r18,0b00010001  ;apomonosi tou psifeiou sti thesi 4 me andi
cpi r18, 0b00000001
breq pressed4   ;an nai branch sto pressed4
 
dec r29
brne w1
dec r30      ; endoles meiwsis ton kataxwritwn pou eksipiretoun to delay twn 5 sec
brne w2
dec r31
brne w3
  
rjmp comp_code     ; gia na ftasoume edw simainei pws ola patithikan diadoxika opote den exoume
                     ;kati na elegksoume kai pame sti sigrisi me ton apothikevmeno code;



pressed1:   ; exei patithei o diakoptis 1

            ; ston r23 apothikevoume ton kwdiko pou exei eisaxthei stadiaka me afaiseri kathe fora
			;pou patietai ena pliktro 1-4.Epeidi to programma elegxei synexws an patithike kapoio
			;pliktro apo ayta einai pithano na bei sto pressed1 deyteri fora . Epeidi den theloume
			;na enimerwthei o r23 gia deyteri fora elegxoume an yparxei idi kataxwrimeno to 1 ston r23
			; kai an nai kanoume branch sto insert_pass2 gia epomeno elegxo.         

mov r21,r23          ;xrisimopoioume ton r21 gia na kanoume and ston r23 xwris na aloiwthei
andi r21,0b00000010  ; kai na paroume to psifeio pou mas enfiaferei,sti sigekrimeni to 1.
cpi r21,0b00000000 
breq insert_pass2
                      ;Elegxos diadoxikotitas kwdikou
					  ;metaferoume ston r18 ton r17 pou periexei tin eisodo, gia na tin epeksergastoume
mov r18,r17 		  ; exontas patithei o 1 den theloume na exoun patithei oi epomenoi
andi r18,0b00011000     ;me and elegxoume an exei patithei kapoios allos
cpi r18,0b00011000      ;den vazoume asso ston 2 giati einai periptwsi break to 2 prin to 1
brne wrong_code        ; branch sto wrong_code(ektos apo tous lathos kwdikous
                       ;;stelnoume se ayto to label kai tous kwdikous me lathos seira pliktrologisis)

subi r23,0b00000010	   ; enimerwsi tou r23 gia to pliktro pou patithike me afairesi assou(0 simainei patithike)
andi r17,0b00000100
cpi r17,0b00000100   ; elegxos gia paraviasi
                     ;an patithike to 2 prin to 1 einai periptwsi paraviasis kai kanoume branh sto break_2
brne break_2

rjmp insert_pass2    ; jump stin epomeni eisodo pou perimenei apo to 2 diakopti kai meta 

pressed2:

mov r21,r23
andi r21,0b00000100  ;paromoia diadikasia pou akoloutheitai sto pressed1
cpi r21,0b00000000
breq insert_pass3  
mov r18,r17
andi r18,0b00011000
cpi r18,0b00011000
brne wrong_code
subi r23,0b00000100	
rjmp insert_pass3  ; branch ston epomeno elegxo gia to sw3

pressed3:         ; edw den yparxei branch gia to wrong_code giati ola ta epomena
                  ; psifeia kanoun branch se paraviaseis


        ;( ipirkse parerminia tis ekfwnisis kai  thewrisame pws ta pliktra 
		;sw7,sw6,sw5,sw4 an patithoun prin to sw3 einai paraviaseis)

    
mov r18,r17     ;swzw gia na ksanaxrisimopoihsw
andi r18,0b00010000
cpi r18,0b00010000  ;an patithike to 4 prin to 3 break sto break_4
brne break_4
mov r18,r17        ;epanaferw tin eisodo gia na kanw adi gia to sw5
andi r18,0b00100000
cpi r18,0b00100000
brne break_5       ;an patithike to 5 prin to 3 break sto break_5
mov r18,r17
andi r18,0b01000000
cpi r18, 0b01000000
brne break_6       ;an patithike to 6 prin to 3 break sto break_6
mov r18, r17
andi r18,0b10000000
cpi r18,0b10000000
brne break_7       ;an patithike to 7 prin to 3 break sto break_7
mov r21,r23
andi r21,0b00001000
cpi r21,0b00000000
breq insert_pass4    ; an exei patithei idi to 3 branch prin enimerwthei ksana o r23
subi r23,0b00001000	; an ola pigan kala enimerwsi tou r23 
rjmp insert_pass4   ;branch ston epomeno elegxo gia to sw4

pressed4:       ; exei patithei o sw4
mov r21,r23
andi r21,0b00010000  ;elegxoume an exei patithei idi kai an nai branch prin enimerwthei o r23
cpi r21,0b00000000
breq insert_pass4  
subi r23,0b00010000    ;enimerwsi tou r23 me afairesi monadas apo ti thesi 4
rjmp comp_code       ;jump sto label comp code. Twra tha sygrinoume ton kwdiko pou eisixthi
                     ;me ton kwdiko tou sistimatos.

 
 reset1:   ;  endiameso label pou  stelnetai to programma prin paei sto label reset giati
 rjmp reset  ; eiai poli makria to panw apo to katw meros tou programmatos 


comp_code:    ;sigrisi kwdikou pou eisixthi me ton kwdiko tou sistimatos

ori r17,0b11100001    ;apomonwsi me or tou kwdikou
cp code,r17           ;sigrisi me ton apothikevmeno
brne wrong_code      ; an den einai isoi branch sto wrong_code

right_code:     ;an einai isoi to programma eiserxetai sto right_code kai anavei to led1

ldi r19,0b11111101   ;anavei to  led1 sinexomena
out portb,r19

wait_reset:

in r18, pind
cpi r18,0b11111110  ;an exei patithei o sw0 kanoume epanekkinisi sistimatos
breq reset1
rjmp wait_reset

wrong_code:

in r18, pind
cpi r18,0b11111110  ;an exei patithei o sw0 kanoume epanekkinisi sistimatos
breq reset1
ldi r19,0b11111110   ;anavosvinei to led0 ana 1 sec
out portb,r19
rcall one_second    ;delay 1 sec (gia na anavosvinei to led0)
ldi r19,0b11111111
out portb,r19
rcall one_second
rjmp wrong_code

break_2:      ; sta breaks anavoun ta analoga leds pou leei i ekfwnisi

ldi r19,0b11110011
out portb,r19         
rjmp loop

break_4:

ldi r19,0b11101011
out portb, r19
rjmp loop

break_5:

ldi r19,0b11011011
out portb,r19
rjmp loop

break_6:

ldi r19,0b10111011
out portb,r19
rjmp loop

break_7:

ldi r19,0b01111011
out portb,r19
rjmp loop




two_seconds: ; delay 2 deyteroleptwn

ldi r31, 41 
b3:
ldi r30, 150
b2:
ldi r29, 128
b1:
dec r29
brne b1
dec r30
brne b2
dec r31
brne b3
ret

one_second:;delay enos deyteroleptou

ldi r31, 21
a3:
ldi r30, 71
a2:
ldi r29, 192
a1:
dec r29
brne a1
dec r30
brne a2
dec r31
brne a3

set_delay:  ;delay
ldi r31, 45
d3:
ldi r30, 71
d2:
ldi r29, 190
d1:
dec r29
brne d1
dec r30
brne d2
dec r31
brne d3
ret



loop:rjmp loop
