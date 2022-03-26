#!/bin/sh

#  AstroImageClissifier_0.9.sh
#  
#
#  Created by edwin ripaud on 19/03/2022.
#  

# TODO: Penser à mettre 'Help.txt', 'parameters.config' et 'Param_func.sh' dans un dossier 'src'
# TODO: une fois les fonctions fini d'écrire dans 'Param_func.sh', découper le fichier en plusieurs fichiers regroupant les fonctions en catégorie

# TODO: issue sur le changement des paramètres, cela change le numéro du paramètre quand la valleur est égale à celle du numéro.

ROOT_PATH="$(pwd)"
BASE_PATH=$(tail -n 24 "$ROOT_PATH/.tmp/AutoClassifier.log" | grep -w "Working directory:" | sed 's/.*: //')
TODAY="$(date +%s)"
source "$ROOT_PATH/Param_func.sh"

load_param
clean_tmp

while getopts ":r:uthp" OPT "$@"; do
    echo "\nFlag read: $OPT\n"

    case $OPT in
        (":")
            echo "Wait, where is the directory to classify???"
            read -p "Enter the folder to be filed: " OPTARG
            while [ ! -d $OPTARG ];
            do
                echo "This is not a folder..."
                read -p "Enter the folder to be filed: " OPTARG
            done
            cd "$OPTARG"
            BASE_PATH="$(pwd)"
            run_process "$BASE_PATH"
            ;;

        ("r")
            cd "$OPTARG"
            BASE_PATH="$(pwd)"
            echo "Run process in $BASE_PATH"
            run_process "$BASE_PATH"
            ;;

        ("u")
            echo "Undo process"
            undo_process
            ;;

        ("t")
            echo "${BOLD}${UNDERLINED}${TITLE}Preview temporary files${NORMAL}\n"
            temp_check
            echo "\n${RED}${BOLD}${UNDERLINED}${BLINKING}!!! Warning !!!${NORMAL}${RED}\nThis operation cannot be cancelled !${NORMAL}"
            echo "Do you want to clean up the temporary files (Y/n)?"
            read res
            if [[ $res == "Y" || $res == "y" ]]; then
                temp_clear
            else
                echo "Clear temporary files abort"
            fi
            ;;

        ("p")
            echo "${BOLD}${UNDERLINED}Update parameters${NORMAL}\n"
            update_param
            ;;

        ("h" | "?")
            help_fnc
            ;;
    esac
done
