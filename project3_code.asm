.include "m16def.inc"
.cseg
.def temp=r16     ; thetoume ton r16 ws kataxwriti apothikeysis proswrinwn dedomenwn
.def  input=r17   ; thetoume ton r17 ws kataxwriti apothikeysis pliroforias eisodou(programma,ktl)
.def one=r18      ;kataxwritis me timi 1
.def start=r19  ;thetoume ton r19 ws kataxwriti apothikeysis tis pliroforias ekkinisis

;entoles genikou tupou

ldi r25,low(ramend)     ;initialize stack poionter
out spl,r25
ldi r25,high(ramend)
out sph,r25            ;end

rcall initialize   ;tmima arxikopoihshs

rcall wait_start   ;tmima anamonis gia ekkinisi
rcall choose_prog  ;tmima epilogis programmatos
rcall wait_start   ;tmima anamonis gia enarksi plisis
rcall check_overload ;tmima elegxou yperfortwsis
ldi temp,0b11111101 
out portb,temp
jmp normal_function  ; kanoniki leitourgeia plisis(periexei ta 4 stadia tis plisis)

loop:
rjmp loop

initialize:         ;arxikopoioume tous kataxwrites r16-r31 sto logiko 1 . to sistima doulevei me arnitiki logiki 
                    ;opote mas einai pio eyxristo oi arxikes times na einai sto 1(off).
clr r0
clr r1
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
ldi r16,255                          
ldi r17,255 
ldi r18,255 
ldi r19,255                          
ldi r20,255 
ldi r21,255 
ldi r22,255                         
ldi r23,255 
ldi r24,255 
ldi r25,255                         
ldi r26,255 
ldi r27,255 
ldi r28,255 
ldi r29,255 
ldi r30,255                         
ldi r31,255 

ldi r16 ,0b11111111               ;portb=exodos,portd=eisodos
out ddrb,r16
ldi r16, 0b00000000
out ddrd,r16
ldi r16,255
out portb,r16
out portd,r16
ret

wait_start:
in start,pind        ; perimenoume na patithei to sw6 gia na energopoihthei to systima
cpi start,0b10111111   ;episis tin deyteri fora perimenoume na patithei ksana gia tin enerksi tis plisis
brne wait_start
ret


choose_prog:  ; sto label ayto mesa se diarkeia 10 deyteroleptwn perimenoume na patithei to
                ; koumpi sw2 gia proplisi kai ta sw3,4,5 gia epilogi programmatos
ldi r31, 70
b3:
ldi r30, 230   ; xronos 10 deytera
b2:
ldi r29, 130
b1:

in temp,pind     
mov r20,temp
andi r20,0b00000100    ; se kathe loop tou coose_prog elegxoume an patithike kapoio apo ta 2,3,4,5
cpi r20,0b00000000     ; kai an nai stelnoume ti roi sto analogo pressed label
breq pressed2
a:
mov r20,temp
andi r20,0b00001000
cpi r20,0b00000000
breq pressed3
b:
mov r20,temp
andi r20,0b00010000
cpi r20,0b00000000
breq pressed4
c:
mov r20,temp
andi r20,0b00100000
cpi r20,0b00000000
breq pressed5
d:

dec r29
brne b1
dec r30
brne b2
dec r31
brne b3
ret

sub_input:

eor temp,one      ;antistrefoume ta psifeia tis eisodou
sub input,temp   ;kai tin afairoume apo ton kataxwriti apothikeysis input(to apothikevoume)
jmp choose_prog
              
pressed2:

mov r21,input
andi r21,0b00000100       ;sta pressed labels elegxoume an to pliktro pou patithike exei patithei ksana,
cpi r21,0b00000000        ;ara exei afairethei apo ton kataxwriti input kai an nai stelnoume ti roi sti sine
breq a                    ;xeia twn elegxwn eisodou, diaforetika sto label sub_input, opou kai afaireitai h timi tou 
jmp sub_input             ; pliktrou gia prwti fora ap to input

