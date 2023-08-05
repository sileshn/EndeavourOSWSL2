OUT_ZIP=EndeavourOSWSL2.zip
LNCR_EXE=EndeavourOS.exe

DLR=curl
DLR_FLAGS=-L
LNCR_ZIP_URL=https://github.com/yuk7/wsldl/releases/download/23072600/icons.zip
LNCR_ZIP_EXE=EndeavourOS.exe

all: $(OUT_ZIP)

zip: $(OUT_ZIP)
$(OUT_ZIP): ziproot
	@echo -e '\e[1;31mBuilding $(OUT_ZIP)\e[m'
	cd ziproot; bsdtar -a -cf ../$(OUT_ZIP) *

ziproot: Launcher.exe rootfs.tar.gz
	@echo -e '\e[1;31mBuilding ziproot...\e[m'
	mkdir ziproot
	cp Launcher.exe ziproot/${LNCR_EXE}
	cp rootfs.tar.gz ziproot/

exe: Launcher.exe
Launcher.exe: icons.zip
	@echo -e '\e[1;31mExtracting Launcher.exe...\e[m'
	unzip icons.zip $(LNCR_ZIP_EXE)
	mv $(LNCR_ZIP_EXE) Launcher.exe

icons.zip:
	@echo -e '\e[1;31mDownloading icons.zip...\e[m'
	$(DLR) $(DLR_FLAGS) $(LNCR_ZIP_URL) -o icons.zip

rootfs.tar.gz: rootfs
	@echo -e '\e[1;31mBuilding rootfs.tar.gz...\e[m'
	cd rootfs; sudo bsdtar -zcpf ../rootfs.tar.gz `sudo ls`
	sudo chown `id -un` rootfs.tar.gz

rootfs: base.tar
	@echo -e '\e[1;31mBuilding rootfs...\e[m'
	mkdir rootfs
	sudo bsdtar -zxpf base.tar -C rootfs
	@echo "# This file was automatically generated by WSL. To stop automatic generation of this file, remove this line." | sudo tee rootfs/etc/resolv.conf > /dev/null
	sudo cp wsl.conf rootfs/etc/wsl.conf
	sudo cp -f setcap-iputils.hook rootfs/etc/pacman.d/hooks/50-setcap-iputils.hook
	sudo cp bash_profile rootfs/root/.bash_profile
	sudo chmod +x rootfs

base.tar:
	@echo -e '\e[1;31mExporting base.tar using docker...\e[m'
	docker run --net=host --ulimit nofile=1024:10240 --name endeavouroswsl archlinux:base-devel /bin/bash -c "pacman --noconfirm --needed -Sy archlinux-keyring pacman-contrib reflector rsync; reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist; pacman-key --init; pacman-key -r 497AF50C92AD2384C56E1ACA003DB8B0CB23504F; pacman-key --lsign-key 497AF50C92AD2384C56E1ACA003DB8B0CB23504F; curl -s https://gitlab.com/endeavouros-filemirror/EndeavourOS-ISO/-/raw/main/airootfs/etc/pacman.conf > /etc/pacman.conf; curl -s https://gitlab.com/endeavouros-filemirror/PKGBUILDS/-/raw/master/endeavouros-mirrorlist/endeavouros-mirrorlist > /etc/pacman.d/endeavouros-mirrorlist; sed -ibak -e 's/#Color/Color/g' -e 's/CheckSpace/#CheckSpace/g' /etc/pacman.conf; sed -ibak -e 's/IgnorePkg/#IgnorePkg/g' /etc/pacman.conf; pacman --noconfirm --needed -Sy endeavouros-keyring; pacman --noconfirm -Syyu; pacman-key --populate; pacman --noconfirm --needed -Sy aria2 aspell autoconf-archive base-devel bc ccache dconf dnsutils docbook-xsl dos2unix doxygen endeavouros-mirrorlist eos-apps-info eos-hooks eos-log-tool eos-packagelist eos-rankmirrors figlet git grep hspell hunspell inetutils iputils iproute2 keychain libxcrypt-compat libvoikko linux-tools lolcat lsb-release man nano ntp nuspell openssh procps rate-mirrors reflector-simple socat sudo usbutils vi vim wget xdg-utils xmlto yay yelp-tools; wget https://pkg.wslutiliti.es/public.key && pacman-key --add public.key && rm ./public.key && pacman-key --lsign-key 2D4C887EB08424F157151C493DD50AA7E055D853; echo '[wslutilities]' | sudo tee -a /etc/pacman.conf >/dev/null 2>&1; echo 'Server = https://pkg.wslutiliti.es/arch/' | sudo tee -a /etc/pacman.conf >/dev/null 2>&1; pacman -Sy wslu; pacman --noconfirm -Rdd dbus; mkdir -p /etc/pacman.d/hooks; echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel; useradd -m -g users -G wheel builduser; passwd -d builduser; git clone https://aur.archlinux.org/dbus-x11.git && sudo chown -R builduser dbus-x11 && cd dbus-x11 && sudo -u builduser makepkg -sic --noconfirm && libtool --finish /usr/lib && cd .. && rm -rf dbus-x11; userdel -r builduser; sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen && locale-gen; cp /usr/lib/os-release /etc/os-release; systemd-machine-id-setup; rm /var/lib/dbus/machine-id; dbus-uuidgen --ensure=/etc/machine-id; dbus-uuidgen --ensure; yes | LC_ALL=en_US.UTF-8 pacman -Scc"
	docker export --output=base.tar endeavouroswsl
	docker rm -f endeavouroswsl

clean:
	@echo -e '\e[1;31mCleaning files...\e[m'
	-rm ${OUT_ZIP}
	-rm -r ziproot
	-rm Launcher.exe
	-rm icons.zip
	-rm rootfs.tar.gz
	-sudo rm -r rootfs
	-rm base.tar
	-docker rmi archlinux:base-devel -f
