%include "include/io.inc"

extern atoi
extern printf
extern exit
extern puts

; Functions to read/free/print the image.
; The image is passed in argv[1].
extern read_image
extern free_image
; void print_image(int* image, int width, int height);
extern print_image

; Get image's width and height.
; Store them in img_[width, height] variables.
extern get_image_width
extern get_image_height

section .data
	use_str db "Use with ./tema2 <task_num> [opt_arg1] [opt_arg2]", 10, 0

section .bss
    task:       resd 1
    img:        resd 1
    aux_img:    resd 1
    img_width:  resd 1
    img_height: resd 1
    size:       resd 1
    line:       resd 1
    string:     resd 1
    
    

section .text
global main
main:
    ; Prologue
    ; Do not modify!
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8]
    cmp eax, 1
    jne not_zero_param

    push use_str
    call printf
    add esp, 4

    push -1
    call exit

not_zero_param:
    ; We read the image. You can thank us later! :)
    ; You have it stored at img variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 4]
    call read_image
    add esp, 4
    mov [img], eax

    ; We saved the image's dimensions in the variables below.
    call get_image_width
    mov [img_width], eax

    call get_image_height
    mov [img_height], eax

    ; Let's get the task number. It will be stored at task variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 8]
    call atoi
    add esp, 4
    mov [task], eax

    ; There you go! Have fun! :D
    mov eax, [task]
    cmp eax, 1
    je solve_task1
    cmp eax, 2
    je solve_task2
    cmp eax, 3
    je solve_task3
    cmp eax, 4
    je solve_task4
    cmp eax, 5
    je solve_task5
    cmp eax, 6
    je solve_task6
    jmp done

my_xor:
    push ebp
    mov ebp, esp
    
    mov edx, [ebp + 8]
    mov ecx, [img_width]
    xor ebx, ebx
    
parcurgere:
   
try_r:
    mov eax, [img]
    mov eax, [eax + ebx]
    xor eax, edx    
    cmp al, 'r'
    je try_e
    
    jmp fail
    
try_e:
    mov eax, [img]
    mov eax, [eax + ebx + 4]
    xor eax, edx
    cmp al, 'e'
    je try_v
    
    jmp fail

try_v:
    mov eax, [img]
    mov eax, [eax + ebx + 8]
    xor eax, edx  
    cmp al, 'v'
    je try_i  
    
    jmp fail
    
try_i:
   mov eax, [img]
    mov eax, [eax + ebx + 12]
    xor eax, edx  
    cmp al, 'i'
    je try_e2
    
    jmp fail
    
try_e2:
   mov eax, [img]
    mov eax, [eax + ebx + 16]
    xor eax, edx  
    cmp al, 'e'
    je try_n
    
    jmp fail
    
try_n:
    mov eax, [img]
    mov eax, [eax + ebx + 20]
    xor eax, edx  
    cmp al, 'n'
    je try_t
    
    jmp fail
    
try_t:
   mov eax, [img]
    mov eax, [eax + ebx + 24]
    xor eax, edx  
    cmp al, 't'
    je success 
        
        
fail:   
    mov dword[line], 0
    add ebx, 4
    
    cmp ebx, [size]
    jne parcurgere
 
    leave
    ret
    
success:
    push edx
    push ebx
    
    mov eax, ebx
    mov ebx, [img_width]
    xor edx, edx
    div ebx
    xor edx, edx
    mov ebx, 4
    div ebx
    
    mov [line], eax
    pop ebx
    pop edx
    

    leave
    ret
afisare_mesaj:
    push ebp
    mov ebp, esp
    
    xor edx, edx
    mov eax, [img_width]
    
    mov ebx, [ebp + 8]
    
    mul ebx
    xor edx, edx
    mov ebx, 4
    mul ebx
    mov ebx, eax
    
    mov edx, [ebp + 12]
    
afisare_loop:
    mov eax, [img]
    mov eax, [eax + ebx]
    add ebx, 4
    xor eax, edx
    PRINT_CHAR al
    cmp al, '.'
    jne afisare_loop
    
    NEWLINE
    
    leave
    ret
    