pressed3:

mov r21,input
andi r21,0b0001000
cpi r21,0b00000000
breq b
jmp sub_input

pressed4:

mov r21,input
andi r21,0b00010000
cpi r21,0b00000000
breq c
jmp sub_input

pressed5:

mov r21,input
andi r21,0b00100000
cpi r21,0b00000000
breq d
jmp sub_input



check_overload:  ;sayto to label elegxoume an exei ksepatithei so sw1 yperfortosis 
             ; kai an oxi tote elegxoume ta pliktra programmatos poy patithikan proigoumenws 
			 ;kai ekteloume tis katalliles epiloges

			 ;!!!!!(h ekfwnisi leei otan einai patimeno dil 0 leitourgei kanonika kai an ksepatithei stop
			  ;  mporei na ginei kai to antitheto gia pio eykolia na min exoume patimena ta koubia oli tin wra)!!!!!!

ldi r31, 180
z3:
ldi r30, 230  ; xronos 10 deytera
z2:
ldi r29, 133
z1:

in temp,pind
andi temp,0b00000010   ;tsekaroume an exei ksepatithei to sw1
cpi temp, 0b00000000
breq overload          ;an nai exoume diakladwsi se periptwsi overload

dec r29
brne z1
dec r30
brne z2
dec r31
brne z3
ret

normal_function: ;label kanonikis leitourgeias syberilamvanei ta 4 stadia tis plisis


mov temp,input
andi temp,0b00000100    ;tsekaroume gia proplisi
cpi temp,0b00000000
breq pre_wash1     ; na ftiaksw tin kathisterisi 4 second



back5:           ;epistrofi apo tin prewash
rcall main_wash
rcall wash_out
rcall drain
back6:
rcall end_of_wash

pre_wash1:
jmp pre_wash    ;gia na ftasw makrina labels


main_wash:

ldi temp,0b11110101      ;stadio 2/ anavei to led3
out portb,temp

mov temp,input
andi temp,0b00011000    ;elegxos programmatos gia wra kyrias plisis
cpi temp,0b00000000     ;elegxoume mono ta sw3,4 giati to sw5 anaeretai sto drain
breq four_sec1           ;analoga me ton sindiasmo twn sw3,4 exoume plisi 4,8,12,18 leptwn 
mov temp,input
andi temp,0b00011000 
cpi temp,0b00001000
breq eight_sec1
mov temp,input
andi temp,0b00011000 
cpi temp,0b00010000
breq twelve_sec1
mov temp,input
andi temp,0b00011000 
cpi temp,0b00011000
breq eighteen_sec1


four_sec1:
jmp four_sec    ;prosvasi se makrina labels mesw jmp

eight_sec1:
jmp eight_sec

twelve_sec1:
jmp twelve_sec

eighteen_sec1:
jmp eighteen_sec

wash_out:          ;anavei to led4 / stadio 3

ldi temp, 0b11101101
out portb,temp
breq one_sec1  ; kseplima diarkei 1 sec

one_sec1:      ; gia prosvasi se makrino label
jmp one_sec


overload:    ;periptwsi yperfortosis

ldi temp,0b11111101       ;  anavosvima tou led1 ana 1 sec
out portb,temp
rcall one_second1
ldi temp,0b11111111
out portb,temp
rcall one_second1
rjmp overload    ; o vroxos ekteleitai synexeia mexri na synexistei to programma
                 ;sto one_second elegxetai an exei patithei to sw1 ksana opote to programma
				 ;epanaferetai apo ekei


drain:        ;anavei to led 5  /stadio 4

ldi temp,0b11011101
out portb,temp

mov temp,input
andi temp,0b00100000
cpi temp,0b00000000
breq two_sec1  ; straggisma an exei patithei to sw5, diarkei 2 lepta
jmp back6  ;pisw stis genikou tupou an den exoume drain

