#!/usr/bin/env bash
#------------------------------------------------------------------------------#
#外部ファイル読み込み
. ./assets/outdata.txt
. ./assets/permissions.txt
. ./assets/commands.txt
. ./assets/variable.txt
. ./assets/settings.txt
. ./newversion.txt
. ./version.txt
. ./version.txt
. ./assets/userdata/allsettings.txt
. ./assets/password.txt
. ./assets/language/$USER_LANGUAGE.txt
#------------------------------------------------------------------------------#
target="$FILE/config.txt"
output=$3
outputdata="./assets/outdata.txt"
SELF_DIR_PATH=$(
    cd $(dirname $0)
    pwd
)/
OUTDATE="$SELF_DIR_PATH/assets/"

#今回から追加
#Official
SERVER_JARLIST_PATH="./minecraft/versionlist/official/"
#Paper
SERVER_PAPERLIST_PATH="./minecraft/versionlist/paper/"
#Spigot
SERVER_SPIGOTLIST_PATH="./minecraft/versionlist/spigot/"
#------------------------------------------------------------------------------#
##========================================##
##██╗███╗   ██╗████████╗███████╗██╗      ##
##██║████╗  ██║╚══██╔══╝██╔════╝██║
##██║██╔██╗ ██║   ██║   ███████╗██║
##██║██║╚██╗██║   ██║   ╚════██║██║      ##"
##██║██║ ╚████║   ██║   ███████║███████╗ ##"
##╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚══════╝
##========================================##

#このファイルを変更するにはShellScriptに詳しい方を知り合いにお持ちか、
#又はある程度の知識があることを前提に変更することをとても強く推奨します。
#本ファイルはMAIN SYSTEM そのもののため、どこかが欠けたりすると
#ほぼ確実に全ての機能が正常に動作しなくなります。
#本Projectの内容を変更する際は以下の本Projectの作者であるyupixが
#解説しているサイトを読みながらすることを推奨します。
# https://akarinext.org/wordpress/ 現在ご覧になれない可能性があります。
#------------------------------------------------------------------------------#

#コマンド
#設定の数
SETTING_MAX="5"
firststart() {
    if [ $firststart = 0 ]; then
        echo "INTSLをインストールして頂きありがとうございます。"
        echo "本Projectのご利用をスムーズにスタートする為に初期設定をする事を推奨します！"
        echo "$USE_POSSIBLE_ME"
        while :; do
            read -p ">" INPUT_DATA
            INPUT_DATA=${INPUT_DATA:-y}
            case $INPUT_DATA in
            [Yy] | [yY][eE][sS])
                echo "(使用する言語を入力してください。 1/3)"
                echo "以下が使用可能な言語です。 デフォルト:ja"
                echo "|ja | en|"
                while :; do
                    read -p ">" INPUT_LANGUAGE_DATA
                    INPUT_LANGUAGE_DATA=${INPUT_LANGUAGE_DATA:-ja}
                    case $INPUT_LANGUAGE_DATA in
                    [jJ][aA])
                        LANGUAGE_DATA="ja"
                        break
                        ;;
                    [eE][nN])
                        LANGUAGE_DATA="en"
                        break
                        ;;
                    *)
                        echo "存在しない言語または未対応の言語です。"
                        ;;
                    esac
                done
                #言語設定を書き換え
                sed -i -e 's/USER_LANGUAGE="'$USER_LANGUAGE'"/USER_LANGUAGE="'$LANGUAGE_DATA'"/' ./assets/settings.txt
                #再読み込み
                . ./assets/settings.txt
                #言語を変更できているかチェック
                if [[ $LANGUAGE_DATA = $USER_LANGUAGE ]]; then
                    echo "言語を${LANGUAGE_DATA}に変更しました"
                else
                    echo "予期せぬ動作により言語の設定に失敗しました。"
                    echo "項目をスキップします。"
                fi

                #STEP2
                echo "(Projectを使用する際毎回最新バージョンを確認するかどうか 2/3)"
                echo "$USE_POSSIBLE_ME"
                while :; do
                    read -p ">" INPUT_VERSION_CHECK_DATA
                    INPUT_VERSION_CHECK_DATA=${INPUT_VERSION_CHECK_DATA:-y}
                    case $INPUT_VERSION_CHECK_DATA in
                    [Yy] | [yY][eE][sS])
                        echo "y"
                        VERSION_CHECK_DATA="y"
                        break
                        ;;
                    [nN] | [nN][oO])
                        echo "n"
                        VERSION_CHECK_DATA="n"
                        break
                        ;;
                    esac
                done
                sed -i -e 's/setting_VersionCheck="'$setting_VersionCheck'"/setting_VersionCheck="'$VERSION_CHECK_DATA'"/' ./assets/settings.txt
                #再読み込み
                . ./assets/settings.txt
                #言語を変更できているかチェック
                if [[ $VERSION_CHECK_DATA = $setting_VersionCheck ]]; then
                    echo "設定を${VERSION_CHECK_DATA}に変更しました"
                else
                    echo "予期せぬ動作により設定の変更に失敗しました。"
                    echo "項目をスキップします。"
                fi

                #STEP3
                echo "(SpigotのBuild時,前回の環境をリセットするかどうか 3/3)"
                echo "$USE_POSSIBLE_ME"
                while :; do
                    read -p ">" INPUT_RESET_SPIGOT_DATA
                    INPUT_RESET_SPIGOT_DATA=${INPUT_RESET_SPIGOT_DATA:-y}
                    case $INPUT_RESET_SPIGOT_DATA in
                    [Yy] | [yY][eE][sS])
                        echo "y"
                        RESET_SPIGOT_DATA="y"
                        break
                        ;;
                    [nN] | [nN][oO])
                        echo "n"
                        RESET_SPIGOT_DATA="n"
                        break
                        ;;
                    esac
                    sed -i -e 's/setting_resetspigot="'$setting_resetspigot'"/setting_resetspigot="'$RESET_SPIGOT_DATA'"/' ./assets/settings.txt
                    #再読み込み
                    . ./assets/settings.txt
                    #言語を変更できているかチェック
                    if [[ $RESET_SPIGOT_DATA = $setting_resetspigot ]]; then
                        echo "設定を${RESET_SPIGOT_DATA}に変更しました"
                        break
                    else
                        echo "予期せぬ動作により設定の変更に失敗しました。"
                        echo "項目をスキップします。"
                        break
                    fi
                done
                sed -i -e 's/firststart="'$firststart'"/firststart="'1'"/' ./assets/settings.txt
                echo "全ての設定が終了しました! ご協力いただきありがとうございます!"
                echo "3秒後に元の動作に戻ります"
                sleep 3
                break
                ;;
            [nN] | [nN][oO])
                echo "n"
                echo "設定を変更する場合は、いつでもsettingコマンドで変更可能です!"
                sed -i -e 's/firststart="'$firststart'"/firststart="'1'"/' ./assets/settings.txt
                break
                ;;
            *)
                echo "$MISSING_INPUT_DATA_ME"
                ;;
            esac
        done
    fi
}

