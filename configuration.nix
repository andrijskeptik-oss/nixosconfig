{ config, pkgs, lib, ... }:
let as_host="vinga";
system_disk= "/dev/disk/by-uuid/412a5eab-b8be-405d-a6b3-adeddbbf8500";  
data_disk= "/dev/disk/by-uuid/0087db31-e714-4942-8eea-3686c68be358";  
backup_disk= "/dev/disk/by-uuid/b6affbcd-6022-4593-a686-3070bdc8bc64";  
unstable = import <unstable> {};
old = import <old> {};  
in { 

  imports =
    [ 
          ./hardware-configuration.nix
#         ./programm-configs.nix
    ];

  users.users.andrey = {
    isNormalUser = true;
    description = "andrey";
    extraGroups = [ "wheel" "audio" "video" "docker" "networkmanager" "vboxusers"]; 
    packages = with pkgs; [
    ];
###    shell=pkgs.bashInteractive;
  };
   programs.firefox.enable = true;
   networking.hostName = as_host; 
  # Set your time zone.
  time.timeZone = "Europe/Kyiv";

  # Select internationalisation properties.
  i18n.defaultLocale = "ru_UA.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "uk_UA.UTF-8";
    LC_IDENTIFICATION = "uk_UA.UTF-8";
    LC_MEASUREMENT = "uk_UA.UTF-8";
    LC_MONETARY = "uk_UA.UTF-8";
    LC_NAME = "uk_UA.UTF-8";
    LC_NUMERIC = "uk_UA.UTF-8";
    LC_PAPER = "uk_UA.UTF-8";
    LC_TELEPHONE = "uk_UA.UTF-8";
    LC_TIME = "uk_UA.UTF-8";
  };

documentation.man = { enable = true; man-db.enable = false;
mandoc.enable = true; };
documentation.dev.enable = true;
# Это значение определяет версию NixOS, из которой по умолчанию
# настройки для данных с отслеживанием состояния, таких как расположение файлов и версии базы данных
# в вашей системе были приняты. Все в порядке, рекомендуется уйти.
# это значение в версии первой установки этой системы.
# Прежде чем менять это значение, прочтите документацию по этой опции
# (например, man Configuration.nix или https://nixos.org/nixos/options.html).
system.stateVersion = "25.11"; # Вы читали комментарий?
system.autoUpgrade.enable = false;
nix.settings.experimental-features = [ "nix-command" "flakes" ];

nix.settings = {
  substituters = [ "https://cosmic.cachix.org/" ];
  trusted-public-keys = [ "cosmic.cachix.org-1:D7qyvC9i7c81hyTfmDnC5ovC1WZ0HcyHBPUMwFx78s8=" ];
};

fonts.packages = with pkgs; [
#    google-fonts
    noto-fonts
    ubuntu-classic
    ucs-fonts
    cm_unicode
    open-fonts
 #   terminus_font # шрифт
    terminus_font_ttf # шрифт
#    nerd-fonts.jetbrains-mono
#    nerd-fonts.iosevka
#    nerd-fonts.symbols-only
  
    (nerdfonts.override { fonts = [ "JetBrainsMono" "Iosevka" ]; })
 ];
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;

# Use latest kernel.

boot.kernelPackages = pkgs.linuxPackages_6_12;
boot.kernelModules = [ "btusb" ];
hardware.enableAllFirmware = true;
 #  Включаем графический драйвер (Hardware Acceleration)
hardware.graphics = {
  enable = true;
  enable32Bit = true; # Важно для Steam и старых игр
};
hardware.nvidia = {
  # Режимы управления питанием и настройки (рекомендуется для стабильности)
  modesetting.enable = true;
  powerManagement.enable = false;
  open = false; # Используйте true только для новых карт (RTX 20xx+)
  nvidiaSettings = true;
  
  # Выбор версии драйвера (обычно stable — лучший выбор)
  package = config.boot.kernelPackages.nvidiaPackages.stable;
};
# Включает поддержку Bluetooth
hardware.bluetooth.enable = true;

# (Опционально) Автоматическое включение Bluetooth при загрузке
hardware.bluetooth.powerOnBoot = true;

fileSystems."/" =
  { device = system_disk;
    fsType = "btrfs";
    options = [ 
      "subvol=@" 
      "compress-force=zstd:1"  # Включаем быстрое сжатие
      "noatime"          # Отключаем запись времени доступа (еще быстрее)
       "ssd"              # Оптимизация под SSD
       "discard=async"    # Фоновая очистка удаленных данных (TRIM)
     ];
  };