solve_task1:
    ; TODO Task1
    mov dword[line], 0
    xor edx, edx
    mov eax, [img_width]
    mov ebx, [img_height]
    mul ebx
    xor edx, edx
    mov ebx, 4
    mul ebx
    mov dword[size], eax
    mov edx, 0
loop_xor:
    push edx
    call my_xor
    add esp, 4
    
    cmp dword[line], 0
    jne afisare
    
    inc edx
    cmp edx, 255
    jne loop_xor
    
afisare:   
    push edx
    
    push edx
    push dword[line]
    call afisare_mesaj
    add esp, 4
    
    pop edx
    PRINT_UDEC 4, edx
    NEWLINE
    PRINT_UDEC 4, [line]
    NEWLINE
    
    jmp done
    
add_mesaj_nou:
    push ebp
    mov ebp, esp
    xor ebx, ebx
    xor edx, edx
    
    mov eax, [ebp + 8]
    mov bx, ax
    shr eax, 16
    mov edx, eax
    push edx
    inc ebx
    mov eax, ebx
    mov ebx, 4
    mul ebx
    xor edx, edx
    mov ebx, [img_width]
    mul ebx
    xor edx, edx
    mov ebx, eax
    pop edx
    push ebx
    push edx
    call my_xor_task2
    add esp, 4
    
    pop ebx
    mov eax, [img]
    mov dword[eax + ebx], 'C'
    mov dword[eax + ebx + 4], 39
    mov dword[eax + ebx + 8], 'e'
    mov dword[eax + ebx + 12], 's'
    mov dword[eax + ebx + 16], 't'
    mov dword[eax + ebx + 20], ' '
    mov dword[eax + ebx + 24], 'u'
    mov dword[eax + ebx + 28], 'n'
    mov dword[eax + ebx + 32], ' '
    mov dword[eax + ebx + 36], 'p'
    mov dword[eax + ebx + 40], 'r'
    mov dword[eax + ebx + 44], 'o'
    mov dword[eax + ebx + 48], 'v'
    mov dword[eax + ebx + 52], 'e' 
    mov dword[eax + ebx + 56], 'r'
    mov dword[eax + ebx + 60], 'b'
    mov dword[eax + ebx + 64], 'e'
    mov dword[eax + ebx + 68], ' '
    mov dword[eax + ebx + 72], 'f'
    mov dword[eax + ebx + 76], 'r'
    mov dword[eax + ebx + 80], 'a'
    mov dword[eax + ebx + 84], 'n'
    mov dword[eax + ebx + 88], 'c'
    mov dword[eax + ebx + 92], 'a'
    mov dword[eax + ebx + 96], 'i'    
    mov dword[eax + ebx + 100], 's'
    mov dword[eax + ebx + 104], '.'
    mov dword[eax + ebx + 108], 0
    
    mov eax, edx
    xor edx, edx
    mov ebx, 2
    mul ebx
    xor edx, edx
    add eax, 3
    mov ebx, 5
    div ebx
    sub eax, 4
    
    mov edx, eax
    
    push edx
    call my_xor_task2
    add esp, 4
    
    push dword[img_height]
    push dword[img_width]
    push dword[img]
    call print_image
    add esp, 12
    
    leave    
    ret
    
my_xor_task2:
    push ebp
    mov ebp, esp
    
    mov edx, [ebp + 8]
    
    xor ebx, ebx
loop_my_xor:
    mov eax, [img]
    xor [eax + ebx], edx
    mov eax, [eax + ebx]
    
    add ebx, 4
    
    cmp ebx, dword[size]
    jne loop_my_xor
    
    leave
    ret 

my_xor_task3:
    push ebp
    mov ebp, esp
    
    mov edx, [ebp + 8]
 
    xor ebx, ebx
loop_my_xor3:
    mov eax, [img]
    
    mov eax, [eax + ebx]
    PRINT_CHAR al
    PRINT_CHAR ' '
    add ebx, 4
    
    cmp ebx, dword[size]
    jne loop_my_xor3
    
    leave
    ret 
