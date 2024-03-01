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



# ====== funcoes do projeto ======
function separador {
    echo -e "================================================================================"
    return
}

function cabec_abertura {
    separador
    echo -e "Iniciando processo de upgrade do sistema!!\t\tData ${dia}/${mes}/${ano}, ${time}."
    echo -e "Host: $HOSTNAME\t\t\tUser:$USER"
    separador
}

function rodape () {
    if [ -z "$2" ]; then
        DELAY=5
    else
        DELAY="$2"
    fi
    separador
    echo -e "$1"
    separador
    sleep "$DELAY" 
}

# ====== main ======

while true; do
    time=$(date +%T)  #Horário da execução. Esta variável tem que estar aqui para que seja atualizada em cada loop.

    clear
    cabec_abertura

cat <<- _EOF_
    Selecione:
    A. Fazer Update
    B. Listar Pacotes Atualizáveis
    C. Fazer Upgrade
    Q. Quit

_EOF_
    read -p "Opção [A, B, C, D ou Q] > "

    case "$REPLY" in
        q|Q) rodape "Programa encerrado!" 2
            exit
        ;;
        a|A) rodape "Update já vai começar!!" 2
            sudo apt update
            rodape "Update finalizado!!!"
        ;;
        b|B) rodape "Verificando total de pacotes atualizáveis. Aguarde..." 2
            lista_pacotes=$(sudo apt list --upgradable)
            total=$(echo $(echo "$lista_pacotes" | tail -n +2 | wc -l))
            case "$total" in
                0) rodape "Não há pacotes a serem atualizados."
                ;;
                *) rodape "Qtd. total de pacotes atualizáveis: $total."
                    read -p "Deseja listar pacotes atualizáveis? [s/n] > "
                    clear
                    case "$REPLY" in
                        s|S) rodape "Gerando lista de pacotes atualizáveis." 2
                            echo "$lista_pacotes"
                            relatorio=$(cabec_abertura)""$(echo -e "\n$lista_pacotes")"\n"$(separador)"\n\n"
                            echo -e "$relatorio" >> /media/mgfacioli/PortableSSD/Learning/Linux/Bash_scripts/super_update/log_atualizacao.txt
                            rodape "Listagem finalizada!!!" 5
                        ;;
                        n|N) rodape "Cancelando." 2
                        ;;
                        *) rodape "Entrada inválida. Digite s ou n."
                        ;;
                    esac
                ;;
            esac
        ;;
        c|C) read -p "Iniciar o Upgrade? [s/n] > "
            case "$REPLY" in
                s|S) rodape "Upgrade já vai começar!!"
                    sudo apt upgrade
                    rodape "Upgrade finalizado!!!" 2
                ;;
                n|N) rodape "Upgrade Cancelado!!" 2
                ;;
                *) rodape "Entrada inválida. Digite s ou n." 
                ;;
            esac
        ;;
        *) rodape "Entrada inválida. Digite uma letra do menu..."
        ;;
    esac
done