fileSystems."/home" =
  { device = system_disk;
    fsType = "btrfs";
    options = [ 
      "subvol=@home" 
      "compress-force=zstd:1"  # Включаем быстрое сжатие
      "noatime"          # Отключаем запись времени доступа (еще быстрее)
       "ssd"              # Оптимизация под SSD
       "discard=async"    # Фоновая очистка удаленных данных (TRIM)
     ];
  };

fileSystems."/home/andrey/Linux" =
  { device = system_disk;
    fsType = "btrfs";
    options = [ 
      "subvol=Linux" 
      "compress-force=zstd:1"  # Включаем быстрое сжатие
      "noatime"          # Отключаем запись времени доступа (еще быстрее)
       "ssd"              # Оптимизация под SSD
       "discard=async"    # Фоновая очистка удаленных данных (TRIM)
     ];
  };

fileSystems."/home/andrey/Загрузки" =
  { device = system_disk;
    fsType = "btrfs";
    options = [ 
      "subvol=Downloads" 
      "compress-force=zstd:1"  # Включаем быстрое сжатие
      "noatime"          # Отключаем запись времени доступа (еще быстрее)
       "ssd"              # Оптимизация под SSD
       "discard=async"    # Фоновая очистка удаленных данных (TRIM)
     ];
  };

fileSystems."/home/andrey/Документы" =
  { device = system_disk;
    fsType = "btrfs";
    options = [ 
      "subvol=Documents" 
      "compress-force=zstd:1"  # Включаем быстрое сжатие
      "noatime"          # Отключаем запись времени доступа (еще быстрее)
       "ssd"              # Оптимизация под SSD
       "discard=async"    # Фоновая очистка удаленных данных (TRIM)
     ];
  };

fileSystems."/home/andrey/Data" =
  { device = data_disk;
    fsType = "btrfs";
    options = [ 
      "subvol=Data" 
      "compress-force=zstd:3"  # Включаем быстрое сжатие
      "noatime"          # Отключаем запись времени доступа (еще быстрее)
       "discard=async"    # Фоновая очистка удаленных данных (TRIM)
     ];
  };

fileSystems."/home/andrey/Изображения" =
  { device = data_disk;
    fsType = "btrfs";
    options = [ 
      "subvol=Pictures" 
      "compress-force=zstd:3"  # Включаем быстрое сжатие
      "noatime"          # Отключаем запись времени доступа (еще быстрее)
       "discard=async"    # Фоновая очистка удаленных данных (TRIM)
     ];
  };

fileSystems."/home/andrey/Видео" =
  { device = data_disk;
    fsType = "btrfs";
    options = [ 
      "subvol=Videos" 
      "compress-force=zstd:3"  # Включаем быстрое сжатие
      "noatime"          # Отключаем запись времени доступа (еще быстрее)
       "discard=async"    # Фоновая очистка удаленных данных (TRIM)
     ];
  };

fileSystems."/home/andrey/Музыка" =
  { device = data_disk;
    fsType = "btrfs";
    options = [ 
      "subvol=Music" 
      "compress-force=zstd:3"  # Включаем быстрое сжатие
      "noatime"          # Отключаем запись времени доступа (еще быстрее)
       "discard=async"    # Фоновая очистка удаленных данных (TRIM)
     ];
  };

fileSystems."/home/andrey/iso" =
  { device = data_disk;
    fsType = "btrfs";
    options = [ 
      "subvol=iso" 
      "compress-force=zstd:3"  # Включаем быстрое сжатие
      "noatime"          # Отключаем запись времени доступа (еще быстрее)
       "discard=async"    # Фоновая очистка удаленных данных (TRIM)
     ];
  };

fileSystems."/home/andrey/Calibre" =
  { device = data_disk;
    fsType = "btrfs";
    options = [ 
      "subvol=Calibre" 
      "compress-force=zstd:3"  # Включаем быстрое сжатие
      "noatime"          # Отключаем запись времени доступа (еще быстрее)
       "discard=async"    # Фоновая очистка удаленных данных (TRIM)
     ];
  };

