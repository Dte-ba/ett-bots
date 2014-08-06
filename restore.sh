#!/bin/bash
# description: clone functions

restore_init(){
  DRBL_SCRIPT_PATH="${DRBL_SCRIPT_PATH:-/usr/share/drbl}"

  . $DRBL_SCRIPT_PATH/sbin/drbl-conf-functions
  . /etc/drbl/drbl-ocs.conf
  . $DRBL_SCRIPT_PATH/sbin/ocs-functions

  # load the setting for clonezilla live.
  [ -e /etc/ocs/ocs-live.conf ] && . /etc/ocs/ocs-live.conf

  # bind the live image repository
  log "Mounting the live-image point"
  log "mount --bind $IMAGES_SOURCE /home/partimag/"
  mount --bind $IMAGES_SOURCE /home/partimag/
}

restore_part(){
 log "ocs-sr -g auto -e1 auto --batch --nogui -b -e2 -r -j2 -k -p true -t restoreparts $1 $2"
 ocs-sr -g auto -e1 auto -batch -nogui -b -e2 -r -j2 -k -p true -t restoreparts $1 $2
}

restore_recu(){
 restore_part "$RECOVERY_IMG_NAME" "${DISK}4"
 echo_ok "Recovery partition restored"
}

restore_data(){
 restore_part "$DATA_IMG_NAME" "${DISK}6"
 echo_ok "Data partition restored"
}

mount_partitions(){
  IMAGES_POINT="/home/rdisk/home/partimag"

  mkdir -p /home/rdisk/
  mount /dev/${DISK}4 /home/rdisk/
  mkdir -p $IMAGES_POINT

  mount --bind $IMAGES_POINT /home/partimag/
  swapon /dev/${DISK}5

  echo_ok "Partitions and image repository changed"
}

copy_img_gnu(){
 rsync -ah --progress ${IMAGES_SOURCE}${GNU_IMG_NAME} /home/partimag
 echo_ok "Imagen GNU/Linux copiada" 
}

copy_img_win(){
 rsync -ah --progress ${IMAGES_SOURCE}${WIN_IMG_NAME} /home/partimag
 echo_ok "Imagen Windows copiada"
}

restore_gnu(){
 restore_part "$GNU_IMG_NAME" "${DISK}2"
 echo_ok "imagen de GNU/Linux restaurada"
}

restore_win(){
 restore_part "$WIN_IMG_NAME" "${DISK}1"
 echo_ok "Imange de Windows restaurada"
}

grub_install(){

	grub-install --boot-directory=/home/rdisk/boot /dev/${DISK}
	
	grub-install --recheck --boot-directory=/home/rdisk/boot  /dev/${DISK}

	#mount --bind /dev /home/rdisk/dev
	#mount --bind /dev/pts /home/rdisk/dev/pts
	#mount --bind /proc /home/rdisk/proc
	#mount --bind /sys /home/rdisk/sys
	#	
	#chroot /home/rdisk
	#	
	#grub-install --boot-directory=/home/rdisk/boot /dev/${DISK}
	#	
	#grub-install --recheck --boot-directory=/home/rdisk/boot  /dev/${DISK}
	#	
	#update-grub
	#	
	#umount /home/rdisk/sys
	#umount /home/rdisk/proc
	#umount /home/rdisk/dev/pts
	#umount /home/rdisk/dev
	#umount /home/rdisk
	
	echo_ok "GRUB instalado"
}
