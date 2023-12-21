#!/bin/bash


diretorio_tarefas="tarefas"

if [ ! -d "$diretorio_tarefas" ]; then
  mkdir "$diretorio_tarefas"
fi

adicionar_tarefa() {
  descricao_tarefa=$(dialog --inputbox "Informe a descrição da tarefa:" 8 40 3>&1 1>&2 2>&3)
  
  
  echo "$descricao_tarefa" >> "$diretorio_tarefas/tarefas.txt"

  
  dialog --infobox "Tarefa '$descricao_tarefa' adicionada com sucesso." 8 40
  sleep 2
}

listar_tarefas() {
  if [ -s "$diretorio_tarefas/tarefas.txt" ]; then
    tarefas=$(cat "$diretorio_tarefas/tarefas.txt")
    dialog --msgbox "Lista de Tarefas:\n$tarefas" 12 40
  else
    dialog --msgbox "Nenhuma tarefa cadastrada." 8 40
  fi
}

remover_tarefa() {
  if [ -s "$diretorio_tarefas/tarefas.txt" ]; then
    opcoes=()
    while IFS= read -r linha; do
      opcoes+=("$linha" "")
    done < "$diretorio_tarefas/tarefas.txt"

    numero_tarefa=$(dialog --menu "Escolha uma tarefa para remover:" 12 40 5 "${opcoes[@]}" 3>&1 1>&2 2>&3)

    if [ "$numero_tarefa" ]; then
      sed -i "${numero_tarefa}d" "$diretorio_tarefas/tarefas.txt"
      awk '{$1=$1}1' "$diretorio_tarefas/tarefas.txt" > "$diretorio_tarefas/tarefas_temp.txt" && mv "$diretorio_tarefas/tarefas_temp.txt" "$diretorio_tarefas/tarefas.txt"
      dialog --infobox "Tarefa removida com sucesso." 8 40
      sleep 2
    fi
  else
    dialog --msgbox "Nenhuma tarefa para remover." 8 40
  fi
}

dialogo() {
  dialog --title "TechCo - Sistema de Gerenciamento de Tarefas" --msgbox "Bem-vindo! Escolha uma opção:" 8 40
}

opcao=""

while [ "$opcao" != "4" ]; do
  dialogo
  opcao=$(dialog --menu "Menu" 12 40 5 1 "Adicionar Tarefa" 2 "Listar Tarefas" 3 "Remover Tarefa" 4 "Sair" 3>&1 1>&2 2>&3)

  case $opcao in
    1)
      adicionar_tarefa
      ;;
    2)
      listar_tarefas
      ;;
    3)
      remover_tarefa
      ;;
    4)
      dialog --infobox "Saindo do sistema. Até mais!" 8 40
      sleep 2
      ;;
    *)
      dialog --msgbox "Opção inválida. Tente novamente." 8 40
      ;;
  esac
done