SPINNER() {
    for ((i = 0; i < ${#chars}; i++)); do
        sleep 0.05
        echo -en "${chars:$i:1} $PROGRESS_STATUS " "\r"
    done
}

serverlistoutput() {
    echo "サーバーリストをアウトプットします。"
    while :; do
        if [[ -e OUTPUTSERVERLIST.txt ]]; then
            rm -r OUTPUTSERVERLIST.txt
        else
            while [[ ! -e OUTPUTSERVERLIST.txt ]]; do
                PROGRESS_STATUS="$OUTPUT_NOW_ME"
                cat ./lib/main/server_list.sh | awk '/STARTSERVERLIST/,/ENDSERVERLIST/' >OUTPUTSERVERLIST.txt
                sed -i -e '1,1d' OUTPUTSERVERLIST.txt
                #先頭削除
                sed -i -e '$d' OUTPUTSERVERLIST.txt
                #最終行削除
                sed -i -e '1d' OUTPUTSERVERLIST.txt
                #空白削除
                sed -i '/^$/d' OUTPUTSERVERLIST.txt
            done
            break
        fi
    done
    echo "$OUTPUT_SUCCESS_ME"
}

#INTSLGETV() {
#    VERSIONGET=$(echo "$INTVERSIONBODY" | sed -e 's/\(.\{1\}\)/.\1/g')
#}

vcheck() {
    while :; do
        if [[ -e ./assets/new-version.txt ]]; then
            PROGRESS_STATUS="既存のファイルを削除しています。"
            SPINNER
            rm -r ./assets/new-version.txt
        else
            PROGRESS_STATUS="新しいバージョンが無いかサーバーに問い合わせています。"
            wget -q ${INTREPOURL}pub/intsl/new-version.txt -P ./assets/
            if [[ -e ./assets/new-version.txt ]]; then
                . ./assets/new-version.txt
                NEWINTSLGETV=$(echo "$NEWVERSION" | sed -e 's/\(.\)/\1./'g | sed -e 's/.$//')
                if [[ $NEWVERSION -gt ${INTVERSION} ]]; then
                    echo "$NEW_VERSION_EXISTS            "
                    echo -e "\e[31mCurrent: INTSL-$INTVERSION\e[m ⇛  \e[32mNew: INTSL-$NEWINTSLGETV\e[m"
                    echo "$FILE_DOWNLOAD_CHECK_ME"
                    echo "$USE_POSSIBLE_ME"
                    read -p ">" INPUT_DATA
                    INPUT_DATA=${INPUT_DATA:y}
                    case $INPUT_DATA in
                    [yY])
                        echo "$UPDATE_START_ME"
                        while [[ ! -e ./INTSL-${NEWINTSLGETV}-${INTEDITION}.zip ]]; do
                            PROGRESS_STATUS="$DATA_DOWNLOAD_NOW_ME"
                            SPINNER
                            wget -q https://repo.akarinext.org/pub/intsl/${NEWINTSLGETV}/INTSL-${NEWINTSLGETV}-${INTEDITION}.zip
                        done
                        echo "$DONWLOAD_SUCCESS_ME"
                        serverlistoutput
                        unzip -qonu ./INTSL-${NEWINTSLGETV}-${INTEDITION}.zip
                        if [[ -e INTSL-${NEWINTSLGETV}-${INTEDITION} ]]; then
                            cd ./INTSL-${NEWINTSLGETV}-${INTEDITION}
                            sudo cp -r . ../
                            cd -
                        else
                            echo "何か問題が発生したようです。"
                            echo "Systemを保護するためにサービスを終了します。"
                            break
                        fi
                        . ./assets/variable.txt
                        if [[ ${NEWINTSLGETV} -gt ${INTVERSION} ]]; then
                            echo "バージョンアップに失敗"
                        else
                            rm -r news.txt
                            wget -q ${INTREPOURL}pub/intsl/news.txt
                            MAXLINE=$(cat news.txt | wc -l)
                            while [[ $COUNT != $MAXLINE ]]; do
                                . ./assets/settings.txt
                                PROGRESS_STATUS="最新情報の取得中 $COUNT / $MAXLINE"
                                SPINNER
                                COUNT=$(($COUNT + 1))
                                GETLINE=$(sed -n ${COUNT}P news.txt)
                                echo "$GETLINE"
                            done
                            echo "$VERSION_UPDATE_SUCCESS_ME"

                        fi
                        ;;
                    [nN])
                        echo "キャンセルしました。"
                        echo ""
                        ;;
                    esac
                    echo $name
                    break
                else
                    echo -e '現在のINTSLは\e[1;37;32m最新バージョン\e[0mで実行中です '
                    break
                fi
            else
                echo "$DONWLOAD_FAILED_ME"
                echo "考えられる理由として、RepositoryServerがDownしている、又は"
                echo "ネットの接続が不安定な可能性が有ります。"
                break
            fi
        fi
    done
}

DONWLOAD_CANCELLATION() {
    echo "ダウンロードをキャンセルしたため、サービスを終了します"
    break
    exit 0
}

CHANGE_SERVER_PROCESS_NAME() {
    echo "サーバーのプロセス名を変更します。"
    while :; do
        read input_serverprocess_name
        if [ -n $input_serverprocess_name ]; then
            echo "サーバーのプロセス名 $input_serverprocess_name に変更します。よろしいですか? (Y)es / (N)o "
            read input_confirm
            case $input_confirm in
            [yY])
                sed -i -e 's/SCREEN_NAME='$SCREEN_NAME'/SCREEN_NAME='$input_serverprocess_name'/' ./setting.txt
                echo "プロセス名を $input_serverprocess_name に変更しました"
                break
                ;;
            [nN])
                echo "変更をキャンセルしました。"
                echo "$"
                exit 0
                ;;
            *)
                echo "$MISSING_INPUT_DATA_ME"
                ;;
            esac
        fi
    done
}
CHANGE_SERVER_JAR_NAME() {
    echo "サーバーのJAR名を変更します。"
    while :; do
        read input_serverjar_name
        if [ -n $input_serverjar_name ]; then
            echo "サーバーJAR名を $input_serverjar_name に変更します。よろしいですか? (Y)es / (N)o "
            read input_confirm
            case $input_confirm in
            [yY])
                sed -i -e 's/SERVER_FILE='$SERVER_FILE'/SERVER_FILE='$input_serverjar_name'/' ./setting.txt
                echo "サーバーJAR名を $input_serverjar_name に変更しました"
                break
                ;;
            [nN])
                echo "変更をキャンセルしました。"
                echo "$END_THE_SERVICE_ME"
                exit 0
                ;;
            *)
                echo "$MISSING_INPUT_DATA_ME"
                ;;
            esac
        fi
    done
}