solve_task2:

     mov dword[line], 0
    xor edx, edx
    mov eax, [img_width]
    mov ebx, [img_height]
    mul ebx
    xor edx, edx
    mov ebx, 4
    mul ebx
    mov dword[size], eax
    mov edx, 0
loop_xor2:
    push edx
    call my_xor
    add esp, 4
    
    cmp dword[line], 0
    jne label_task2
    
    inc edx
    cmp edx, 255
    jne loop_xor2

label_task2:
    xor eax, eax
    mov eax, edx
    shl eax, 16
    add eax, dword[line]
    
    push eax
    call add_mesaj_nou
    add esp, 4
    
    jmp done
    
read_string:
    push ebp
    mov ebp, esp
    
    mov ebx, [ebp + 8]
    xor ecx, ecx
    
    mov eax, [img]
    
loop_read:
    mov esi, [string]
    
    mov edx, [esi + ecx]
    inc ecx
    
    cmp dl, 'A'
    je put_A
    cmp dl, 'B'
    je put_B
    cmp dl, 'C'
    je put_C
    cmp dl, 'D'
    je put_D
    cmp dl, 'E'
    je put_E
    cmp dl, 'F'
    je put_F
    cmp dl, 'G'
    je put_G
    cmp dl, 'H'
    je put_H
    cmp dl, 'I'
    je put_I
    cmp dl, 'J'
    je put_J
    cmp dl, 'K'
    je put_K
    cmp dl, 'L'
    je put_L
    cmp dl, 'M'
    je put_M
    cmp dl, 'N'
    je put_N
    cmp dl, 'O'
    je put_O
    cmp dl, 'P'
    je put_P
    cmp dl, 'Q'
    je put_Q
    cmp dl, 'R'
    je put_R
    cmp dl, 'S'
    je put_S
    cmp dl, 'T'
    je put_T
    cmp dl, 'U'
    je put_U
    cmp dl, 'V'
    je put_V
    cmp dl, 'W'
    je put_W
    cmp dl, 'X'
    je put_X
    cmp dl, 'Y'
    je put_Y
    cmp dl, 'Z'
    je put_Z
    cmp dl, ','
    je put_virgula
    
   
put_A:
    mov [eax + 4 * ebx], dword '.'
    inc ebx    
    mov [eax + 4 * ebx], dword '-'
    inc ebx
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx
    jmp afara
    
put_B:
    mov [eax + 4 * ebx], dword '-'
    inc ebx 
    mov [eax + 4 * ebx], dword '.'
    inc ebx
    mov [eax + 4 * ebx], dword '.'
    inc ebx
    mov [eax + 4 * ebx], dword '.'
    inc ebx
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx
    jmp afara
    

put_C:
    mov [eax + 4 * ebx], dword '-'
    inc ebx    
    mov [eax + 4 * ebx], dword '.'
    inc ebx
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx 
    jmp afara
     
    
put_D:
    mov  [eax + 4 * ebx], dword '-'
    inc ebx    
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx
    jmp afara
    
put_E:
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx
    jmp afara
     
put_F:
    mov  [eax + 4 * ebx], dword '.'
    inc ebx    
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx
    jmp afara
    
put_G:
    mov  [eax + 4 * ebx], dword '-'
    inc ebx    
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx
    jmp afara
    
put_H:
    mov  [eax + 4 * ebx], dword '.'
    inc ebx    
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx
    jmp afara
    
put_I:
    mov  [eax + 4 * ebx], dword '.'
    inc ebx    
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx
    jmp afara
    
put_J:
    mov  [eax + 4 * ebx], dword '.'
    inc ebx    
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx
    jmp afara
    
put_K:
    mov  [eax + 4 * ebx], dword '-'
    inc ebx    
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx
    jmp afara
    
put_L:
    mov  [eax + 4 * ebx], dword '.'
    inc ebx    
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx
    jmp afara
    
