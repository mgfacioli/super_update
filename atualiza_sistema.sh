#! /bin/bash


echo "Verfificando atualizacoes disponiveis..."

apt update
apt list --upgradable

total=$(apt list --upgradable | wc -l)
echo "=================================="
echo "Total de $total atualizacoes."
echo "=================================="