two_sec1:        ; gia prosvasi se makrino label
jmp two_sec


pre_wash:

ldi temp,0b11111011
out portb,temp

ldi r31, 150    ;diarkeia proplisis 4 sec
a3:
ldi r30, 80 
a2:
ldi r29, 130
a1:

in temp,pind           ;elegxos se oles tis xronokathisteriseis gia to an exei anoiksei 
andi temp,0b00000001   ;h porta i an exei diakopei i paroxi nerou(stis xronokathisteriseis pragmatopoiountai ta stadia tis plisis)
cpi temp,0b00000000    ; elegxoume diladi an exoun ksepatithei ta pliktra sw7 i sw0
breq open_door0      ;an nai kanoume branch sta emergency labels mesw voithitikwn
close_door0:           ;labels gia na exoume acces makria me jmp
ldi temp,0b11111001
out portb,temp
in temp,pind
andi temp,0b10000000
cpi temp,0b00000000
breq stop_water0
water_back0:
ldi temp,0b11111001
out portb,temp

dec r29
brne a1
dec r30
brne a2
dec r31
brne a3
jmp back5

open_door0:
rcall open_door      ; kaleitai i open_door
rjmp close_door0     ; otan epistrepsei stelnetai ekei pou stamatise to programma diladi se label
                     ;pou exoume topothetisei mia grammi meta ti diakopi tou programmatos 
                     
stop_water0:
rcall stop_water
rjmp water_back0



end_of_wash:      ;telos plisis anavei to led 7 gia 5 sec

ldi temp,0b01111111
out portb,temp
rcall five_sec
ldi temp,0b11111111
out portb,temp
rjmp wait_start   ; to programma epistrefei sto wait_start kai einai etoimo gia nea leitourgia


stop_water:          ;label pou dilwnei thn apwleia nerou. ara exei ksepatithei to sw7 
ldi temp,0b01111111  
out portb,temp       ;anavei to led 7 me periodo 1 sec
breq one_second2     ; sto one_second ginetai elegxos gia tin epanafora tis kanonikis leitourgias
                     ; se periptwsi pou ksanapatithei to sw7(epistrofi nerou)

continue1:           ;epistrofi apo one_second epeidi patithike to sw7 kai me to ret epistrefoume ekei pou klithike i stop_water
                     ;diladi sto simeio pou eimastan otan stamatise to nero kai sinexizetai kanonika i plisi
ret


open_door:           ;label pou dilwnei to anoigma tis portas . exei ksepatithei to sw0
ldi temp,0b11111110
out portb,temp       ;anavosvinei to led0 me rythmo 1 sec
breq one_second3      ;sto one_second ginetai elegxos gia tin epanafora tis kanonikis leitourgias
ldi temp,0b11111111  ;se periptwsi pou ksanapatithei to sw0(kleisimo portas)
out portb,temp       
breq one_second3
rjmp open_door

continue2:          ;epistrofi apo one_second epeidi patithike to sw0 kai me to ret epistrefoume ekei pou klithike i open_door
ret                 ;diladi sto simeio pou eimastan otan anoikse i porta
                  
one_second1:
                 ;kata ti diarkeia tou enos deyteroleptou mexri tin allagi tou led
				 ;ginetai elegxos gia to ean patithike pali o sw1.an nai to programma
				 ;synexizetai kanonika.Paralilla ginetai elegxos kai gia to sw7 se periptwsi pou
				 ;exoume diakopi nerou, gia epanafora stin kanoniki leitourgia kai gia to sw0 se periptwsi pou
				 ;exei anoiksei i porta
				 ;ayto ginetai epeidi xrisimopoioume ton idio vroxo kathysterisis enos sec
				 ;gia tis treis leitourgies
ldi r31, 90
c3:
ldi r30, 75    ; xronos 1 sec
c2:
ldi r29, 191
c1:

