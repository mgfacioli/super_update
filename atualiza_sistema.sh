#! /bin/bash

#================================================================
# Criado por: Marcelo G Facioli
# Dt Criacao: 28/02/2024
#
# Objetivo: Um script para atualizacao do sistema Linux, utilizando apt, mas com algumas opcoes basicas
#================================================================

# ======== diretiva =======
# Capturando CTRL C caso usuário interrompa o script antes da conclusão do processo de atualização.
trap ctrl_c INT

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

function ctrl_c() {
    echo -e "\n"
    rodape "Você tentou encerrar script com Ctrl + C.\nPor favor, utilize a opção Q do menu principal para encerrar corretamente." 10
    return
}


function separador {
    echo -e "================================================================================"
    return
}

function cabec_abertura {
    separador
    echo -e "Iniciando processo de upgrade do sistema!!\t\tData ${dia}/${mes}/${ano}, ${time}."
    echo -e "Host: $HOSTNAME\t\t\t\t\tUser:$USER"
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

write_html_page () {
cat <<- _EOF_
<html>
<head>
<style>
/* Style all elements with the class name "cabec_pagina" */
.cabec_pagina {
  background-color: tomato;
  color: white;
  padding: 40px;
  text-align: center;
} 
/* Style all elements with the class name "cabec_autaliza" */
.cabec_autaliza {
  background-color: lightblue;
  color: black;
  padding: 10px;
} 
/* Style all elements with the class name "sep" */
.sep {
  background-color: lightblue;
  color: black;
  padding: 10px;
} 
</style>
<title>Relatório de Atualização do Sistema</title>
</head>
<body>
<h1 class="cabec_pagina">Relatório de Atualização do Sistema</h1>
<pre class="cabec_autaliza">$(cabec_abertura)</pre>
$1
$2
$3
<pre class="sep">$(separador)</pre>
</body>
</html>
_EOF_
return
}

report_update () {
cat <<- _EOF_
<h2>Resultado Apt Update</h2>
<pre>$1</pre>
_EOF_
return
}

report_upgradables () {
cat <<- _EOF_
<h2>Resultado Apt List --Upgradables</h2>
<pre>$1</pre>
_EOF_
return
}

report_upgrade () {
cat <<- _EOF_
<h2>Resultado Apt Upgrade</h2>
<pre>$1</pre>
_EOF_
return
}

end_report () {
    path_to_log="/media/mgfacioli/PortableSSD/Learning/Linux/Bash_scripts/super_update/"
    log_filename="log_atualizacao_[${dia}/${mes}/${ano}]_[${time}].html"

    write_html_page "$(echo -e "$(report_update "$update_output")")"  \
                    "$(echo -e "$(report_upgradables "$lista_pacotes")")" \
                    "$(echo -e "$(report_upgrade "$upgrade_output")")" >> "$path_to_log$log_filename"
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
            end_report
            exit
        ;;
        a|A) rodape "Update já vai começar!!" 2
            update_output=$(sudo apt update)
            echo "$update_output"
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
                s|S) rodape "O Upgrade está em andamento. Aguarde...!!"
                    upgrade_output=$(sudo apt upgrade --assume-yes)
                    echo "$upgrade_output"
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