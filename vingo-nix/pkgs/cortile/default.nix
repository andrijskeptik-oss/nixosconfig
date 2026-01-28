{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cortile";
  version = "2.5.2"; 

  # 1. Отримання вихідного коду з GitHub
  src = fetchFromGitHub {
    owner = "leukipp";
    repo = pname;
    rev = "96a0eddbaf37706a7ed64ffdf93cfc675e144730"; # ПРИКЛАД: Замініть на актуальний коміт!
    hash = "sha256-2/U7oQO2vOrmoPR+s9VMSWS+d/YqZ5Ic0ieSxSA6SP4="; # ПРИКЛАД: Замініть на актуальний хеш!
  };

  # 2. Перевірка залежностей Go Modules
  # Ця частина є критичною для Golang-додатків. Вона гарантує,
  # що всі Go-залежності, перелічені у go.mod/go.sum, завантажуються в Nix store.
  vendorHash = "sha256-VlIPsUogiCQeWWrFsueB6COa91CWIGx3hb7HKC59rS0=";
  # ПРИМІТКА: Щоб отримати правильний vendorHash:
  # 1. Залиште його як "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
  # 2. Спробуйте зібрати пакет: nix-build
  # 3. Nix покаже помилку з правильним хешем. Замініть заглушку на цей правильний хеш.

  # 3. Етапи збирання
  # mkDerivation
  # зазвичай автоматично компілює бінарник. Додатковий етап installPhase
  # потрібен лише для того, щоб помістити бінарник у $out/bin.
#  installPhase = ''
#    mkdir -p $out/bin
#    # Припускаємо, що бінарник називається cortile і створюється у поточній директорії
#    mv $pname $out/bin/
#  '';

  # 4. Метадані
  meta = with lib; {
    description = "A simple tiling window manager for GNOME Shell";
    homepage = "https://github.com/leukipp/cortile";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