in temp,pind
andi temp,0b00000010   ;elegxos gia sw1 epanafora leitourgias (yperfotrwsi)
cpi temp,0b00000010
breq return

dec r29
brne c1
dec r30
brne c2
dec r31
brne c3
ret

one_second2:
                 ;kata ti diarkeia tou enos deyteroleptou mexri tin allagi tou led
				 ;ginetai elegxos gia to ean patithike pali o sw1.an nai to programma
				 ;synexizetai kanonika.Paralilla ginetai elegxos kai gia to sw7 se periptwsi pou
				 ;exoume diakopi nerou, gia epanafora stin kanoniki leitourgia kai gia to sw0 se periptwsi pou
				 ;exei anoiksei i porta
				 ;ayto ginetai epeidi xrisimopoioume ton idio vroxo kathysterisis enos sec
				 ;gia tis treis leitourgies
ldi r31, 90
c33:
ldi r30, 75    ; xronos 1 sec
c22:
ldi r29, 191
c11:


in temp,pind
andi temp,0b10000000   ;elegxos gia sw7 epanafora leitourgias (nero)
cpi temp,0b10000000
breq return1



dec r29
brne c11
dec r30
brne c22
dec r31
brne c33
ret

one_second3:
                 ;kata ti diarkeia tou enos deyteroleptou mexri tin allagi tou led
				 ;ginetai elegxos gia to ean patithike pali o sw1.an nai to programma
				 ;synexizetai kanonika.Paralilla ginetai elegxos kai gia to sw7 se periptwsi pou
				 ;exoume diakopi nerou, gia epanafora stin kanoniki leitourgia kai gia to sw0 se periptwsi pou
				 ;exei anoiksei i porta
				 ;ayto ginetai epeidi xrisimopoioume ton idio vroxo kathysterisis enos sec
				 ;gia tis treis leitourgies
ldi r31, 90
c333:
ldi r30, 75    ; xronos 1 sec
c222:
ldi r29, 191
c111:


in temp,pind
andi temp,0b00000001   ;elegxos gia sw0 epanafora  leitourgias (porta)
cpi temp,0b00000001
breq return2

dec r29
brne c111
dec r30
brne c222
dec r31
brne c333
ret


return2:          ;epanafora programmatos sto simeio pou itan analoga me tin diakopi
jmp continue2
                  ;(gia ta 3 return)
return1:
jmp continue1           

return:
jmp normal_function

four_sec:

ldi r31, 70
d3:
ldi r30, 40
d2:
ldi r29, 100
d1:

in temp,pind           ;elegxos se oles tis xronokathisteriseis gia to an exei anoiksei 
andi temp,0b00000001   ;h porta i an exei diakopei i paroxi nerou(stis xronokathisteriseis pragmatopoiountai ta stadia tis plisis)
cpi temp,0b00000000    ; elegxoume diladi an exoun ksepatithei ta pliktra sw7 i sw0
breq open_door4        ;an nai kanoume branch sta emergency labels mesw voithitikwn
close_door4:           ;labels gia na exoume acces makria me jmp
ldi temp,0b11110101
out portb,temp
in temp,pind
andi temp,0b10000000
cpi temp,0b00000000
breq stop_water4
water_back4:
ldi temp,0b11110101
out portb,temp

dec r29
brne d1
dec r30
brne d2
dec r31
brne d3
ret

open_door4:
rcall open_door      ; kaleitai i open_door
rjmp close_door4     ; otan epistrepsei stelnetai ekei pou stamatise to programma diladi se label
                     ;pou exoume topothetisei mia grammi meta ti diakopi tou programmatos 
                     
stop_water4:
rcall stop_water
rjmp water_back4

five_sec:

ldi r31, 180
i3:
ldi r30, 250
i2:
ldi r29, 190
i1:


dec r29
brne i1
dec r30
brne i2
dec r31
brne i3
ret


