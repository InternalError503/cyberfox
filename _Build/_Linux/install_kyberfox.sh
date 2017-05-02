# Cyberfox KDE Plasma Edition Installation, Shortcut Menu, (Optional) Shortcut Desktop,  Cyberfox KDE Plasma Edition Uninstall
# Version: 1.0
# Release, Beta channels Linux

#!/bin/bash

# Set current directory to script directory.
Dir=$(cd "$(dirname "$0")" && pwd)

# Enter current script directory.
cd $Dir

# Count how many packages in the directory, If there is more then one the script may break or have undesired effect.
PackageCount=`ls Cyberfox_KDE_Plasma_Edition-*.tar.bz2 | awk 'END { print NR }'` 

# Make package name editable in single place in the event of file naming change.
Package=$Dir/Cyberfox_KDE_Plasma_Edition-*.tar.bz2

# Desktop shortcut path, Applications shortcut path, Kyberfox install path.
# We need to know path to Desktop for not English operating systems
: ${XDG_CONFIG_HOME:=~/.config}
[ -f "${XDG_CONFIG_HOME}/user-dirs.dirs" ] && . "${XDG_CONFIG_HOME}/user-dirs.dirs"

Desktop="${XDG_DESKTOP_DIR:-~/Desktop}"
Applications=/usr/share/applications
InstallDirectory=$HOME/Apps

# Check if the script is in the right place before checking file hashes.
echo "Do you wish to install Cyberfox KDE Plasma Edition now?"
select yn in "Install" "Uninstall" "Quit"; do
    case $yn in
        Install )

        # Check if more than 1 package exist.
        if [ $PackageCount -gt 1 ]; then  
            echo "You have to many packages [$PackageCount] in this directory, I am unable to compute what package to install, Please remove the other packages so i no longer get confused!"
            notify-send "A error has occured"
            exit 0 
        fi;


        if [ -f $Dir/Cyberfox_KDE_Plasma_Edition-*.tar.bz2 ]; then
		
            # Make directory if not already exist
            if ! [ -d $InstallDirectory ]; then
                echo "Making $InstallDirectory directory!"
                mkdir $InstallDirectory
            fi
			
            # Navigate in to apps directory
            echo "Entering $InstallDirectory directory"
            cd $InstallDirectory
			
            # Unpack cyberfox in to apps directory, Remove existing cyberfox folder.
            if [ -d $InstallDirectory/Cyberfox ]; then
                echo "Removing older install $InstallDirectory/Cyberfox"
                rm -rvf $InstallDirectory/Cyberfox;
            fi
			
            echo "Unpacking $Package in to $InstallDirectory directory"
            tar xjfv $Package

            # Remove readme.txt it has no place in apps directory.
            if [ -f $InstallDirectory/README.txt ]; then
                rm -rvf $InstallDirectory/README.txt;
            fi

            # Create desktop shortcut
            # Create symlinks
            echo "Creating symlinks (Root priveleges are required)..."
            sudo ln -sf $InstallDirectory/Cyberfox/Cyberfox /usr/bin/cyberfox
            sudo ln -sf $InstallDirectory/Cyberfox/browser/icons/mozicon128.png /usr/share/pixmaps/cyberfox.png
            
            echo "Do you wish to add symlink to system's hunspell dictionaries for Cyberfox (Root priveleges are required)?"
            select yn in "Yes" "No"; do
                case $yn in
                    Yes )
                        echo "Adding symlink to hunspell..."
                        rm -rf $InstallDirectory/Cyberfox/dictionaries
                        sudo ln -sf /usr/share/hunspell $InstallDirectory/Cyberfox/dictionaries
                    break;;
                    No ) break;;
                    esac
                done
            
            
            # Create start menu shortcut
            echo "Generating start menu shortcut..."
            mkdir $InstallDirectory/Cyberfox/tmp
            cat > $InstallDirectory/Cyberfox/tmp/cyberfox.desktop <<EOF
