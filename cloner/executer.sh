#!/bin/bash

. $(dirname $0)/partition.sh

. $(dirname $0)/restore.sh

# execute each operations

execute() {
  local t

  # check the taks
  for t in $*
  do
    case $t in
      "CREATE_TABLE"|"CREATE_PARTITIONS"|"RESTORE_RECU"|"RESTORE_DATA"|"MOUNT"|"COPY_IMG_GNU"|"COPY_IMG_WIN"|"RESTORE_GNU"|"RESTORE_WIN")
      ;;
      *)
      echo_error "Unknown task $t"
      exit 1
      ;;
    esac
  done

  # init the drbl
  if !(restore_init)
  then
    echo_error "Tratando de iniciar drbl"
    exit 1
  fi

  for t in $*
  do
    case $t in
      "CREATE_TABLE")
        if !(create_table)
        then
          echo_error "Tratando de crear tabla de particiones en $DISK_FULLNAME"
          exit 1
        fi
      ;;
      "CREATE_PARTITIONS")
        if !(create_partitions)
        then
          echo_error "Tratando particiones en $DISK_FULLNAME"
          exit 1
        fi
      ;;
      "RESTORE_RECU")
        if !(restore_recu)
        then
          echo_error "Restaurando particion de recuperacion en $DISK_FULLNAME"
          exit 1
        fi
      ;;
      "RESTORE_DATA")
        if !(restore_data)
        then
          echo_error "Restaurando particion de Datos en $DISK_FULLNAME"
          exit 1
        fi
      ;;
      "MOUNT")
        if !(mount_partitions)
        then
          echo_error "Montando particiones"
          exit 1
        fi
      ;;
      "COPY_IMG_GNU")
        if !(copy_img_gnu)
        then
          echo_error "Copiando imagen GNU/Linux"
          exit 1
        fi
      ;;
      "COPY_IMG_WIN")
        if !(copy_img_win)
        then
          echo_error "Copiando imagen Windows"
          exit 1
        fi
      ;;
      "RESTORE_GNU")
        if !(restore_gnu)
        then
          echo_error "Restaurando imagen GNU/Linux"
          exit 1
        fi
      ;;
      "RESTORE_WIN")
        if !(restore_win)
        then
          echo_error "Restaurando imagen Windows"
          #exit 1
        fi
      ;;
    esac
  done
}