CHANGE_SERVER_MIN_MEMORY() {
    echo "サーバーの最小メモリを変更します。"
    while :; do
        read input_mem_min
        if [ -n $input_mem_min ]; then
            if expr "$input_mem_min" : '[0-9]*'; then
                if [[ $input_mem_min -le $SMEM_MAX ]]; then
                    echo "サーバーの最小メモリを $input_mem_min$MEM_UNIT に変更します。よろしいですか? (Y)es / (N)o "
                    read input_confirm
                    case $input_confirm in
                    [yY])
                        sed -i -e 's/SMEM_MIN='$SMEM_MIN'/SMEM_MIN='$input_mem_min'/' ./setting.txt
                        sed -i -e 's/MEM_MIN='$MEM_MIN'/MEM_MIN='$input_mem_min$MEM_UNIT'/' ./setting.txt
                        echo "サーバーの最小メモリを $input_mem_min に変更しました"
                        break
                        ;;
                    [nN])
                        echo "変更をキャンセルしました。"
                        echo "$END_THE_SERVICE_ME"
                        exit 0
                        ;;
                    *)
                        echo "$MISSING_INPUT_DATA_ME"
                        ;;
                    esac
                else
                    echo "最小メモリの値が最大メモリを上回る為、再入力をお願いします。"
                    exit 0
                fi
            else
                echo "数字を入力してください。"
                echo "単位を変更するにはsettingsの6番目を選択してください"
            fi
        fi
    done
}
CHANGE_SERVER_MAX_MEMORY() {
    echo "サーバーの最大メモリを変更します。"
    while :; do
        read input_mem_max
        if [ -n $input_mem_max ]; then
            if expr "$input_mem_max" : '[0-9]*'; then
                if [[ $input_mem_max -gt $SMEM_MAX ]]; then
                    echo "サーバーの最大メモリを $input_mem_max$MEM_UNIT に変更します。よろしいですか? (Y)es / (N)o "
                    read input_confirm
                    case $input_confirm in
                    [yY])
                        sed -i -e 's/SMEM_MAX='$SMEM_MAX'/SMEM_MAX='$input_mem_max'/' ./setting.txt
                        sed -i -e 's/MEM_MAX='$MEM_MAX'/MEM_MAX='$input_mem_max$MEM_UNIT'/' ./setting.txt
                        echo "サーバーの最大メモリを $input_mem_max に変更しました"
                        break
                        ;;
                    [nN])
                        echo "変更をキャンセルしました。"
                        echo "$END_THE_SERVICE_ME"
                        exit 0
                        ;;
                    *)
                        echo "$MISSING_INPUT_DATA_ME"
                        ;;
                    esac
                else
                    echo "最大メモリの値が最小メモリを下回る為、再入力をお願いします。"
                    exit 0
                fi
            else
                echo "数字を入力してください。"
                echo "単位を変更するにはsettingsの6番目を選択してください"
            fi
        fi
    done
}
SERVER_CREATE() {
    . ./lib/minecraft/prsr_ce.sh
}
extension_import() {
    rm -r ${INPUT_EXTENSION_NAME}.txt
    if [[ -e ${INPUT_EXTENSION_NAME}.sh ]]; then
        #拡張機能系だけを保存するよう
        GETIEXT=$(cat ./${INPUT_EXTENSION_NAME}.sh | grep -e IEXT -e INT -e VURL >>./${INPUT_EXTENSION_NAME}.txt)
        MAXLINE=$(cat ${INPUT_EXTENSION_NAME}.txt | wc -l)
        echo "$MAXLINE"
        while [[ $COUNT != $MAXLINE ]]; do
            . ./assets/settings.txt
            COUNT=$(($COUNT + 1))
            PROGRESS_STATUS="進捗 $COUNT / $MAXLINE"
            SPINNER
            GETLINE=$(sed -n ${COUNT}P ${INPUT_EXTENSION_NAME}.txt)
            sed -i ''$EXSTENSIONLANE'i '"$GETLINE"'' ./assets/extension.txt
            #新しいラインの数値作成
            NEWSERVERLANE=$((EXSTENSIONLANE + 1))
            #拡張機能の追加ライン
            sed -i -e 's/EXSTENSIONLANE="'$EXSTENSIONLANE'"/EXSTENSIONLANE="'$NEWSERVERLANE'"/' ./assets/settings.txt
        done
        if [[ ! -e ./lib/extensions ]]; then
            mkdir ./lib/extensions
        fi
        mv ./${INPUT_EXTENSION_NAME}.sh ./lib/extensions/
        MAXLINE=$(cat ${INPUT_EXTENSION_NAME}.sh | wc -l)
        sed -i ''$EXTADDLINE'i'\#${INPUT_EXTENSION_NAME}START'' ./lib/main/extension_manager.sh
        COUNTADD=$((EXTADDLINE + 1))
        sed -i -e 's/EXTADDLINE="'$EXTADDLINE'"/EXTADDLINE="'$COUNTADD'"/' ./assets/settings.txt
        . ./assets/settings.txt
        sed -i ''$EXTADDLINE'i'${INPUT_EXTENSION_NAME}\)'' ./lib/main/extension_manager.sh
        sed -i ''$EXTADDLINE'a ;;' ./lib/main/extension_manager.sh
        sed -i ''$EXTADDLINE'a . ./lib/extensions/'${INPUT_EXTENSION_NAME}.sh'' ./lib/main/extension_manager.sh
        COUNTADD=$((EXTADDLINE + 3))
        sed -i -e 's/EXTADDLINE="'$EXTADDLINE'"/EXTADDLINE="'$COUNTADD'"/' ./assets/settings.txt
        . ./assets/settings.txt
        sed -i ''$EXTADDLINE'i'\#${INPUT_EXTENSION_NAME}STOP'' ./lib/main/extension_manager.sh
        COUNTADD=$((EXTADDLINE + 1))
        sed -i -e 's/EXTADDLINE="'$EXTADDLINE'"/EXTADDLINE="'$COUNTADD'"/' ./assets/settings.txt
        #ライン追加のライン数を変更
        . ./assets/extension.txt
        NEWEXTENSIONS=$((EXTENSIONS + 1))
        #エクステンションの数追加
        sed -i -e 's/EXTENSIONS="'$EXTENSIONS'"/EXTENSIONS="'$NEWEXTENSIONS'"/' ./assets/extension.txt
        . ./assets/extension.txt
        sed -i -e "s/IEXT/IE_XT$EXTENSIONS/g" ./assets/extension.txt
        sed -i -e "s/INTEXT/INT_EXT$EXTENSIONS/g" ./assets/extension.txt
        sed -i -e "s/VURL/V_URL$EXTENSIONS/g" ./assets/extension.txt
        sed -i -e "s/EXDOWNLOAD/EX_DOWNLOAD$EXTENSIONS/g" ./assets/extension.txt
        . ./assets/settings.txt
        EXT_MD5=$(echo "$INPUT_EXTENSION_NAME" | md5sum | sed -e "s/-//g")
        sed -i ''$EXSTENSIONLANE'i '"EXTMD5=\"$EXT_MD5\""'' ./assets/extension.txt
        sed -i -e "s/EXTMD5/EXT_MD5$EXTENSIONS/g" ./assets/extension.txt
        #新しいラインの数値作成
        NEWSERVERLANE=$((EXSTENSIONLANE + 1))
        #拡張機能の追加ライン
        sed -i -e 's/EXSTENSIONLANE="'$EXSTENSIONLANE'"/EXSTENSIONLANE="'$NEWSERVERLANE'"/' ./assets/settings.txt
        rm -r ${INPUT_EXTENSION_NAME}.txt
        echo "shが存在します。"
    else
        echo "shが存在しません"
    fi
}
DEVELOPER_LOGIN() {
    while [[ $RETRYCOUNT != $RETRYMAX ]]; do
        if [ -e $PASSWORDDILECTORY ]; then
            PROGRESS_STATUS="過去のログイン記録を参照中..."
            SPINNER
            . ./assets/settings.txt
            if [[ $first_dev_login = 0 ]]; then
                echo "初めてログインするようですね!"
                echo "パスワードを入力してください。"
                read -p ">" DEV_LOGIN_DATA -s
                while [[ $RETRYCOUNT != $RETRYMAX ]]; do
                    if [[ $DEV_LOGIN_DATA = $password ]]; then
                        echo "認証に成功..."
                        sed -i -e 's/first_dev_login="'$first_dev_login'"/first_dev_login="1"/' ./assets/settings.txt
                        break
                    else
                        echo "パスワードが間違っています。"
                        echo "パスワードが分からない場合は assets/password.txt をご覧になってください。"
                        RETRYCOUNT=$((RETRYCOUNT + 1))
                    fi
                done
            else
                echo "認証に成功"
                break
            fi
        else
            echo "開発者モードを初めて使用するため、必要なファイルを作成します"
            while [[ ! -e ./assets/password.txt ]]; do
                PROGRESS_STATUS="パスワードの生成 / ファイルの作成中"
                SPINNER
                password_generator=$(pwgen 20)
                cat <<EOF >./assets/password.txt
password="$password_generator"
EOF
            done
            . ./assets/password.txt
            echo "パスワードの生成にしました。パスワードは以下の通りです。"
            echo "パスワード: $password"
            echo "パスワードは変更可能の為、ご自分で変更する事が可能です。"
        fi
    done
    if [[ $RETRYCOUNT = $RETRYMAX ]]; then
        echo "リトライ上限に達しました。"
    fi
}
WELCOME_DEV_MESSAGE() {
    if [ -n "$YOURNAME" ]; then
        if [ -n "$KEISHOU" ]; then
            echo -e '\e[1;37;32m'$DEV_WELCOME_ME''$YOURNAME$KEISHOU'\e[0m'
        else
            echo -e '\e[1;37;32m'$DEV_WELCOME_ME''$YOURNAME様'\e[0m'
        fi
    else
        if [ -n "$KEISHOU" ]; then
            echo -e '\e[1;37;32m'$DEV_WELCOME_ME'開発者'$KEISHOU'\e[0m'
        else
            echo -e '\e[1;37;32m'$DEV_WELCOME_ME'開発者様\e[0m'
        fi
    fi
}
MC_SERVER_CREATE() {
    if [[ -z "$INPUT_SERVER_TYPE" ]]; then
        echo "$INPUT_MC_SERVER_TYPE_ME"
        read -p ">" INPUT_SERVER_TYPE
    fi
    case $INPUT_SERVER_TYPE in
    [1])
        SERVER_EDITION="official"
        echo "OfficialServer"
        echo -e "VersionList: | \033[1;37m1.2.5\033[0;39m | \033[1;37m1.3.1\033[0;39m | \033[1;37m1.3.2\033[0;39m | \033[1;37m1.4.2\033[0;39m | \033[1;37m1.4.4\033[0;39m | \033[1;37m1.4.5\033[0;39m | \033[1;37m1.4.6\033[0;39m | \033[1;37m1.4.7\033[0;39m | \033[1;37m1.5.2\033[0;39m | \033[1;37m1.5.2\033[0;39m | \033[1;37m1.6.1\033[0;39m | \033[1;37m1.6.2\033[0;39m | \033[1;37m1.6.4\033[0;39m |"
        echo -e "| \033[1;37m1.7.2\033[0;39m | \033[1;37m1.7.5\033[0;39m | \033[1;37m1.7.6\033[0;39m | \033[1;37m1.7.7\033[0;39m | \033[1;37m1.7.8\033[0;39m | \033[1;37m1.7.9\033[0;39m | \033[1;37m1.7.10\033[0;39m | \033[1;37m1.8\033[0;39m | \033[1;37m1.8.1\033[0;39m | \033[1;37m1.8.2\033[0;39m | \033[1;37m1.8.3\033[0;39m | \033[1;37m1.8.4\033[0;39m | \033[1;37m1.8.5\033[0;39m | \033[1;37m1.8.6\033[0;39m | \033[1;37m1.8.7\033[0;39m | \033[1;37m1.8.8\033[0;39m | \033[1;37m1.8.9\033[0;39m |"
        echo -e "| \033[1;37m1.9\033[0;39m | \033[1;37m1.9.1\033[0;39m | \033[1;37m1.9.2\033[0;39m | \033[1;37m1.9.3\033[0;39m | \033[1;37m1.9.4\033[0;39m | \033[1;37m1.10\033[0;39m | \033[1;37m1.10.1\033[0;39m | \033[1;37m1.10.2\033[0;39m | \033[1;37m1.11\033[0;39m | \033[1;37m1.11.1\033[0;39m | \033[1;37m1.11.2\033[0;39m | \033[1;37m1.12\033[0;39m | \033[1;37m1.12.1\033[0;39m | \033[1;37m1.12.2\033[0;39m | \033[1;37m1.13\033[0;39m | \033[1;37m1.13.1\033[0;39m | \033[1;37m1.13.2\033[0;39m |"
        echo -e "| \033[1;37m1.14\033[0;39m | \033[1;37m1.14.1\033[0;39m | \033[1;37m1.14.2\033[0;39m | \033[1;37m1.14.3\033[0;39m | \033[1;37m1.14.4\033[0;39m | \033[1;37m1.15\033[0;39m | \033[1;37m1.15.1\033[0;39m | \033[1;37m1.15.2\033[0;39m |"
        . ./lib/minecraft/officialserver.sh
        . ./lib/minecraft/olsr_dr.sh
        exit 0
        ;;
    [2])
        SERVER_EDITION="paper"
        echo "PaperServer"
        echo -e "VersionList: | \033[1;37m1.7.10\033[0;39m | \033[1;37m1.8.8\033[0;39m | \033[1;37m1.9.4\033[0;39m | \033[1;37m1.10.2\033[0;39m | \033[1;37m1.11.2\033[0;39m | \033[1;37m1.12.2\033[0;39m | \033[1;37m1.13.2\033[0;39m | \033[1;37m1.14.4\033[0;39m | \033[1;37m1.15.2\033[0;39m |"
        . ./lib/minecraft/paperserver.sh
        . ./lib/minecraft/prsr_dr.sh
        ;;
    [3])
        SERVER_EDITION="spigot"
        echo "SpigotServer"
        . ./lib/minecraft/spigotserver.sh
        . ./lib/minecraft/stsr_dr.sh
        ;;
    [4])
        SERVER_EDITION="forge"
        echo "forgeserver"
        ;;
    *)
        echo "数字を入力してください。"
        ;;
    esac
}
MC_SERVER_IMPORT() {
    if [[ -e OUTPUTSERVERLIST.txt ]]; then
        MAXLINE=$(cat OUTPUTSERVERLIST.txt | wc -l)
        while [[ $COUNT != $MAXLINE ]]; do
            . ./assets/settings.txt
            PROGRESS_STATUS="進捗 $COUNT / $MAXLINE"
            SPINNER
            COUNT=$(($COUNT + 1))
            GETLINE=$(sed -n ${COUNT}P OUTPUTSERVERLIST.txt)
            sed -i ''$SERVERLANE'i '"$GETLINE"'' ./lib/main/server_list.sh
            #サーバーの追加する行変更
            NEWSERVERLANE=$((SERVERLANE + 1))
            sed -i -e 's/SERVERLANE="'$SERVERLANE'"/SERVERLANE="'$NEWSERVERLANE'"/' ./assets/settings.txt
        done
        echo -e "\e[1;37;32mIMPORT SUCCESS\e[0m"
    else
        echo "OUTPUTデータが存在しません。"
        echo "データをOUTPUTしてから再度実行してください。"
    fi
}
#------------------------------------------------------------------------------#
case $1 in
#INTSL本体
main)
    echo "MAIN SYSTEM"
    echo "■ extension | 拡張機能を管理できます"
    echo "■ dev       | 開発者向け機能を使用できます"
    echo "■ report   | INTSLに欲しい機能や不具合を報告できます。"
    read -p ">" INPUT_DATA
    case $INPUT_DATA in
    #開発者向け機能
    report)
        echo "INTSLに欲しい機能、又は不具合を報告できます。"
        echo "要望(request) | 不具合(bug)"
        read -p ">" INPUT_DATA
        case $INPUT_DATA in
        request)
            echo "要望を簡潔にまとめて入力してください。"
            read -p ">" INPUT_REQUEST_DATA
            curl -X POST --data 'request='$INPUT_REQUEST_DATA'' http://api.akarinext.org:3000/request
            echo
            ;;
        bug)
            echo "バグの概要などを簡潔にまとめ、入力してください。"
            read -p ">" INPUT_BUG_DATA
            #curl -X POST --data 'bug='$INPUT_BUG_DATA'' http://api.akarinext.org:3000/request
            echo
            ;;
        esac
        ;;
    dev)
        firststart
        DEVELOPER_LOGIN
        WELCOME_DEV_MESSAGE
        echo "ここでは試験段階の機能を試すことができます"
        echo "何をしますか?"
        echo "■ 1.自分の名前を決める　　    ■ 4.開発者ログイン時のパスワードを変更する"
        echo "■ 2.呼ぶさいの敬称を決める    ■ 5."
        echo "■ 3.新型起動方法を実行する    ■ 6."
        read -p ">" dev
        case "$dev" in
        [1])
            echo "呼んでほしい名前を入力してください。"
            read -p ">" INPUT_YOURNAME
            sed -i -e 's/YOURNAME="'$YOURNAME'"/YOURNAME="'$INPUT_YOURNAME'"/' ./assets/userdata/allsettings.txt
            echo "名前を覚えましたよ! $INPUT_YOURNAMEさん!"
            ;;
        [2])
            echo "1. カスタム"
            echo "呼んでほしい敬称を入力してください。"
            read -p ">" dev2
            case "$dev2" in
            [1])
                read -p ">" ORIGINAL_KEISHOU
                sed -i -e 's/KEISHOU="'$KEISHOU'"/KEISHOU="'$ORIGINAL_KEISHOU'"/' ./assets/userdata/allsettings.txt
                ;;
            esac
            ;;
        [4])
            echo "開発者ログインをする際のパスワードを変更します。"
            echo "現在のパスワードを入力してください。"
            read -p ">" CURRENT_DEV_PASSWORD
            . ./assets/password.txt
            case $CURRENT_DEV_PASSWORD in
            $password)
                echo "パスワードを変更しますか?"
                echo "(Y)es / (N)o"
                read -p ">" INPUT_Y_N_DATA
                case $INPUT_Y_N_DATA in
                [yY])
                    echo ""
                    ;;
                [nN])
                    echo ""
                    ;;
                esac
                ;;
            esac
            ;;
        esac
        ;;
    #拡張機能系
    extension)
        echo "■ use | 拡張機能を使用します。"
        echo "■ import | 拡張機能をインポートします。"
        echo "■ list | 拡張機能の一覧を表示します。"
        read -p ">" INPUT_EXTENSION_DATA
        case $INPUT_EXTENSION_DATA in
        use)
            . ./lib/main/extension_manager.sh
            ;;
        import)
            echo "インポートするshの名前を入力してください。"
            read -p ">" INPUT_EXTENSION_NAME
            . ./assets/extension.txt
            while [[ $PLAYCOUNT != $EXTENSIONS ]]; do
                PLAYCOUNT=$(($PLAYCOUNT + 1))
                if [[ $EXTENSIONS = 0 ]]; then
                    break
                fi
                GET_MD5=$(echo "$INPUT_EXTENSION_NAME" | md5sum | sed -e "s/-//g")
                SPGET_MD5="EXT_MD5"
                eval $SPGET_MD5="\$EXT_MD5$PLAYCOUNT"
                if [[ $EXT_MD5 = $GET_MD5 ]]; then
                    echo "既にインストールされている為、サービスを終了します。"
                    exit
                fi
            done
            extension_import
            ;;
        list)
            . ./assets/extension.txt
            echo "拡張機能の数: ${EXTENSIONS}個"
            echo "========================================"
            while [[ $COUNT != $EXTENSIONS ]]; do
                COUNT=$(($COUNT + 1))
                EXT_NAME="IE_XT"
                eval $EXT_NAME="\$IE_XT$COUNT"
                EXT_VERSION="INT_EXT"
                eval $EXT_VERSION="\$INT_EXT$COUNT"
                Formal_V=$(echo "$INT_EXT" | sed -e 's/\(.\)/\1./'g | sed -e 's/.$//')
                echo "拡張機能名: $IE_XT"
                echo "バージョン: $Formal_V"
                echo "========================================"
            done
            ;;
        vcheck)
            . ./assets/extension.txt
            rm -r ./newversion.txt
            while [[ $PLAYCOUNT != $EXTENSIONS ]]; do
                . ./assets/extension.txt
                PROGRESS_STATUS="アップデートの確認中 $3 / $EXTENSIONS"
                SPINNER
                COUNT=$(($COUNT + 1))
                PLAYCOUNT=$(($PLAYCOUNT + 1))
                EXT_NAME="V_URL"
                eval $EXT_NAME="\$V_URL$COUNT"
                wget -q $V_URL
                . ./newversion.txt
                NEWINTSLGETV=$(echo "$BO_DY" | sed -e 's/\(.\{1\}\)/.\1/g')
                EXT_NAME="IE_XT"
                eval $EXT_NAME="\$IE_XT$COUNT"
                EXT_VERSION="INT_EXT"
                eval $EXT_VERSION="\$INT_EXT$COUNT"
                #点付ける
                Formal_V=$(echo "$INT_EXT" | sed -e 's/\(.\)/\1./'g | sed -e 's/.$//')
                Formal_NEW_V=$(echo "$NEWVERSION" | sed -e 's/\(.\)/\1./'g | sed -e 's/.$//')
                if [[ $NEWVERSION -gt $INT_EXT ]]; then
                    echo "$IE_XT に更新があります"
                    echo -e '\e[1;37mExtension     Current     Latest\e[m'
                    echo "================================="
                    echo -e "$IE_XT     $Formal_V\e[32m         $Formal_NEW_V\e[m"
                    echo "更新を行いますか?"
                    echo "(Y)es / (N)o"
                    read -p ">" INPUT_DATA
                    case $INPUT_DATA in
                    [yY])
                        EXT_NAME="IE_XT"
                        eval $EXT_NAME="\$IE_XT$COUNT"
                        while [[ ! -e ./lib/extensions/old/old_${IE_XT}.sh ]]; do
                            PROGRESS_STATUS="旧バージョンをバックアップ中"
                            SPINNER
                            mv ./lib/extensions/${IE_XT}.sh ./lib/extensions/old/old_${IE_XT}.sh
                        done
                        echo "ダウンロードを開始します。"
                        wget -q $EXDOWNLOAD -O ./lib/extensions/${IE_XT}.sh
                        #バージョン情報を更新
                        sed -i -e 's/INT_EXT'$COUNT'="'$INT_EXT'"/INT_EXT'$COUNT'="'$NEWVERSION'"/' ./assets/extension.txt
                        ;;
                    [nN])
                        echo "キャンセルしました。"
                        ;;
                    esac
                else
                    echo "更新は存在しません。"
                fi
                rm -r ./newversion.txt
            done
            ;;
        uninstall)
            echo "拡張機能をアンインストールします。"
            echo "この機能は現在未完成です。"
            ;;
        donwload)
            echo "クラウドから拡張機能をダウンロードします"
            echo "この機能は現在未完成です。"
            ;;
        esac
        ;;
    esac
    ;;

