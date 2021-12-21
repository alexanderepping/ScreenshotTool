#! /bin/bash

selectScreenshot () {
    # scrot -sf '%Y-%m-%d-%H%M%S_scrot.png' -e 'xclip -selection clipboard -t image/png -i $f && mv $f ~/Pictures/scrot/ && feh ~/Pictures/scrot/$f'
    scrot -sf '%Y-%m-%d-%H%M%S_scrot.png' -e 'mv $f /tmp/ && feh -Tscreenshot /tmp/$f && rm /tmp/$f'
}

activeScreenshot () {
    # scrot -u  '%Y-%m-%d-%H%M%S_scrot.png' -e 'xclip -selection clipboard -t image/png -i $f && mv $f ~/Pictures/scrot/ && feh ~/Pictures/scrot/$f'
    scrot -u  '%Y-%m-%d-%H%M%S_scrot.png' -e 'mv $f /tmp/ && feh -Tscreenshot /tmp/$f && rm /tmp/$f'
}

fullScreenshot () {
    # scrot     '%Y-%m-%d-%H%M%S_scrot.png' -e 'xclip -selection clipboard -t image/png -i $f && mv $f ~/Pictures/scrot/ && feh ~/Pictures/scrot/$f'
    scrot     '%Y-%m-%d-%H%M%S_scrot.png' -e 'mv $f /tmp/ && feh -Tscreenshot /tmp/$f && rm /tmp/$f'
}

saveScreenshot () {
    fileName=${1:5}

    lenProgramDir=$(( ${#0} - 13 ))
    programDir=${0::$lenProgramDir}
    pathLastScrotFile="${programDir}lastDirScreenshot.txt"
    pathLastFile=$(cat $pathLastScrotFile)

    echo "Please enter the filename / path where the screenshot should be saved."
    echo ""
    echo "Press Return    to save in default-folder with default-name"
    echo "'#filename'     to save in default-folder as filename.png"
    echo "'>filename'     to save in last written folder as filename.png"
    echo "'>'             to save in last written folder with default-name"
    echo "'path/filename' to save in path folder as filename.png"
    echo "'path/'         to save in path folder with default-name"
    echo ""
    echo "Last written folder: ${pathLastFile}"
    echo -n "Save screenshot as: "

    read 

    if [ "$REPLY" == "" ]; then
    # save in default location with default name
        echo "cp ${1} ~/Pictures/scrot/${fileName}"
        cp ${1} ~/Pictures/scrot/${fileName}
    elif [ "${REPLY::1}" == "#" ]; then
    # save in default location with name
        echo "cp ${1} ~/Pictures/scrot/${REPLY:1}.png"
        cp ${1} ~/Pictures/scrot/${REPLY:1}.png
    elif [ "${REPLY::1}" == ">" ]; then
    # save in last location
        if [ ${#REPLY} == 1 ]; then
            echo "cp ${1} ${pathLastFile}${fileName}"
        else
            echo "cp ${1} ${pathLastFile}${REPLY:1}.png"
        fi
        read
    else
    # save in given location
        cd
        if [ "${REPLY: -1}" == "/" ]; then
        # with default name
            echo "cp ${1} ${REPLY}${fileName}"
            cp ${1} ${REPLY}${fileName}

            # write used directory
            echo $REPLY > $pathLastScrotFile
        else
        # with given name
            echo "cp ${1} ${REPLY}.png"
            cp ${1} ${REPLY}.png

            # write used directory
            index=$(echo $REPLY | awk -F "/" '{print length($0)-length($NF)}')
            echo ${REPLY::$index} > $pathLastScrotFile
        fi
    fi
}

case $1 in

    "--select")
        selectScreenshot
    ;;

    "--active")
        activeScreenshot
        ;;

    "--full")
        fullScreenshot
        ;;

    "--save")
        saveScreenshot $2
        ;;
    *)
        selectSreenshot
        ;;
esac

