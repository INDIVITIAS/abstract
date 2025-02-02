#!/bin/bash

# ----------------------------
# Определения цветов и иконок
# ----------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
RESET='\033[0m'

CHECKMARK="✅"
ERROR="❌"
PROGRESS="⏳"
INSTALL="🛠️"
STOP="⏹️"
RESTART="🔄"
LOGS="📄"
EXIT="🚪"
INFO="ℹ️"
ICON_KEFIR="🥛"

# ----------------------------
# Установка Docker
# ----------------------------
install_docker() {
    echo -e "${INSTALL} Установка Docker...${RESET}"
    
    # Добавление официального GPG-ключа Docker:
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Добавление репозитория в источники Apt:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    echo -e "${CHECKMARK} Docker успешно установлен.${RESET}"
    read -p "Нажмите Enter, чтобы вернуться в главное меню."
}

# ----------------------------
# Установка Mainnet
# ----------------------------
install_mainnet() {
    echo -e "${INSTALL} Настройка Abstract Mainnet...${RESET}"
    
    if [ -d "abstract-node" ]; then
        echo -e "${INFO} Директория abstract-node уже существует. Обновление...${RESET}"
        cd abstract-node
        git pull
    else
        git clone https://github.com/Abstract-Foundation/abstract-node
        cd abstract-node
    fi
    
    docker compose --file external-node/mainnet-external-node.yml up -d
    echo -e "${CHECKMARK} Abstract Mainnet успешно запущен.${RESET}"
    cd ..
    read -p "Нажмите Enter, чтобы вернуться в главное меню."
}

# ----------------------------
# Установка Testnet
# ----------------------------
install_testnet() {
    echo -e "${INSTALL} Настройка Abstract Testnet...${RESET}"
    
    if [ -d "abstract-node" ]; then
        echo -e "${INFO} Директория abstract-node уже существует. Обновление...${RESET}"
        cd abstract-node
        git pull
    else
        git clone https://github.com/Abstract-Foundation/abstract-node
        cd abstract-node
    fi
    
    docker compose --file external-node/testnet-external-node.yml up -d
    echo -e "${CHECKMARK} Abstract Testnet успешно запущен.${RESET}"
    cd ..
    read -p "Нажмите Enter, чтобы вернуться в главное меню."
}

# ----------------------------
# Просмотр логов контейнера
# ----------------------------
view_logs() {
    echo -e "${INFO} Доступные контейнеры:${RESET}"
    echo "1. node-external-node-1"
    echo "2. node-postgres-1"
    echo "3. node-prometheus-1"
    echo "4. node-grafana-1"
    # echo "5. mainnet-node-external-node-1"
    # echo "6. mainnet-node-postgres-1"
    # echo "7. mainnet-node-prometheus-1"
    # echo "8. mainnet-node-grafana-1"
    
    read -p "Введите номер контейнера [1-8]: " num
    case $num in
        1) container="testnet-node-external-node-1";;
        2) container="testnet-node-postgres-1";;
        3) container="testnet-node-prometheus-1";;
        4) container="testnet-node-grafana-1";;
        # 5) container="mainnet-node-external-node-1";;
        # 6) container="mainnet-node-postgres-1";;
        # 7) container="mainnet-node-prometheus-1";;
        # 8) container="mainnet-node-grafana-1";;
        *) echo -e "${ERROR} Неверный выбор${RESET}"; return;;
    esac

    echo -e "${LOGS} Просмотр логов для $container...${RESET}"
    docker logs -f $container
    read -p "Нажмите Enter, чтобы вернуться в главное меню."
}

# ----------------------------
# Остановка Mainnet
# ----------------------------
stop_mainnet() {
    echo -e "${STOP} Остановка Abstract Mainnet...${RESET}"
    cd abstract-node
    docker compose --file external-node/mainnet-external-node.yml down
    cd ..
    echo -e "${CHECKMARK} Mainnet успешно остановлен.${RESET}"
    read -p "Нажмите Enter, чтобы вернуться в главное меню."
}

# ----------------------------
# Остановка Testnet
# ----------------------------
stop_testnet() {
    echo -e "${STOP} Остановка Abstract Testnet...${RESET}"
    cd abstract-node
    docker compose --file external-node/testnet-external-node.yml down
    cd ..
    echo -e "${CHECKMARK} Testnet успешно остановлен.${RESET}"
    read -p "Нажмите Enter, чтобы вернуться в главное меню."
}

# ----------------------------
# Вывод ASCII-логотипа и ссылок
# ----------------------------
display_ascii() {
    clear
    echo -e "${CYAN}   ____   _  __   ___    ____ _   __   ____ ______   ____   ___    ____${RESET}"
    echo -e "${CYAN}  /  _/  / |/ /  / _ \\  /  _/| | / /  /  _//_  __/  /  _/  / _ |  / __/${RESET}"
    echo -e "${CYAN} _/ /   /    /  / // / _/ /  | |/ /  _/ /   / /    _/ /   / __ | _\\ \\  ${RESET}"
    echo -e "${CYAN}/___/  /_/|_/  /____/ /___/  |___/  /___/  /_/    /___/  /_/ |_|/___/  ${RESET}"
    echo -e ""
    echo -e "${YELLOW}Подписывайтесь на Telegram: https://t.me/CryptalikBTC${RESET}"
    echo -e "${YELLOW}Подписывайтесь на YouTube: https://www.youtube.com/@Cryptalik${RESET}"
    echo -e "${YELLOW}Здесь про аирдропы и ноды: https://t.me/indivitias${RESET}"
    echo -e "${YELLOW}Купи мне крипто бутылочку... ${ICON_KEFIR}кефира 😏${RESET} ${MAGENTA} 👉  https://bit.ly/4eBbfIr  👈 ${MAGENTA}"
    echo -e ""
}

# ----------------------------
# Главное меню
# ----------------------------
show_menu() {
    clear
    display_ascii
    echo -e "    ${YELLOW}Выберите операцию:${RESET}"
    echo -e "    ${CYAN}1.${RESET} ${INSTALL} Установить Docker"
    echo -e "    ${CYAN}2.${RESET} ${INSTALL} Запустить узел Mainnet"
    echo -e "    ${CYAN}3.${RESET} ${INSTALL} Запустить узел Testnet"
    echo -e "    ${CYAN}4.${RESET} ${LOGS} Просмотреть логи контейнера"
    echo -e "    ${CYAN}5.${RESET} ${STOP} Остановить узел Mainnet"
    echo -e "    ${CYAN}6.${RESET} ${STOP} Остановить узел Testnet"
    echo -e "    ${CYAN}7.${RESET} ${EXIT} Выход"
    echo -ne "    ${YELLOW}Введите ваш выбор [1-7]: ${RESET}"
}

# ----------------------------
# Главный цикл
# ----------------------------
while true; do
    show_menu
    read choice
    case $choice in
        1) install_docker;;
        2) install_mainnet;;
        3) install_testnet;;
        4) view_logs;;
        5) stop_mainnet;;
        6) stop_testnet;;
        7)
            echo -e "${EXIT} Выход...${RESET}"
            exit 0
            ;;
        *)
            echo -e "${ERROR} Неверный выбор. Пожалуйста, попробуйте снова.${RESET}"
            read -p "Нажмите Enter, чтобы продолжить..."
            ;;
    esac
done
