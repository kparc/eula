#!/usr/bin/env bash

# eula.sh fetch and display shakti eula.

# re-tty (npm 7.*)
t=/dev/tty; exec>$t<$t

eula_path=shakti.eula.crc

IFS=$'\n'
read -d '' -ra x <<< "$(node get.js $1)"
dist=${x[0]}; eula=${x[1]}
test -z $dist || test -z $eula && exit 1
saved_crc=$(test -f $eula_path && cat $eula_path)
crc=$(printf "$eula" | cksum)

if [ "$crc" == "$saved_crc" ] || [ -n "$CI" ];
then
    exit 0
else
    cols=$(stty size | cut -d ' ' -f 2)
    printf "\n\n$eula\n" | fold -s -w $(($cols - 10))
    while true
    do
	printf "\nDo you agree with the terms of the Evaluation Agreement? [y/n] " && read -rn1

        case $REPLY in
        [yY][eE][sS]|[yY])
            printf "$crc" > $eula_path
            printf "\n\n"
		exit 0
        ;;
        [nN][oO]|[nN])
            printf "\n\n +------------------------+\n"
            printf   " |  installation aborted  |\n"
            printf   " +------------------------+\n\n"
            exit 1
            break
        ;;
        *)
            printf '\nPlease type "yes" or "no".\n'
        ;;
        esac
    done
fi

#:~