two_sec:

ldi r31, 60
j3:
ldi r30, 150
j2:
ldi r29, 128
j1:

in temp,pind
andi temp,0b00000001
cpi temp,0b00000000
breq open_door2         ; paromoios elegxos me tis ypoloipes xronokathisteriseis gia emergency
close_door2:
ldi temp,0b11011101
out portb,temp
in temp,pind
andi temp,0b10000000
cpi temp,0b00000000
breq stop_water2
water_back2:
ldi temp,0b11011101
out portb,temp

dec r29
brne j1
dec r30
brne j2
dec r31
brne j3
ret

open_door2:
rcall open_door
rjmp close_door2

stop_water2:
rcall stop_water
rjmp water_back2

eight_sec:

ldi r31, 150
e3:
ldi r30, 180
e2:
ldi r29, 150
e1:

in temp,pind
andi temp,0b00000001
cpi temp,0b00000000
breq open_door8
close_door8:  
ldi temp,0b11110101
out portb,temp              ; paromoios elegxos me tis ypoloipes xronokathisteriseis gia emergency
in temp,pind
andi temp,0b10000000
cpi temp,0b00000000
breq stop_water8
water_back8:
ldi temp,0b11110101
out portb,temp

dec r29
brne e1
dec r30
brne e2
dec r31
brne e3
ret

open_door8:
rcall open_door
rjmp close_door8

stop_water8:
rcall stop_water
rjmp water_back8


twelve_sec:

ldi r31, 230
f3:
ldi r30, 130
f2:
ldi r29, 150
f1:

in temp,pind
andi temp,0b00000001
cpi temp,0b00000000
breq open_door12         ; paromoios elegxos me tis ypoloipes xronokathisteriseis gia emergency
close_door12:
ldi temp,0b11110101
out portb,temp
in temp,pind
andi temp,0b10000000
cpi temp,0b00000000
breq stop_water12
water_back12:
ldi temp,0b11110101
out portb,temp

dec r29
brne f1
dec r30
brne f2
dec r31
brne f3
ret

open_door12:
rcall open_door
rjmp close_door12

stop_water12:
rcall stop_water
rjmp water_back12
                      ;!!!!! stis xronokathisteriseis exoume prosvasi mesw breq
					  ;to ret sto telos tous epistrefei sti sinartisi eidikou typou
					  ;pou tis kalese ,diladi ena apo ta 4 stadia tis plisis!!!!!!!
eighteen_sec:

ldi r31, 100
g3:
ldi r30, 250
g2:
ldi r29, 230
g1:

in temp,pind
andi temp,0b00000001
cpi temp,0b00000000
breq open_door18                ; paromoios elegxos me tis ypoloipes xronokathisteriseis gia emergency
close_door18:
ldi temp,0b11110101
out portb,temp
in temp,pind
andi temp,0b10000000
cpi temp,0b00000000
breq stop_water18
water_back18:
ldi temp,0b11110101
out portb,temp

dec r29
brne g1
dec r30
brne g2
dec r31
brne g3
ret

open_door18:
rcall open_door
rjmp close_door18

stop_water18:
rcall stop_water
rjmp water_back18

one_sec:

ldi r31, 90
h3:
ldi r30, 75
h2:
ldi r29, 191
h1:

in temp,pind
andi temp,0b00000001
cpi temp,0b00000000
breq open_door1              ; paromoios elegxos me tis ypoloipes xronokathisteriseis gia emergency
close_door1:
ldi temp,0b11101101
out portb,temp
in temp,pind
andi temp,0b10000000
cpi temp,0b00000000
breq stop_water1
water_back1:
ldi temp,0b11101101
out portb,temp

dec r29
brne h1
dec r30
brne h2
dec r31
brne h3
ret

open_door1:
rcall open_door
rjmp close_door1

stop_water1:
rcall stop_water
rjmp water_back1