#Minecraft系
vcheck)
    vcheck
    ;;
mc)
    firststart
    while :; do
        #SRCE用
        if [[ $2 = srce ]]; then
            INPUT_SERVER_TYPE="$3"
            if [[ -n $4 ]]; then
                INPUT_SERVER_VERSION="$4"
            fi
            INPUT_SERVER_NAME="$5"
            MC_SERVER_CREATE
        #SRMT用
        elif [[ $2 = srmt ]]; then
            serverstartlist="$3"
            . ./lib/main/server_list.sh
        elif [[ $2 = otst ]]; then
            serverlistoutput
        #IMPORT用
        elif [[ $2 = import ]]; then
            MC_SERVER_IMPORT
            exit 0
        fi
        echo "Minecraft"
        echo "■ srce | サーバーを作成します。"
        echo "■ srmt | サーバーを起動します。"
        echo "■ itst | 出力したデータをインポートします"
        echo "■ otst | サーバーリストを出力します"
        read -p ">" INPUT_DATA
        case "$INPUT_DATA" in
        srce)
            echo -e "   \033[1;37m_<----^¯¯¯¯<Server List>¯¯¯¯^---->_\033[0;39m"
            echo "❘   1. OfficialServer 2. PaperServer   ❘"
            echo "❘   3. SpigotServer   4. ForgeServer   ❘"
            echo "❘   5. SpongeServer   6. BungeeCord    ❘"
            echo "❘   7. WaterFall      8. Travertine    ❘"
            MC_SERVER_CREATE
            ;;
        #未完成
        gcst)
            read -p ">" INPUT_DATA
            case $INPUT_DATA in
            create)
                echo "登録するサーバー数を入力してください"
                read -p ">" SERVER_MAX
                while [[ $COUNT != $SERVER_MAX ]]; do
                    echo "サーバー名を入力してください。"
                    read -p ">" SERVER_NAME
                    PROGRESS_STATUS="実行ファイルの確認"
                    SPINNER
                    if [[ -e ./minecraft/serversh/${SERVER_NAME}.sh ]]; then
                        echo "実行ファイルが存在します。"
                        SERVER_CREATE_SERVER="${SERVER_NAME}.sh"
                        echo "インポートする名前$SERVER_CREATE_SERVER"
                        COUNT=$(($COUNT + 1))
                    else
                        echo "実行ファイルが存在しません。"
                    fi
                done
                ;;
            esac
            ;;
        import)
            MC_SERVER_IMPORT
            ;;
        otst)
            serverlistoutput
            ;;
        srmt)
            . ./lib/main/server_list.sh
            ;;
        esac
    done
    ;;