put_M:
    mov  [eax + 4 * ebx], dword '-'
    inc ebx    
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx
    jmp afara
    
put_N:
    mov  [eax + 4 * ebx], dword '-'
    inc ebx    
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx
    jmp afara
    
put_O:
    mov  [eax + 4 * ebx], dword '-'
    inc ebx    
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx
    jmp afara
    
put_P:
    mov  [eax + 4 * ebx], dword '.'
    inc ebx    
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx
    jmp afara
    
put_Q:
    mov  [eax + 4 * ebx], dword '-'
    inc ebx    
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx
    jmp afara
    
put_R:
    mov  [eax + 4 * ebx], dword '.'
    inc ebx    
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx
    jmp afara
    
put_S:
    mov  [eax + 4 * ebx], dword '.'
    inc ebx    
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx
    jmp afara
    
put_T:
    mov  [eax + 4 * ebx], dword '-'
    inc ebx 
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx
    jmp afara
    
put_U:
    mov  [eax + 4 * ebx], dword '.'
    inc ebx    
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx  
    jmp afara 
    
put_V:
    mov  [eax + 4 * ebx], dword '.'
    inc ebx    
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx
    jmp afara
    
put_W:
    mov  [eax + 4 * ebx], dword '.'
    inc ebx    
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx   
    jmp afara
    
put_X:
    mov  [eax + 4 * ebx], dword '-'
    inc ebx    
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx
    jmp afara
    
put_Y:
    mov  [eax + 4 * ebx], dword '-'
    inc ebx    
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx  
    jmp afara
    
put_Z:
    mov  [eax + 4 * ebx], dword '-'
    inc ebx    
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov  [eax + 4 * ebx], dword '.'
    inc ebx
    mov [eax + 4 * ebx], dword ' ' 
    inc ebx
    jmp afara
    
put_virgula:
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov  [eax + 4 * ebx], dword '-'
    inc ebx   
    mov  [eax + 4 * ebx], dword '.'
    inc ebx   
    mov  [eax + 4 * ebx], dword '.'
    inc ebx   
    mov  [eax + 4 * ebx], dword '-'
    inc ebx
    mov  [eax + 4 * ebx], dword '-'
    inc ebx  
    mov  [eax + 4 * ebx], dword ' '
    inc ebx    
    jmp afara
      
afara:
    
    cmp byte[esi + ecx], 0
    jne loop_read
    
    dec ebx
    mov [eax + 4 * ebx], dword 0
    
    
    leave
    ret    
    
solve_task3:
    mov eax, dword [ebp + 12]
    
    push eax
    mov ebx, [eax + 16]
    
    push ebx
    call atoi
    add esp, 4
    
    mov ebx, eax
    pop eax
    mov eax, [eax + 12]
    
    mov [string], eax
    
    push ebx
    call read_string
    add esp, 4
    
    push dword[img_height]
    push dword[img_width]
    push dword[img]
    call print_image
    add esp, 12
    
    jmp done
change_lsb:
    push ebp
    mov ebp, esp
    
    mov ebx, [ebp + 8]
    mov eax, [ebp + 12]
    mov ecx, [edi + 4 * ebx]
    
    push ebx
    
    xor ebx, ebx
    mov ebx, 1
   
    and ecx, ebx
    
    pop ebx
    
    cmp cl, 0
    je cl_0
    
    cmp al, 1
    je lsb_out
    
    dec dword[edi + 4 * ebx]
    
    
cl_0:

    cmp al, 0
    je lsb_out
    
    inc dword[edi + 4 * ebx]
    
    
lsb_out:
    
    leave
    ret
    
    
    

LSB:
    push ebp
    mov ebp, esp
    
    mov ebx, [ebp + 8]
    xor ecx, ecx
    
    mov esi, [string]
    mov edi, [img]
    
    xor eax, eax
    dec ebx
