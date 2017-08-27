#!/bin/sh

bot="eem.EvBotNG v7.0"
game=roborumble

bot="$1"
game="$2"
# true or false
force_update="$3"


# this is good to see currently ran in rumble bot
# base_url="http://literumble.appspot.com/Rankings?api=true"
# url="${base_url}"'&'"game=${game}"'
# wget -O t "$url"
# cat t | jq '.[] | select(.name == "eem.EvBotNG v7.0")'

# this one allows to see back in history but cannot give place in rumble
# example
# http://literumble.appspot.com/BotDetails?game=roborumble&name=eem.EvBotNG%20v7.0
base_url="http://literumble.appspot.com/BotDetails?api=true"
url="${base_url}"'&'"game=${game}"'&'"name=${bot}"


function die () {
	msg="$1"
	if [ x"$1" != x ]
	then
		echo "ERROR: $1"
	fi
	cleanup
	exit 1
}

function cleanup () {
	false
}


if [ x"$game" != x"roborumble" ] && [ x"$game" != x"meleerumble" ]
then
	die "unknown game type $game"
fi

if [ x"$force_update" == x ]
then
	force_update=false
fi

cache_dir=cache
cache_file="${cache_dir}"/"${game}".${bot}.json

if [ ! -d "${cache_dir}" ]
then
	mkdir "${cache_dir}"
fi

if [ ! -f "${cache_file}" ]  || [ ${force_update} == "true" ]
then
	#echo Fetching $url
	wget -q -O "${cache_file}" "$url" || die "something wrong with url $url"
fi


[ ! -f "${cache_file}" ]  && die "do not see cached file"

cat "$cache_file" | grep "ERROR. name/game combination does not exist:" && die
# reduce to important things
#note that "jq -c" make compact output into a single line
	jq -e -c '{name,  APS, PWIN, ANPP, vote, survival, pairings, battles, latest}' < ${cache_file} \
	|| die


#cat "$tmpout"  | jq '.APS'

cleanup

exit 0

