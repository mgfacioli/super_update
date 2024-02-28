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

echo "==============================" >> /home/mgfacioli/Documentos/processo.log
echo "Processo realizado em ${dia}/${mes}/${ano}, ${time}." >> /home/mgfacioli/Documentos/processo.log
echo "Verfificando atualizacoes disponiveis..."

apt update
apt list --upgradable

total=$(apt list --upgradable | wc -l)
echo "==================================" >> /home/mgfacioli/Documentos/processo.log
echo "Total de $total atualizacoes." >> /home/mgfacioli/Documentos/processo.log
echo "==================================" >> /home/mgfacioli/Documentos/processo.log
