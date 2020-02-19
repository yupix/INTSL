#!/bin/bash
echo "サーバーを起動する際のコマンドを指定してください"
read -p ">" INPUT_SERVER_NAME
mkdir $INPUT_SERVER_NAME
if [[ $SERVER_EDITION = official ]]; then
    srce_edision="server"
    cp ${SERVER_JARLIST_PATH}server$mc_donwload_version.jar ./$INPUT_SERVER_NAME
    chmod 755 ./$INPUT_SERVER_NAME/paperserver$mc_donwload_version.jar
fi
if [[ $SERVER_EDITION = paper ]]; then
    srce_edision="paperserver"
    cp ${SERVER_PAPERLIST_PATH}paperserver$mc_donwload_version.jar ./$INPUT_SERVER_NAME
    chmod 755 ./$INPUT_SERVER_NAME/paperserver$mc_donwload_version.jar
fi
sed -i ''$SERVERLANE'i'$INPUT_SERVER_NAME\)'' ./linux.sh
sed -i ''$SERVERLANE'a ;;' ./linux.sh
sed -i ''$SERVERLANE'a . ./minecraft/serversh/'$INPUT_SERVER_NAME.sh'' ./linux.sh
cd ./minecraft/serversh/
cat <<EOF >$INPUT_SERVER_NAME.sh
#!/bin/bash
                cd ./$INPUT_SERVER_NAME
                while :; do
                    #本番時はINPUT系に置き換え
                    #$INPUT_SERVER_NAME\SERVER
                    echo "$INPUT_SERVER_NAMESERVER"
                    echo "start | サーバーを起動します"
                    echo "settings | サーバー起動時の設定を変更できます"
                    echo "mcst | Minecraftサーバー既存の設定を変更します"
                    read -p ">" server
                    case \$server in
                    start)
                        #本番時は$INPUT系に置き換え
                        #SERVER_NAME="$INPUT_SERVER_NAME" +
                        FILE_SERVER_NAME="$INPUT_SERVER_NAME"
                        FILE_SERVER_PATH="$INPUT_SERVER_NAME"
                        DEFAULT_MEM="1G"
                        #${srce_edision}$mc_donwload_version.jar
                        FILE_SERVER_FILE="${srce_edision}$mc_donwload_version.jar"

                        . ./setting.txt

                        PROGRESS_STATUS="ファイルの確認中"
                        SPINNER
                        #ファイルのチェック
                        if [[ ! -e setting.txt ]]; then
                            #ループs
                            while :; do
                                PROGRESS_STATUS="ファイルの作成中"
                                SPINNER
                                if [[ \$RETRYCOUNT -le \$RETRYMAX ]]; then
                                    if [[ ! -e setting.txt ]]; then
                                        cd ../
                                        . ./lib/main/server_default_settings.sh
                                        cd ./\$INPUT_SERVER_NAME
                                        #ちゃんと\を入れる
                                        RETRYCOUNT=$((RETRYCOUNT + 1))
                                    else
                                        echo "ファイルの作成に成功しました"
                                        break
                                    fi
                                else
                                    echo "ファイルの作成に失敗しました。"
                                    echo "再度実行し、問題がある場合は作者に報告してください。"
                                fi
                            done
                        fi

                        #これを本番時はifに追加
                        #${srce_edision}$mc_donwload_version.jar
                        PROGRESS_STATUS="ファイルの確認中"
                        SPINNER
                        if [ -e ${srce_edision}$mc_donwload_version.jar ]; then
                            echo "JARファイルのチェックに成功"
                            PROGRESS_STATUS="ファイルの確認中"
                            SPINNER
                            if [[ -e eula.txt ]]; then
                                EULACONSENT=\$(cat ./eula-back.txt | grep eula=false | sed 's/eula=//g')
                                echo
                                #本番時は \$EULACONSENTにしないとからになる
                                if [[ \false = \$EULACONSENT ]]; then
                                    echo "EULA(MINECRAFT エンド ユーザー ライセンス条項)に同意していません。"
                                    echo "こちらを読み、同意する場合は(Y)esキャンセルする場合は(N)oと入力してください"
                                    echo "https://account.mojang.com/documents/minecraft_eula"
                                    while :; do
                                        read -p ">" INPUT_EULA_DATA
                                        #本番時は$\INPUT_EULA_DATAにしないと空になる
                                        case \$INPUT_EULA_DATA in
                                        [yY])
                                            echo "同意しました。"
                                            sed -i -e 's/eula=false/eula=true/' ./eula.txt
                                            break
                                            ;;
                                        [nN])
                                            echo "キャンセルしました。"
                                            break
                                            ;;
                                        *)
                                            echo "(Y)esまたは(N)oを入力してください"
                                            ;;
                                        esac
                                    done
                                fi
                            else
                                echo "eulaファイルが存在しません。JARファイルを一度実行します。"
                                . ./setting.txt
                                screen -AdmS \$${INPUT_SERVER_NAME}_SCREEN_NAME \$${INPUT_SERVER_NAME}_JAVA_HOME \$${INPUT_SERVER_NAME}_JVM_ARGUMENT -jar \$FILE_SERVER_FILE nogui
                            fi
                        else
                            echo "JARファイルのチェックに失敗"
                        fi
                        ;;
                    #設定変更コマンド
                    settings)
                        . ./setting.txt
                        PROGRESS_STATUS="ファイルの確認中"
                        SPINNER
                        if [[ -e setting.txt ]]; then
                            echo "~サーバー設定一覧~"
                            echo "1.サーバーのプロセス名"
                            echo "└ \$${INPUT_SERVER_NAME}_SCREEN_NAME"
                            echo "2.サーバーJAR名 ⇛ $SERVER_FILE"
                            echo "└ $SERVER_FILE"
                            echo "3.サーバーメモリ最小"
                            echo "└ $MEM_MIN"
                            echo "4.サーバーメモリ最大"
                            echo "└ $MEM_MAX"
                            echo "5.JAVAPATH"
                            echo "└ $JAVA_HOME"
                            read INPUT_SERVER_SETTING
                            case \$INPUT_SERVER_SETTING in
                            1)
                                CHANGE_SERVER_PROCESS_NAME
                                ;;
                            2)
                                CHANGE_SERVER_JAR_NAME
                                ;;
                            3)
                                CHANGE_SERVER_MIN_MEMORY
                                ;;
                            4)
                                CHANGE_SERVER_MAX_MEMORY
                                ;;
                            5) ;;

                            *)
                                echo "変なキー打たないで"
                                ;;
                            esac
                        else
                            echo "設定ファイルが存在しません。"
                        fi
                        ;;
                    *) ;;
                        #変なキー入力受け付けたとき用
                    esac
                done

EOF
echo "www"
#sed -i ''54'i'EOF'' ./$INPUT_SERVER_NAME.sh
echo "wwww"
NEWSERVERLANE=$((SERVERLANE + 3))
echo "$TESTWW"
cd ../
cd ../
sed -i -e 's/SERVERLANE="'$SERVERLANE'"/SERVERLANE="'$NEWSERVERLANE'"/' ./assets/settings.txt
exit 0