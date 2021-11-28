echo "Witaj w grze kółko i krzyżyk"

BOARD=("0" "0" "0" "0" "0" "0" "0" "0" "0")
END_GAME=0
CURRENT_PLAYER=1
GAME_MODE=1
MOVE_COUNT=0

function printOne {
    if [ $1 -eq "0" ] 
    then
        echo "-"
    elif [ $1 -eq "1" ] 
    then
        echo "X"
    elif [ $1 -eq "2" ] 
    then
        echo "O"
    fi
}

function display {
    for row in {0..2}
    do
        echo "$(printOne ${BOARD[row*3]}) $(printOne ${BOARD[1+row*3]}) $(printOne ${BOARD[2+row*3]})"
    done
}

function check {
    if [ "${BOARD[0]}" -ne "0" ] && [ "${BOARD[0]}" -eq "${BOARD[4]}" ] && [ "${BOARD[4]}" -eq "${BOARD[8]}" ] 
        then 
            END_GAME="1"
        elif [ "${BOARD[6]}" -ne "0" ] && [ "${BOARD[6]}" -eq "${BOARD[4]}" ] && [ "${BOARD[4]}" -eq "${BOARD[2]}" ]
        then
            END_GAME="1"
        fi 
    for row in {0..2}
	do
        FIELD=row*3
        if [ "${BOARD[FIELD]}" -ne "0" ] && [ "${BOARD[FIELD]}" -eq "${BOARD[FIELD+1]}" ] && [ "${BOARD[FIELD+1]}" -eq "${BOARD[FIELD+2]}" ]
        then
            END_GAME="1"
        elif [ "${BOARD[row]}" -ne "0" ] && [ "${BOARD[row]}" -eq "${BOARD[row+3]}" ] && [ "${BOARD[row+3]}" -eq "${BOARD[row+6]}" ]
        then
            END_GAME="1"
        fi
	done
    if [ $MOVE_COUNT -eq "9" ] && [ $END_GAME -eq "0" ]
    then
        echo "Gra zakończyła się remisem"
        END_GAME=2
    fi

    if [ $END_GAME -eq "1" ]
    then
        if [ $CURRENT_PLAYER -eq "1" ]
        then
            echo "Wygrał X"
        else
            echo "Wygrało O"
        fi
    fi
}

function player_move {
    MOVE_SUCCESSFUL=0
    while [ ${MOVE_SUCCESSFUL} -eq "0" ]
    do
        if [ $CURRENT_PLAYER -eq "1" ]
        then
            echo "Ruch gracza X"
        else
            echo "Ruch gracza O"
        fi

        read -p "Podaj wiersz: " row
        read -p "Podaj kolumnę: " column

        if [ "$row" -gt "0" ] && [ "$row" -lt "4" ] && [ "$column" -gt "0" ] && [ "$column" -lt "4" ]  && [ "${BOARD[((row-1)*3)+column-1]}" -eq "0" ]
        then
            
            BOARD[((row-1)*3)+column-1]=$CURRENT_PLAYER
            MOVE_SUCCESSFUL=1
            MOVE_COUNT=$((MOVE_COUNT+1))
            echo "Wykonano ruch"
        else
            echo "Nieprawidłowy ruch"
        fi
    done
}

function random_move {
    echo "Komputer wykonuje ruch"
    MOVE_SUCCESSFUL="0"
    while [ $MOVE_SUCCESSFUL -eq "0" ]
    do
        FIELD=$(( ( RANDOM % 9 )  + 1 ))
        if [ "${BOARD[FIELD]}" -eq "0" ]
        then
            BOARD[FIELD]="2"
            MOVE_SUCCESSFUL="1"
            MOVE_COUNT=$((MOVE_COUNT+1))
        fi
    done
}

function change_player {
    if [ $CURRENT_PLAYER -eq "1" ]
    then
        CURRENT_PLAYER=2
    else
        CURRENT_PLAYER=1
    fi
}

function human_move {
    player_move
    display
    check
    change_player
}


read -p "Wybierz tryb gry, 1 - dwóch graczy przy jednym komputerze, 2 - graj przeciwko komputerowi:" GAME_MODE
echo "Aby wykonać ruch podaj wiersz i kolumnę, w której chcesz postawić krzyżyk."
display
while [ $END_GAME -eq "0" ]
do  
    if [ $GAME_MODE -eq "1" ]
    then
        human_move
    else
        if [ $CURRENT_PLAYER -eq "1" ]
        then
            human_move
        else
            random_move
            display
            check
            change_player
        fi
    fi
done