[Desktop Entry]
Version=1.0
Encoding=UTF-8
Name=Cyberfox
Comment=Browse the World Wide Web with Cyberfox Web Browser
Comment[ar]=تصفح الشبكة العنكبوتية العالمية
Comment[ast]=Restola pela Rede
Comment[bn]=ইন্টারনেট ব্রাউজ করুন
Comment[ca]=Navegueu per la web
Comment[cs]=Prohlížení stránek World Wide Webu
Comment[da]=Surf på internettet
Comment[de]=Im Internet surfen
Comment[el]=Μπορείτε να περιηγηθείτε στο διαδίκτυο (Web)
Comment[es]=Navegue por la web
Comment[et]=Lehitse veebi
Comment[fa]=صفحات شبکه جهانی اینترنت را مرور نمایید
Comment[fi]=Selaa Internetin WWW-sivuja
Comment[fr]=Naviguer sur le Web
Comment[gl]=Navegar pola rede
Comment[he]=גלישה ברחבי האינטרנט
Comment[hr]=Pretražite web
Comment[hu]=A világháló böngészése
Comment[it]=Esplora il web
Comment[ja]=ウェブを閲覧します
Comment[ko]=웹을 돌아 다닙니다
Comment[ku]=Li torê bigere
Comment[lt]=Naršykite internete
Comment[nb]=Surf på nettet
Comment[nl]=Verken het internet
Comment[nn]=Surf på nettet
Comment[no]=Surf på nettet
Comment[pl]=Przeglądaj strony WWW z przeglądarką internetową Cyberfox
Comment[pt]=Explorar a Internet com o Cyberfox
Comment[pt_BR]=Navegue na Internet
Comment[ro]=Navigați pe Internet
Comment[ru]=Доступ в Интернет
Comment[sk]=Prehliadanie internetu
Comment[sl]=Brskajte po spletu
Comment[sv]=Surfa på webben
Comment[tr]=İnternet'te Gezinin
Comment[ug]=دۇنيادىكى توربەتلەرنى كۆرگىلى بولىدۇ
Comment[uk]=Перегляд сторінок Інтернету
Comment[vi]=Để duyệt các trang web
Comment[zh_CN]=浏览互联网
Comment[zh_TW]=瀏覽網際網路
GenericName=Web Browser
GenericName[ar]=متصفح ويب
GenericName[ast]=Restolador Web
GenericName[bn]=ওয়েব ব্রাউজার
GenericName[ca]=Navegador web
GenericName[cs]=Webový prohlížeč
GenericName[da]=Webbrowser
GenericName[el]=Περιηγητής διαδικτύου
GenericName[es]=Navegador web
GenericName[et]=Veebibrauser
GenericName[fa]=مرورگر اینترنتی
GenericName[fi]=WWW-selain
GenericName[fr]=Navigateur Web
GenericName[gl]=Navegador Web
GenericName[he]=דפדפן אינטרנט
GenericName[hr]=Web preglednik
GenericName[hu]=Webböngésző
GenericName[it]=Browser web
GenericName[ja]=ウェブ・ブラウザ
GenericName[ko]=웹 브라우저
GenericName[ku]=Geroka torê
GenericName[lt]=Interneto naršyklė
GenericName[nb]=Nettleser
GenericName[nl]=Webbrowser
GenericName[nn]=Nettlesar
GenericName[no]=Nettleser
GenericName[pl]=Przeglądarka WWW
GenericName[pt]=Navegador web
GenericName[pt_BR]=Navegador Web
GenericName[ro]=Navigator Internet
GenericName[ru]=Веб-браузер
GenericName[sk]=Internetový prehliadač
GenericName[sl]=Spletni brskalnik
GenericName[sv]=Webbläsare
GenericName[tr]=Web Tarayıcı
GenericName[ug]=توركۆرگۈ
GenericName[uk]=Веб-браузер
GenericName[vi]=Trình duyệt Web
GenericName[zh_CN]=网络浏览器
GenericName[zh_TW]=網路瀏覽器
Keywords=Internet;WWW;Browser;Web;Explorer
Keywords[ar]=انترنت;إنترنت;متصفح;ويب;وب
Keywords[ast]=Internet;WWW;Restolador;Web;Esplorador
Keywords[ca]=Internet;WWW;Navegador;Web;Explorador;Explorer
Keywords[cs]=Internet;WWW;Prohlížeč;Web;Explorer
Keywords[da]=Internet;Internettet;WWW;Browser;Browse;Web;Surf;Nettet
Keywords[de]=Internet;WWW;Browser;Web;Explorer;Webseite;Site;surfen;online;browsen
Keywords[el]=Internet;WWW;Browser;Web;Explorer;Διαδίκτυο;Περιηγητής;Cyberfox;Φιρεφοχ;Ιντερνετ
Keywords[es]=Explorador;Internet;WWW
Keywords[fi]=Internet;WWW;Browser;Web;Explorer;selain;Internet-selain;internetselain;verkkoselain;netti;surffaa
Keywords[fr]=Internet;WWW;Browser;Web;Explorer;Fureteur;Surfer;Navigateur
Keywords[he]=דפדפן;אינטרנט;רשת;אתרים;אתר;פיירפוקס;מוזילה;
Keywords[hr]=Internet;WWW;preglednik;Web
Keywords[hu]=Internet;WWW;Böngésző;Web;Háló;Net;Explorer
Keywords[it]=Internet;WWW;Browser;Web;Navigatore
Keywords[is]=Internet;WWW;Vafri;Vefur;Netvafri;Flakk
Keywords[ja]=Internet;WWW;Web;インターネット;ブラウザ;ウェブ;エクスプローラ
Keywords[nb]=Internett;WWW;Nettleser;Explorer;Web;Browser;Nettside
Keywords[nl]=Internet;WWW;Browser;Web;Explorer;Verkenner;Website;Surfen;Online 
Keywords[pl]=Internet;WWW;Przeglądarka;Sieć;Surfowanie;Strona internetowa;Strona;Przeglądanie
Keywords[pt]=Internet;WWW;Browser;Web;Explorador;Navegador
Keywords[pt_BR]=Internet;WWW;Browser;Web;Explorador;Navegador
Keywords[ru]=Internet;WWW;Browser;Web;Explorer;интернет;браузер;веб;файрфокс;огнелис
Keywords[sk]=Internet;WWW;Prehliadač;Web;Explorer
Keywords[sl]=Internet;WWW;Browser;Web;Explorer;Brskalnik;Splet
Keywords[tr]=İnternet;WWW;Tarayıcı;Web;Gezgin;Web sitesi;Site;sörf;çevrimiçi;tara
Keywords[uk]=Internet;WWW;Browser;Web;Explorer;Інтернет;мережа;переглядач;оглядач;браузер;веб;файрфокс;вогнелис;перегляд
Keywords[vi]=Internet;WWW;Browser;Web;Explorer;Trình duyệt;Trang web
Keywords[zh_CN]=Internet;WWW;Browser;Web;Explorer;网页;浏览;上网;火狐;Cyberfox;互联网;网站;
Keywords[zh_TW]=Internet;WWW;Browser;Web;Explorer;網際網路;網路;瀏覽器;上網;網頁;火狐
Exec=cyberfox %u
Terminal=false
X-MuiltpleArgs=false
Type=Application
Icon=cyberfox
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;x-scheme-handler/chrome;video/webm;application/x-xpinstall;
StartupWMClass=Cyberfox
StartupNotify=true
Actions=NewWindow;NewPrivateWindow;

