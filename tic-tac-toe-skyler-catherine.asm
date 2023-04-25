INCLUDE Irvine32.inc
; Tic Tac Toe by Skyler Troi and Catherine Diresta

; we will start columns, rows at 1, because easier to type.

.data
        title_row1      BYTE "  --------------   -----------   ----------                   --------------   -----------   ----------                   --------------   -----------   ---------- ", 0
        title_row2      BYTE " |              | |           | |          |                 |              | |           | |          |                 |              | |           | |          |", 0
        title_row3      BYTE " |              | |           | |          |                 |              | |    ___    | |          |                 |              | |    ___    | |    ------ ", 0
        title_row4      BYTE "  -----    -----   ---    ----  |    ------    -----------    -----    -----  |   |   |   | |    ------    -----------    -----    -----  |   |   |   | |   |______ ", 0
        title_row5      BYTE "      |    |          |   |     |   |         |           |       |    |      |   |   |   | |   |         |           |       |    |      |   |   |   | |          |", 0
        title_row6      BYTE "      |    |          |   |     |   |         |           |       |    |      |    ---    | |   |         |           |       |    |      |   |   |   | |    ------ ", 0
        title_row7      BYTE "      |    |       ----   ----  |    ------    -----------        |    |      |    ---    | |    ------    -----------        |    |      |   |   |   | |   |       ", 0
        title_row8      BYTE "      |    |      |           | |          |                      |    |      |   |   |   | |          |                      |    |      |    ---    | |    ------ ", 0
        title_row9      BYTE "      |    |      |           | |          |                      |    |      |   |   |   | |          |                      |    |      |           | |          |", 0
        title_row10     BYTE "      ------       -----------   ----------                       ------       ----    ----  ----------                       ------       -----------   ---------- ", 0

        rules   BYTE "Player 1 is X and Player 2 is O. Player 1 goes first every time. First to match three of their symbol wins.",0
      
    winnerX               BYTE "X is the winner",0
    winnerO               BYTE "O is the winner",0
    winnerNo              BYTE "Tie!",0
    enterValidInput       BYTE "Please enter a valid row/col number 0-2",0

    placeX                BYTE "It's your turn X ",0
    placeO                BYTE "It's your turn O ",0

    enterRow              BYTE "Enter row number to place ",0
    enterCol              BYTE "Enter col number to place ",0

    doNotOverwrite        BYTE "Error, there is already a tile at that position. Try again",0
    turn                  DWORD 0      ; 0 for X, 1 for O
    winner                DWORD 2      ; 0 for x, 1 for O, 2 for no winner. Set no winner as default
    printCount            DWORD 0      ; So we can print the grid
    printRowNum           DWORD 1      ; So we know to split the row
    rowChosen             DWORD 0      ; So we know what to add because index is off
    loops DWORD 9 ; there are only 9 grid slots, so we loop 9 times, since we use ja
    count DWORD 0
    ; Squares will be stored as 0 for x, 1 for O, 2 for empty
    ; Goes across rows, then to next col
    square1               BYTE "-",0
    square2               BYTE "-",0
    square3               BYTE "-",0

    square4               BYTE "-",0
    square5               BYTE "-",0
    square6               BYTE "-",0

    square7               BYTE "-",0
    square8               BYTE "-",0
    square9               BYTE "-",0

    indexChosen           DWORD 0
    ; row number * total num, of columns, + column selected.
    grid DWORD square1, square2, square3,
                square4, square5, square6,
                square7, square8, square9

.code