fileSystems."/boot" =
  { device = "/dev/disk/by-uuid/EEED-F74D";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

swapDevices = [ ];


services.blueman.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  
###  services.speechd.enable = true; 
#  environment.etc."speech-dispatcher/speechd.conf".text=''
#    DefaultModule "rhvoice"
#    AddModule "rhvoice" "sd_rhvoice" "rhvoice.conf"
#  '';

services.sshd.enable = true;
  services.samba.enable=true;
  services.samba.openFirewall=true;
  services.samba.settings ={ public =
      { path = "/home/andrey";
       browseable = "yes";
      comment = "Public samba share.";
      "guest ok" = "yes";
      };
     global.security="user";
    };
#services.samba.settings = {
#  "PublicShare" = {
#    "path" = "/home/andrey/shared";
#    "writable" = "yes";
#    "guest ok" = "no";
#    "valid users" = [ "andrey" ]; # Разрешаем доступ именно этому пользователю
#     };
#  };
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["nvidia"];

  services.xserver.displayManager.lightdm.enable = true;
#  services.displayManager.sddm = {
#    enable = true;
#    wayland.enable = true;
#  };


 services.xserver.desktopManager.xfce.enable = true;

  
  services.displayManager.autoLogin.user = "andrey";
  services.displayManager.defaultSession = "xfce";
#  services.displayManager.defaultSession = "Hyprland";
  services.xserver.xkb = {
         layout = "us,ua";
         variant = "rus";
         options = "grp:rctrl_rshift_toggle,nbsp:level3,lv3:ralt_switch, ctrl:nocaps";
  };


  
#  services.desktopManager.cosmic.enable = true;
#   programs.xwayland.enable = true;

    services.picom = {
    enable = true;
    backend = "glx";
    shadow = true;
    vSync=true;
    shadowExclude = [
      "_GTK_FRAME_EXTENTS@:c"
      "class_g = '.ulauncher-wrapped'"
      "class_g = 'conky'"
      "class_g = 'Peek'"
      "class_g = 'Ulauncher'"
      "class_g = 'gromit-mpx'"
      "class_g = 'i3-frame'"
      "name = 'Polybar tray window'"
      "name = 'polybar-blur-noshadow'"
      "name = 'polybar-noblur-noshadow'"
    ];
  opacityRules = [
  "90:class_g = 'conky'"
];
  };

 systemd.user.services.polkit-gnome-authentication-agent-1 = {
  description = "gnome-authentication-agent-1";
  wantedBy = [ "graphical-session.target" ];
  partOf = [ "graphical-session.target" ];
  serviceConfig = {
    Type = "simple";
    ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    Restart = "on-failure";
  };
};

# ОТКЛЮЧЕНИЕ ИНДЕКСАЦИИ (Tracker, Baloo и прочее)
services.gnome.tinysparql.enable = false;
services.gnome.localsearch.enable = false;
services.emacs.enable=true;
services.emacs.startWithGraphical=true;
services.emacs.defaultEditor=true;
virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };
#  virtualisation.libvirtd.enable = true;
# services.flatpak.enable = true; 
services.locate={
    enable=true;
    package = pkgs.plocate;
    localuser = null;
    interval = "02:15";
    prunePaths=[
    "/home/andrey/Calibre"
    "/home/andrey/Музыка"
    "/home/andrey/.cache"
    "/home/andrey/.kodi"
    "/home/andrey/.mozilla"
 #  "/home/andrey/.librewolf"
 #   "/home/andrey/.local/Chromium"
  ];
};  

  systemd.user.services.cortile = 
let
cortile-pkg = pkgs.callPackage ./pkgs/cortile/default.nix {};
in
{
    # Опис сервісу
    description = "Cortile Tiling Window Manager Helper";

    # Бінарний файл для запуску
    # Ми вказуємо шлях до бінарного файлу в пакеті, який ми щойно зібрали.
    serviceConfig = {
      # Припускаємо, що бінарник називається 'cortile' і знаходиться у $out/bin/
      ExecStart = "${cortile-pkg}/bin/cortile";
      
      # Забезпечує, що процес буде перезапущений у разі збою
      Restart = "on-failure"; 
      
      # Затримка перед перезапуском
      RestartSec = "5s";
    };

    # Секція [Install]
    # Визначає, коли сервіс має бути активований.
    # graphical-session.target гарантує запуск після старту графічної сесії користувача.
#    installFlags = [ "start" ]; # Запуск сервісу після створення
    wantedBy = [ "graphical-session.target" ];
  };
 
  environment.variables =  {
#      EDITOR = "emacs -nw";
      VISUAL = "emacsclient -c";
      TERM = "xterm-256color";
      TERMCMD = "kitty";
#      PATH="$HOME/.local:$PATH";
    };

     environment.shells = [ pkgs.bashInteractive ];
    