#DiscordBot系
discord)
    firststart
    while :; do
        echo "Discord"
        echo "■ eew   | eewBotに関するコマンドを使用できます"
        echo "■ jmusic | JmusicBotに関するコマンドを使用できます"
        echo "■ status  | 各種Botのステータスを確認します。"
        read -p ">" INPUT_DATA
        case "$INPUT_DATA" in
        eew)
            . ./lib/main/discord/eew.sh
            ;;
        jmusic)
            . ./lib/main/discord/jmusic.sh
            ;;
        esac
    done
    ;;
*)

    echo -e "\033[1;37m##========================================##\033[0;39m"
    echo "##██╗███╗   ██╗████████╗███████╗██╗       ##"
    echo "##██║████╗  ██║╚══██╔══╝██╔════╝██║       ##"
    echo "##██║██╔██╗ ██║   ██║   ███████╗██║       ##"
    echo "##██║██║╚██╗██║   ██║   ╚════██║██║       ##"
    echo "##██║██║ ╚████║   ██║   ███████║███████╗  ##"
    echo "##╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚══════╝  ##"
    echo -e "\033[1;37m##========================================##\033[0;39m"
    echo -e "\033[0;31mmain\033[1;39m: INTSLに関する事を設定できます"
    echo -e "   └   \033[0;31mextension\033[1;39m: 拡張機能を管理します"
    echo -e "       └   \033[0;31muse\033[1;39m: 拡張機能を使用します"
    echo -e "       └   \033[0;31mlist\033[1;39m: 拡張機能の一覧を表示します"
    echo -e "       └   \033[0;31mimport\033[1;39m: 拡張機能をインポートします"
    echo -e "       └   \033[0;31mvcheck\033[1;39m: 拡張機能の更新を確認 /更新 します"
    echo -e "\033[0;31mmc\033[1;39m: Minecraftに関する機能を開始します"
    echo -e "   └   \033[0;31msrce\033[1;39m: サーバーを作成します"
    echo -e "   └   \033[0;31msrmt\033[1;39m: サーバーを管理します"
    echo -e "   └   \033[0;31motst\033[1;39m: サーバーリストを出力します"
    echo -e "   └   \033[0;31mitst\033[1;39m: サーバーリストをインポートします"
    echo -e "\033[0;31mdiscord\033[1;39m: Discordに関する機能を開始します"
    echo -e "   └   \033[0;31meew\033[1;39m: eewBotをスタートします"
    echo -e "       └   \033[0;31mstart\033[1;39m: EEWBotを起動します"
    echo -e "   └   \033[0;31mjmusic\033[1;39m: JMusiBotをスタートします"
    echo -e "       └   \033[0;31mstart\033[1;39m: JMusicBotを起動します"

    ;;
esac
case $2 in
tete)
    echo "今後用"
    ;;
esac
exit 0
