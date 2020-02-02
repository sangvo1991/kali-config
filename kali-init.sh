#!/bin/bash

# Install things
apt update -y
apt install -y build-essential htop zsh software-properties-common apt-transport-https wget git



# Timezone
rm /etc/localtime
ln /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime


# Remove BootTime
sed -i "s/GRUB_TIMEOUT\=5/GRUB_TIMEOUT\=0/" /etc/default/grub
update-grub

# Remove login
sed -i 's/\#autologin-guest\=.*/autologin-guest\=false/' /etc/lightdm/lightdm.conf
sed -i 's/\#autologin-user\=.*/autologin-user\=kali/' /etc/lightdm/lightdm.conf
sed -i 's/\#autologin-user-timeout=.*/autologin-user-timeout\=0/' /etc/lightdm/lightdm.conf

# Remove Lock Time, try everything
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 0
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
setterm -blank 0 -powersave off -powerdown 0
xset s 0 0
xset dpms 0 0
xset dpms force off
xset s off
service sleepd stop
systemctl disable sleepd

#Install Firefox Dev and VSCode
sudo -u kali mkdir -p /home/kali/.app/
if [ ! -d '/home/kali/.app/firefox' ] ; then
	sudo -u kali wget "https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US" -O /home/kali/.app/firefox_dev.tar
	sudo -u kali tar xvf /home/kali/.app/firefox_dev.tar -C /home/kali/.app/
	sudo -u kali mkdir -p /home/kali/.local/share/applications/
	cat <<EOX | sudo -u kali tee /home/kali/.local/share/applications/firefox_dev.desktop
[Desktop Entry]
Name=Firefox Developer 
GenericName=Firefox Developer Edition
Exec=/home/kali/.app/firefox/firefox %u
Terminal=false
Icon=/home/kali/.app/firefox/browser/chrome/icons/default/default128.png
Type=Application
Categories=Application;Network;X-Developer;
Comment=Firefox Developer Edition Web Browser.
EOX

	sudo -u kali chmod +x /home/kali/.local/share/applications/firefox_dev.desktop
fi

#VSCode
if ! hash code 2>/dev/null ; then
	wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add -
	echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" >> /etc/apt/sources.list.d/code.list
	apt update -y
	apt install -y code
fi

#change shell last
usermod --shell $(which zsh) kali
sudo -u kali sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sudo -u kali sed -i -E 's/ZSH_THEME="\w+"/ZSH_THEME="cloud"/' /home/kali/.zshrc