#    environment.homeBinInPath = true;
     environment.localBinInPath = true;

 environment.shellAliases =  {
  

  h = "history ";
  p = "ps -ax ";
  q = "exit";
  sdwn = "shutdown -h 0";
  lsp = "netstat -tupln";
  i = "ipython ";
  r = "ranger";
  p6 = "raku";
  c = "clifmrun"; 
  ffp = "ffmpeg -i $(xclip -o -sel cli) ";
  yt = "yt-dlp ";
  ytp="yt-dlp $(xclip -o -sel cli) ";
  wgp = "wget -Erkp -np -w 1 $(xclip -o -sel cli) "; 
  
  
  nh = "nix-hash --type sha256 --base32 ";
  ns = "nix-shell ";
  nr = "sudo nixos-rebuild switch";
  nru = "sudo nixos-rebuild switch --upgrade-all";
  ne = "nix-env ";
  nei = "nix-env -iA";
  neq = "nix-env -q ";
  nee = "nix-env -e ";
  ncg = "sudo nix-collect-garbage ";

  gta = "git add ";
  gtc = "git commit ";
  gts = "git status ";
  gtgh = "git push ";
  ghgt = "git pull ";
  gtr = "git rm ";
  gtu = "git restore ";
  gpp = "git clone $(xclip -o -sel cli) ";
  
  dcu = "docker-compose up  --build -d ";
  dcd = "docker-compose down ";
  dcr = "docker-compose restart ";
  
  dps  = "docker ps -a ";
  dil = "docker image list ";
  dip = "docker image prune ";
  dir = "docker rmi ";

  ag = "alias|grep ";
  pg = "ps -ax|grep ";
  hg = "history|grep ";
  eg = "env|grep ";
};

nixpkgs.config = {
    allowUnfree = true; 
    # Добавляем это:
    permittedInsecurePackages = [
    ];
    allowBroken = true;
    checkMeta = false; 
  };