[Desktop Action NewWindow]
Name=Open a New Window
Name[ar]=افتح نافذة جديدة
Name[ast]=Abrir una ventana nueva
Name[bn]=Abrir una ventana nueva
Name[ca]=Obre una finestra nova
Name[cs]=Otevřít nové okno
Name[da]=Åbn et nyt vindue
Name[de]=Ein neues Fenster öffnen
Name[el]=Άνοιγμα νέου παραθύρου
Name[es]=Abrir una ventana nueva
Name[fi]=Avaa uusi ikkuna
Name[fr]=Ouvrir une nouvelle fenêtre
Name[gl]=Abrir unha nova xanela
Name[he]=פתיחת חלון חדש
Name[hr]=Otvori novi prozor
Name[hu]=Új ablak nyitása
Name[it]=Apri una nuova finestra
Name[ja]=新しいウィンドウを開く
Name[ko]=새 창 열기
Name[ku]=Paceyeke nû veke
Name[lt]=Atverti naują langą
Name[nb]=Åpne et nytt vindu
Name[nl]=Nieuw venster openen
Name[pl]=Otwórz nowe okno
Name[pt]=Abrir uma nova janela
Name[pt_BR]=Abrir nova janela
Name[ro]=Deschide o fereastră nouă
Name[ru]=Новое окно
Name[sk]=Otvoriť nové okno
Name[sl]=Odpri novo okno
Name[sv]=Öppna ett nytt fönster
Name[tr]=Yeni pencere aç 
Name[ug]=يېڭى كۆزنەك ئېچىش
Name[uk]=Відкрити нове вікно
Name[vi]=Mở cửa sổ mới
Name[zh_CN]=新建窗口
Name[zh_TW]=開啟新視窗
Exec=cyberfox -new-window

