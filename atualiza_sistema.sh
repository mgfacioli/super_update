#! /bin/bash

#================================================================
# Criado por: Marcelo G Facioli
# Dt Criacao: 28/02/2024
#
# Objetivo: Um script para atualizacao do sistema Linux, utilizando apt, mas com algumas opcoes basicas
#================================================================

# ====== variáveis globais ======
day_week_name=$(date +%A)
ano=$(date +%y)
mes=$(date +%m)
case "$mes" in
    01) n_mes="jan";;
    02) n_mes="fev";;
    03) n_mes="mar";;
    04) n_mes="abr";;
    05) n_mes="mai";;
    06) n_mes="jun";;
    07) n_mes="jul";;
    08) n_mes="ago";;
    09) n_mes="set";;
    10) n_mes="out";;
    11) n_mes="nov";;
    12) n_mes="dez";;
esac
dirMensal=""$mes"_"$n_mes$(date +%Y)""
dia=$(date +%d)
#dia=22
time=$(date +%T)
DELAY=10 # Number of seconds to display results


# ====== funcoes do projeto ======
function separador {
    echo -e "================================================================================\n"
    return
}

function cabec_abertura {
    clear
    separador
    echo -e "Iniciando processo de upgrade do sistema!!\t\tData ${dia}/${mes}/${ano}, ${time}.\n"
    echo -e "Host: $HOSTNAME\t\t\tUser:$USER"
    separador
}



# ====== main ======

while true; do
    # clear
    cabec_abertura

cat <<- _EOF_
    Please Select:
    1. Fazer Update
    2. Quantidade de pacotes Atualizáveis
    3. Listar Pacotes Atualizáveis
    4. Fazer Upgrade
    0. Quit

_EOF_
    read -p "Enter selection [0-3] > "

    if [[ "$REPLY" =~ ^[0-4]$ ]]; then
        if [[ "$REPLY" == 1 ]]; then
            sudo apt update
            sleep "$DELAY"
            continue
        fi
        if [[ "$REPLY" == 2 ]]; then
            total=$(apt list --upgradable | wc -l)
            echo "Qtd. total de pacotes atualizáveis: $total." 
            sleep "$DELAY"
            continue
        fi        
        if [[ "$REPLY" == 3 ]]; then
            sudo apt list --upgradable | tee /media/mgfacioli/PortableSSD/Learning/Linux/Bash_scripts/super_update/log_atualizacao.txt
            sleep "$DELAY"
            continue
        fi
        if [[ "$REPLY" == 4 ]]; then
            read -p "Iniciar o Upgrade? [s/n] > "
            if [[ "$REPLY" == 's' ]]; then
                echo "Upgrade já vai começar!!"
                sleep "$DELAY"
                sudo apt upgrade
                sleep "$DELAY"
                continue
            elif [[ "$REPLY" == 'n' ]]; then
                echo "Upgrade Cancelado!!"
                sleep "$DELAY"
                continue
            else
                echo "Entrada inválida."
                sleep "$DELAY"
            fi
        fi
        if [[ "$REPLY" == 0 ]]; then
            break
        fi
    else
        echo "Entrada inválida."
        sleep "$DELAY"
    fi
done
echo "Atualização Encerrada."



# echo "==============================" >> /home/mgfacioli/Documentos/processo.log
# echo "Processo realizado em ${dia}/${mes}/${ano}, ${time}." >> /home/mgfacioli/Documentos/processo.log
# echo "Verfificando atualizacoes disponiveis..."

# apt list --upgradable

# total=$(apt list --upgradable | wc -l)
# echo "==================================" >> /home/mgfacioli/Documentos/processo.log
# echo "Total de $total atualizacoes." >> /home/mgfacioli/Documentos/processo.log
# echo "==================================" >> /home/mgfacioli/Documentos/processo.log