loop_LSB:
    mov edx, [esi + ecx]
    inc ecx
    push ecx
    
    mov al, 1
    ror dl, 7
    and al, dl
    push eax
    push ebx
    call change_lsb
    add esp, 8
    inc ebx
    
    
    mov al, 1
    rol dl, 1
    and al, dl
    push eax
    push ebx
    call change_lsb
    add esp, 8
    inc ebx
    
    
    mov al, 1
    rol dl, 1
    and al, dl
    push eax
    push ebx
    call change_lsb
    add esp, 8
    inc ebx
    
    
    mov al, 1
    rol dl, 1
    and al, dl
    push eax
    push ebx
    call change_lsb
    add esp, 8
    inc ebx
    
    mov al, 1
    rol dl, 1
    and al, dl
    push eax
    push ebx
    call change_lsb
    add esp, 8
    inc ebx
    
    mov al, 1
    rol dl, 1
    and al, dl
    push eax
    push ebx
    call change_lsb
    add esp, 8
    inc ebx
    
    
    mov al, 1
    rol dl, 1
    and al, dl
    push eax
    push ebx
    call change_lsb
    add esp, 8
    inc ebx
    
    mov al, 1
    rol dl, 1
    and al, dl
    push eax
    push ebx
    call change_lsb
    add esp, 8
    inc ebx
    pop ecx
    cmp byte[esi + ecx], 0
    jne loop_LSB
    
    mov eax, 0
    push eax
    push ebx
    call change_lsb
    add esp, 8
    inc ebx
    
    mov eax, 0
    push eax
    push ebx
    call change_lsb
    add esp, 8
    inc ebx
    
    mov eax, 0
    push eax
    push ebx
    call change_lsb
    add esp, 8
    inc ebx
    
    mov eax, 0
    push eax
    push ebx
    call change_lsb
    add esp, 8
    inc ebx
    
    mov eax, 0
    push eax
    push ebx
    call change_lsb
    add esp, 8
    inc ebx
    
    mov eax, 0
    push eax
    push ebx
    call change_lsb
    add esp, 8
    inc ebx
    
    mov eax, 0
    push eax
    push ebx
    call change_lsb
    add esp, 8
    inc ebx
    
    mov eax, 0
    push eax
    push ebx
    call change_lsb
    add esp, 8
    inc ebx
    
    
    leave
    ret     
                
solve_task4:
    ; TODO Task4
    mov eax, dword [ebp + 12]
    
    push eax
    mov ebx, [eax + 16]
    
    push ebx
    call atoi
    add esp, 4
    
    mov ebx, eax
    pop eax
    mov eax, [eax + 12]
    
    mov [string], eax
    
    
    push ebx
    call LSB
    add esp, 4
    
    push dword[img_height]
    push dword[img_width]
    push dword[img]
    call print_image
    add esp, 12
    
    jmp done
    
decript_lsb:
    push ebp
    mov ebp, esp
    
    mov ebx, [ebp + 8]
    xor ecx, ecx
    
    mov esi, [string]
    mov edi, [img]
    
    dec ebx
    xor ecx,ecx
    
    mov eax, 8
    jmp loop_decript
loop2:    
    mov eax, 8
    shr cl, 1
    PRINT_CHAR cl
loop_decript:
    push eax
    
    mov eax, 1
    mov edx, [edi + 4 * ebx]
    inc ebx
    and al, dl
    
    add cl, al
    shl cl, 1
    
    pop eax
    dec eax
    cmp eax, 0
    jne loop_decript
    
    cmp cl, 0
    jne loop2
    
    NEWLINE
    leave
    ret
    
solve_task5:
    ; TODO Task5
    mov ebx, [ebp + 12]
    push dword [ebx + 4 * 3]
    call atoi
    add esp, 4
    
    mov ebx, eax
    
    push ebx
    call decript_lsb
    add esp, 4
    
    jmp done
solve_task6:
    ; TODO Task6
    jmp done

    ; Free the memory allocated for the image.
done:
    push DWORD[img]
    call free_image
    add esp, 4
    

    ; Epilogue
    ; Do not modify!
    xor eax, eax
    leave
    ret
    