[Desktop Action NewPrivateWindow]
Name=Open a New Private Window
Name[ar]=افتح نافذة جديدة للتصفح الخاص
Name[ca]=Obre una finestra nova en mode d'incògnit
Name[de]=Ein neues privates Fenster öffnen
Name[es]=Abrir una ventana privada nueva
Name[fi]=Avaa uusi yksityinen ikkuna
Name[fr]=Ouvrir une nouvelle fenêtre de navigation privée
Name[he]=פתיחת חלון גלישה פרטית חדש
Name[hu]=Új privát ablak nyitása
Name[it]=Apri una nuova finestra anonima
Name[nb]=Åpne et nytt privat vindu
Name[pl]=Otwórz nowe okno prywatne
Name[pt]=Abrir uma nova janela privada
Name[ru]=Новое приватное окно
Name[sl]=Odpri novo okno zasebnega brskanja
Name[tr]=Yeni bir pencere aç
Name[uk]=Відкрити нове вікно у потайливому режимі
Name[zh_TW]=開啟新隱私瀏覽視窗
Exec=cyberfox -private-window
EOF
            echo "Installing start menu shortcut..."
            chmod +x $InstallDirectory/Cyberfox/tmp/cyberfox.desktop
            sudo cp $InstallDirectory/Cyberfox/tmp/cyberfox.desktop $Applications/

            # Add KDE Plasma notification integration
            echo "Do you wish to add a KDE Plasma notification integration (Requires root privileges)?"
            select yn in "Yes" "No"; do
                case $yn in
                    Yes )
                        echo "Adding KDE Plasma notification integration"
                        # Requires admin permissions to write the file to /usr/share/knotifications5 directory.
                        sudo wget -O /usr/share/knotifications5/kyberfoxhelper.notifyrc  https://raw.githubusercontent.com/hawkeye116477/kyberfoxhelper/master/kyberfoxhelper.notifyrc
                    break;;
                    No ) break;;
                esac
            done
                
            # Install optional desktop shortcut
            echo "Do you wish to add a desktop shortcut (Root priveleges are required)?"
            select yn in "Yes" "No"; do
                case $yn in
                    Yes )
                        echo "Generating desktop shortcut..."
                        sudo ln -sf $Applications/cyberfox.desktop $Desktop/cyberfox.desktop
                    break;;
                    No ) break;;
                esac
            done
            echo "Cyberfox KDE Plasma Edition is now ready for use!"
            notify-send "Installation Complete!"
        else
            echo "You must place this script next to the 'Cyberfox_KDE_Plasma_Edition' tar.bz2 package."
        fi; 
        rm -rf $InstallDirectory/Cyberfox/tmp
        break;;
        Uninstall )

            # Navigate in to apps directory
            echo "Entering $InstallDirectory directory"
            cd $InstallDirectory

            # Remove cyberfox installation folder
            if [ -d $InstallDirectory/Cyberfox ]; then
                echo "Removing older install $InstallDirectory/Cyberfox"
                rm -rvf $InstallDirectory/Cyberfox;
            fi

            # Remove cyberfox desktop icon if exists.
            if [ -f $Desktop/cyberfox.desktop ]; then
                rm -vrf $Desktop/cyberfox.desktop;
            fi
			
            # Remove menu icon if exists.
            # Requires admin permissions to write the file to /usr/share/applications directory.
            # This should only prompt if the user installed it, Meaning if the check for the file returns true.
            if [ -f $Applications/cyberfox.desktop ]; then
                sudo rm -vrf $Applications/cyberfox.desktop;
            fi
            
            # Remove symlinks
            if [ -L /usr/bin/cyberfox ]; then
                sudo rm -vrf /usr/bin/cyberfox;
            fi
            
            if [ -L /usr/share/pixmaps/cyberfox.png ]; then
                sudo rm -vrf /usr/share/pixmaps/cyberfox.png;
            fi
            
            # Remove ~/Apps if is empty
            if [ ! "$(ls -A $InstallDirectory)" ]; then
                rmdir $InstallDirectory;
            fi
            
            # Remove KDE Plasma notification integration
             if [ -f /usr/share/knotifications5/kyberfoxhelper.notifyrc ]; then
                sudo rm -vf /usr/share/knotifications5/kyberfoxhelper.notifyrc;
            fi
            
			notify-send "Uninstall Complete"
        break;;
	  "Quit" )
            echo "If I’m not back in five minutes, just wait longer."
			exit 0; break;;
    esac
done