main proc
        ; Prints the title to the screen
        mov edx, OFFSET title_row1
        call    WriteString
        call    Crlf

        mov edx, OFFSET title_row2
        call    WriteString
        call    Crlf

        mov edx, OFFSET title_row3
        call    WriteString
        call    Crlf

        mov edx, OFFSET title_row4
        call    WriteString
        call    Crlf

        mov edx, OFFSET title_row5
        call    WriteString
        call    Crlf

        mov edx, OFFSET title_row6
        call    WriteString
        call    Crlf

        mov edx, OFFSET title_row7
        call    WriteString
        call    Crlf

        mov edx, OFFSET title_row8
        call    WriteString
        call    Crlf

        mov edx, OFFSET title_row9
        call    WriteString
        call    Crlf

        mov edx, OFFSET title_row10
        call    WriteString
        call    Crlf
        call Crlf
        call Crlf


        ; Prints the rules to the screen
        mov edx, OFFSET rules
        call WriteString
        call Crlf
        call Crlf

    mainLoop:

        ; code for placing a tile down
        
        ; code for checking for matches
        cmp count, 0
        ja checkForWinner

        contMainLoop:
            
            mov edx, count
            cmp edx, loops
            ja endProgram
            inc count
            jmp printGrid   ; print the grid; print stuff here
            
            
            printStuff:
            mov printCount, 0
            call    Crlf 
            cmp turn, 0
            je xTurn
            jmp oTurn

            xTurn:
                inc turn
                mov edx, OFFSET placeX ; let the player know its turn X
                jmp input
            oTurn:
                dec turn
                mov edx, OFFSET placeO ; let the player know its turn O
                jmp input

            input:
            call WriteString    ; let player know who's turn it is
            call    Crlf

                                ; Instructions for row, col placement

            mov edx, OFFSET enterRow
            call WriteString
            call    ReadInt ; Ask user for row they want to place
            call    Crlf
            mov ebx, eax    ; so row doesn't get overwritten on read column

            mov edx, OFFSET enterCol
            call WriteString
            call    ReadInt ; Ask user for col they want to place
            call    Crlf

            ; check for valid input (array index exists, and also is empty)
            jmp verifyValidGridPos

            writeToGrid:
            ; Now we overwrite the correct index

            ; row number * total num of columns, + column selected. ebx is row, eax is col
            ; swap regs
            xchg eax, ebx
            mov cx, 3
            ;shl ebx, 1  ; mul row by number of columns (3)
            mul cx
            add eax, ebx ; add column number
            mov indexChosen, eax    ; Store chosenIndex

            shl eax, 2  ; deal with size of
            ; check if grid Pos is already being used
            mov ecx, DWORD PTR [grid + eax]
            mov cl, BYTE PTR [ecx]
            mov dl, 58h
            cmp cl, dl
            je reInput

            mov ecx, DWORD PTR [grid + eax]
            mov cl, BYTE PTR [ecx]
            mov dl, 4fh
            cmp cl, dl
            je reInput
            jmp goodInp
            reInput:
            mov edx, OFFSET doNotOverwrite
            call WriteString
            call    Crlf
            mov edx, OFFSET enterRow
            call WriteString
            
            call    ReadInt ; Ask user for row they want to place
            call    Crlf
            mov ebx, eax    ; so row doesn't get overwritten on read column

            mov edx, OFFSET enterCol
            call WriteString
            call    ReadInt ; Ask user for col they want to place
            call    Crlf

            ; check for valid input (array index exists, and also is empty)
            jmp verifyValidGridPos
            jmp writeToGrid
            goodInp:
            cmp turn, 0
            je oWrite
            jmp xWrite

            oWrite:
                mov ebx, [grid + eax]
                mov BYTE PTR [ebx], 'O'
                jmp mainLoop
            xWrite:
                mov ebx, [grid + eax]
                mov BYTE PTR [ebx], 'X'
                jmp mainLoop
    ; overwrite thing
    checkForWinner:
       ; check to see what kind of checks for matches we must do
       mov ecx, indexChosen
       shl ecx, 2

       mov ebx, DWORD PTR [grid + ecx * TYPE square1] ; our starting value

       ; check for center
       cmp indexChosen, 4
            je center

       ; check for corner matches
       cmp indexChosen, 0
            je corner
       cmp indexChosen, 2
            je corner
       cmp indexChosen, 6
            je corner
       cmp indexChosen, 8
            je corner

        ; check for side matches
       cmp indexChosen, 1
            je side
       cmp indexChosen, 3
            je side
       cmp indexChosen, 5
            je side
       cmp indexChosen, 7
            je side
               

        center:
            ; check for matching on 1, 7; 3, 5; 0, 8; 2, 6.
            center11:   ;check for match on index 1
                mov ecx, 1
                shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                je center12
                jmp center21
            center12:   ; check for match on index 7
                mov ecx, 7
                shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                jne center21
                jmp matchFound

            center21:   ; check for match on index 3
                mov ecx, 3
                shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                je center22
                jmp center31
            center22:   ; check for match on index 5
                mov ecx, 5
                shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                jne center31
                jmp matchFound

            center31:   ; check for match on index 0
                mov ecx, 0
                shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                je center32
                jmp center41
            center32:   ; check for match on index 8
                mov ecx, 8
                shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                jne center41
                jmp matchFound

            center41:   ; check for match on index 2
                mov ecx, 2
                shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                je center42
                jmp noMatch
            center42:   ; check for match on index 6
                mov ecx, 6
                shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                je matchFound
                jmp noMatch
        corner:
            ; check same row, same col, diagonal. if 0 or 8, check left diagnol, otherwise check right diagnol
            cmp indexChosen, 0
                je corner81
                jmp ind8
                corner0:
                    jmp cornerChosen0

            ind8:
            cmp indexChosen, 8
                je corner01
                jmp ind2
                corner8:
                    jmp cornerChosen8

            ind2:
            cmp indexChosen, 2
                je corner61
                jmp ind6
                corner2:
                    jmp cornerChosen2

            ind6:
            cmp indexChosen, 6
                je corner21
                corner6:
                    jmp cornerChosen6


            cornerChosen0:  ; check index 2, 1; 6, 3
                mov ecx, 2
                shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                je index01
                jne index06

                index01:
                    mov ecx, 1
                    shl ecx, 2
                    mov eax, DWORD PTR [grid + ecx]
                    mov cl, BYTE PTR [eax]
                    mov dl, BYTE PTR [ebx]
                    cmp cl, dl
                    je matchFound
                    jne index06
                index06:
                    mov ecx, 6
                    shl ecx, 2
                    mov eax, DWORD PTR [grid + ecx]
                    mov cl, BYTE PTR [eax]
                    mov dl, BYTE PTR [ebx]
                    cmp cl, dl
                    je index03
                    jne noMatch
                index03:
                    mov ecx, 3
                    shl ecx, 2
                    mov eax, DWORD PTR [grid + ecx]
                    mov cl, BYTE PTR [eax]
                    mov dl, BYTE PTR [ebx]
                    cmp cl, dl
                    je matchFound
                    jne noMatch
            cornerChosen8:  ; check index 6, 7; 2, 5
                mov ecx, 6
                shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                je index87
                jne index82

                index87:
                    mov ecx, 7
                    shl ecx, 2
                    mov eax, DWORD PTR [grid + ecx]
                    mov cl, BYTE PTR [eax]
                    mov dl, BYTE PTR [ebx]
                    cmp cl, dl
                    je matchFound
                    jmp index82
                index82:
                    mov ecx, 2
                    shl ecx, 2
                    mov eax, DWORD PTR [grid + ecx]
                    mov cl, BYTE PTR [eax]
                    mov dl, BYTE PTR [ebx]
                    cmp cl, dl
                    je index85
                    jmp noMatch
                index85:
                    mov ecx, 5
                    shl ecx, 2
                    mov eax, DWORD PTR [grid + ecx]
                    mov cl, BYTE PTR [eax]
                    mov dl, BYTE PTR [ebx]
                    cmp cl, dl
                    je matchFound
                    jmp noMatch

            cornerChosen2:  ; check index 0, 1; 5, 8
                mov ecx, 0
                shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                je index21
                jne index25

                index21:
                    mov ecx, 1
                    shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                    je matchFound
                    jne index25
                index25:
                    mov ecx, 5
                    shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                    je index28
                    jne noMatch
                index28:
                    mov ecx, 8
                    shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                    je matchFound
                    jne noMatch
            cornerChosen6:  ; check index 7, 8; 0, 3
                mov ecx, 7
                shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                je index68
                jne index60

                index68:
                    mov ecx, 8
                    shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                    je matchFound
                    jne index60
                index60:
                    mov ecx, 0
                    shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                    je index63
                    jne noMatch
                index63:
                    mov ecx, 3
                    shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                    je matchFound
                    jne noMatch
            corner01:
                mov ecx, 0
                shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                je cornerCenter
                jmp corner8
            corner81:
                mov ecx, 8
                shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                je cornerCenter
                jmp corner0
            corner61:
                mov ecx, 6
                shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                je cornerCenter
                jmp corner2
            corner21:
                mov ecx, 2
                shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                je cornerCenter
                jmp corner6

            cornerCenter:   ; check for match on index 4 (center)
                mov ecx, 4
                shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                    je matchFound
                cmp indexChosen, 0
                    jmp corner0
                cmp indexChosen, 2
                    jmp corner2
                cmp indexChosen, 6
                    jmp corner6
                cmp indexChosen, 8
                    jmp corner8


        side:
            ; check for matching on same row, same col
            cmp indexChosen, 1  ; check matching 0, 2; 4,7
                je cols1a
                jmp inds7
                colNo1:
                    jmp rows0
            inds7:
            cmp indexChosen, 7 ; check matching 6, 8; 4,7
                je cols1b
                jmp inds3
                colNo7:
                    jmp rows2
            inds3:
            cmp indexChosen, 3 ; check matching 4, 5; 0, 6
                je cols0
                jmp inds5
                colNo3:
                    jmp rows1a
            inds5:
            cmp indexChosen, 5 ; check matching 4, 5; 2, 8
                je cols2
                colNo5:
                    jmp rows1b

            rows0:
                rind0:
                    mov ecx, 0
                    shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                    je rind2
                    jmp noMatch
                rind2:
                    mov ecx, 2
                    shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                    je matchFound
                    jmp noMatch
            rows1a:
                rind4a:
                    mov ecx, 4
                    shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                    je rind5a
                    jmp noMatch
                rind5a:
                    mov ecx, 5
                    shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                    je matchFound
                    jmp noMatch
            rows1b:
                rind3b:
                    mov ecx, 3
                    shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                    je rind4b
                    jmp noMatch
                rind4b:
                    mov ecx, 4
                    shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                    je matchFound
                    jmp noMatch
            rows2:
                rind6:
                    mov ecx, 6
                    shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                    je rind8
                    jmp noMatch
                rind8:
                    mov ecx, 8
                    shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                    je matchFound
                    jmp noMatch

            cols0:
                cind0:
                    mov ecx, 0
                    shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                    je cind6
                    jmp colNo3
                cind6:
                    mov ecx, 6
                    shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                    je matchFound
                    jmp colNo3
            cols1a:
                cind7:
                    mov ecx, 7
                    shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                    je mida
                    jmp colNo1
            cols1b:
                cind1:
                    mov ecx, 1
                    shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                    je midb
                    jmp colNo7
            cols2:
                cind2:
                    mov ecx, 2
                    shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                    je cind8
                    jmp colNo5
                cind8:
                    mov ecx, 8
                    shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                    je matchFound
                    jmp colNo5
            mida:
                mov ecx, 4
                shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                je matchFound
                jmp colNo1
            midb:
                mov ecx, 4
                shl ecx, 2
                mov eax, DWORD PTR [grid + ecx]
                mov cl, BYTE PTR [eax]
                mov dl, BYTE PTR [ebx]
                cmp cl, dl
                je matchFound
                jmp colNo7

       matchFound:
            cmp turn, 0
            je oWon
            jmp xWon
            
            oWon:
            mov edx, OFFSET winnerO
            call WriteString
            call    Crlf
            jmp endProgram

            xWon:
            mov edx, OFFSET winnerX
            call WriteString
            call    Crlf
            jmp endProgram

       noMatch:
            mov ecx, count
            cmp ecx, loops
            jge lastTurn
            jmp contMainLoop    ; jump back to mainLoop if no matches

            lastTurn:           ; no matches at end of game
            mov edx, OFFSET winnerNo
            call WriteString
            call    Crlf
            jmp contMainLoop    ; jump back to mainLoop if no matches
                

    printGrid:
       loopPrint:
            mov ebx, SIZEOF grid
            mov ecx, printCount
            shl ecx, 2
            mov edx, [grid + [ecx]]
            call WriteString
            inc printCount
            cmp printCount, 3   ; did we print last in row?
            je incRow
            cmp printCount, 6   ; did we print last in row?
            je incRow
            cmp printCount, 9   ; are we done printing the grid?
                je checkEnd
            jmp loopPrint

        incRow:
            call    Crlf
            jmp loopPrint
        checkEnd:
            mov edx, count
            cmp edx, loops
                ja endCont
            jmp printStuff

    verifyValidGridPos:

    ; ebx is row, eax is col
    cmp ebx, 2
    ja invalidGridPos
    cmp eax, 2
    ja invalidGridPos
    jmp writeToGrid

    invalidGridPos:     ; re-ask for input 
    mov edx, OFFSET enterValidInput
    call WriteString
    call    Crlf

    mov edx, OFFSET enterRow
    call WriteString
    call    ReadInt ; Ask user for row they want to place
    call    Crlf
    mov ebx, eax    ; so row doesn't get overwritten on read column
    mov edx, OFFSET enterCol
    call WriteString
    call    ReadInt ; Ask user for col they want to place
    call    Crlf

    jmp verifyValidGridPos  ; Verify new input


    endProgram:
        mov count, 10
        jmp printGrid   ; print the grid; print stuff here
    endCont:
        
exit
main endp

end main
    
    
    