nixpkgs.overlays = [
  (final: prev: {
    python3 = prev.python312;
  })
];  
environment.systemPackages = with pkgs; [
    #Утилиты
    inetutils # базовые  - ping (проверка доступности узла),
              # ftp (клиент для передачи файлов),
              # telnet (подключение к удалённым серверам),
              # traceroute (трассировка маршрута),
              #  rsh, rlogin (удалённый доступ, устаревшие),
              #  hostname, ifconfig (настройка сети).
    tcpdump # Анализ сетевого трафика в реальном времени через CLI  
    nethogs # 
    whatweb # технологии на веб-сайтах (CMS, серверы, frameworks)
    bmon # отображение скорости сети

    # загрузка файлов
    wget 
    curl 
    aria2 
    yt-dlp
    
   #Браузеры
   #тестовый интернет браузер
    w3m 
   # браузеры на базе firefox
   # firefox
    librewolf
  # расширения браузера firefox  
    tridactyl-native
  # браузеры на базе chromium
  #  chromium 
    qutebrowser
    telegram-desktop # Telegram-Desktop
#   crow-translate # онлайн перевод выделенного текста no guix  
kitty # терминал
satty # аннотация скриншотов 
bat highlight    # cli подсветка синтаксиса текстовых файлов
    font-manager # менеджер шрифтов no guix
    fontpreview # nnn depend optinal viewer  no guix
#    google-fonts
    noto-fonts
    ubuntu-classic
    ucs-fonts
    cm_unicode
    open-fonts
 #   terminus_font # шрифт
    terminus_font_ttf # шрифт
#    nerd-fonts.jetbrains-mono
#    nerd-fonts.iosevka
#    nerd-fonts.symbols-only
  
    (nerdfonts.override { fonts = [ "JetBrainsMono" "Iosevka" ]; })
   copyq # продвинутый менеджер буфера обмена
#    xsane # работа со сканером
   dconf
   gnome-control-center
   glib-networking
   dconf-editor
   zenity # gui диалоги
   ncurses # создание tui 
   kbdd # сохраняет в каждом окне свою раскладку
   xclip # работа з буфером обмена
   xdg-utils # работа с mime файлами
   xorg.libX11 
   xorg.libXft 
   xorg.libXinerama # для X11
   xorg.libXrandr # для X11
   xorg.libXScrnSaver # для X11
   xorg.xmessage 
   xorg.xkill 
   xdotool # работа с окнами X11
   xorg.xev # просмотр событий окна
   wmctrl
   xfce.xfce4-panel 
   xfce.xfce4-timer-plugin
   xfce.xfce4-genmon-plugin
   xfce.xfce4-weather-plugin
   xfce.xfce4-netload-plugin
   xfce.xfce4-fsguard-plugin
   xfce.xfce4-verve-plugin
   xfce.xfce4-xkb-plugin
   xfce.xfce4-whiskermenu-plugin
   xfce.xfce4-sensors-plugin
   xfce.xfce4-pulseaudio-plugin
   xfce.xfce4-volumed-pulse
   xfce.thunar-volman
   xfce.thunar-archive-plugin
   xfce.thunar-media-tags-plugin
   ueberzugpp
   satty
    file # информация о типе файла
    mediainfo # информация о медиафайлах
    zoxide #?
    ripgrep
    fd # продвинутая find
    rich-cli #?  
    rofi # меню для запуска программ
#    mlocate  
autojump # быстрый переход в командной оболочке
bleachbit # чистка от мусора no guix
btrfs-progs # работа с файловой системой btrfs
bluez       # Основной стек протоколов (включает bluetoothctl)
bluez-tools
conky #  отображение информационных панелей
coreutils 
dmenu # мени для х11
fzf #cmd fuzzy finder
glib
gnupg
pinentry-curses
gparted # редактирование разделов диска
htop # просмотр процессов
keepassxc # менеджер паролей 
killall # завершение процессов
libnotify # сообщения нотификации
lsof # просмотр открытих файлов
lshw
perl540Packages.FileMimeInfo #mimeopen mimeinfo
pmount # монтирование дисков
tree # просмотр дерева каталогов
usbutils # работа с usb
util-linux # разные полезные утититы
czkawka #поиск дубликатов,  похожих  и ненужных файлов 
nix-search-cli
cmake  # для разрабочиков ПО
gcc_multi # для разрабочиков ПО
gitFull # git
go
gnumake # для разрабочиков ПО
nodejs
postgresql # сервер базы данных
jupyter-all
python312Packages.beautifulsoup4
python312Packages.nltk
python312Packages.transformers
python312Packages.spacy
python312Packages.stanza
python312Packages.ipython
html2text
ocrmypdf 
python312Packages.pandoc-xnos
python312Packages.pdf2docx
python312Packages.weasyprint
pipx 
sqlite # работа з базой данных
sqlitebrowser # просмотр базы данных
jq
archivemount # монтирование cpio, .tar.gz, .tar.bz2
atool # монтирование архивов 
avfs # монтирование архивов
unzip # архиватор
unrar #архиватор
zip # архиватор
p7zip # архиватор
#    deadbeef # медиаплеер и конвертор музыки
    easytag # редактор музыкальных тегов
    ffmpeg # редактор командной строки видео и аудио
    ffmpegthumbnailer # скины видео
    feh # просмотр изображений
    gimp-with-plugins # графический редактор Gimp
    imagemagick # обрабока изображений
    vips #библиотека с програмой vipsthumbnail для превью изображений в dirvish emacs   
    jbig2enc 
    jbig2dec
    lame # конвертирование медиа кодек
    mpv # видеоплеер
    sxiv # просмотр изображений
#    rhvoice #звуковые движки
    beets
    aspell # прогамма проверки правописания
    aspellDicts.en aspellDicts.ru aspellDicts.uk  # словари aspell
    hunspellDicts.en-us  hunspellDicts.ru-ru   hunspellDicts.uk-ua # словари hunspell
    emacs # Текстовый редактор
    calibre # библиотека книг old wer guix
    catdoc # конвертирование документов Майкрософт Офис в текст
    djvu2pdf # конвертор djvu в pdf
    djvulibre # работа з djvu
    epub2txt2
    epub-thumbnailer  
    htmlq
    jp # for cli view json no guix
    libreoffice # бесплатный офис
#    miller # обработка файлов csv, json ...no guix
    mupdf # обработка pdf
    odt2txt # преобразование документов libreoffice в текст
    pandoc
    pistol # для просмотра файлов no guix
    poppler # обработка pdf
    poppler_utils
    pdftk
    pdf2odt
    pdfchain
    qpdf
    python312Packages.html2text
    python312Packages.ocrmypdf 
    python312Packages.pandoc-xnos
    python312Packages.pdf2docx
    python312Packages.weasyprint
    whisper-ctranslate2
    zathura # просмотр pdf
    crow-translate 

   # Панель и интерфейс под мышь
   nwg-panel nwg-look nwg-drawer nwg-bar nwg-menu
   hicolor-icon-theme
   # Системные мелочи
   pcmanfm              # Файловый менеджер (без индексации)
   pavucontrol          # Звук под мышь
#   networkmanagerapplet # Wi-Fi в трее
   hyprlock             # Блокировка экрана (Super+L)
   hyprland
   # Шрифты для иконок на панели
   font-awesome
 
  ];
}
