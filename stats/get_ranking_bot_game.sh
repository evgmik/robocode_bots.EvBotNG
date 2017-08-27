#!/bin/sh

bot="eem.EvBotNG v7.0"
game=roborumble

bot="$1"
game="$2"


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
	rm ${tmpfile}
	rm ${tmpout}
}


tmpfile=`mktemp`
tmpout=`mktemp`

if [ x"$game" != x"roborumble" ] && [ x"$game" != x"meleerumble" ]
then
	die "unknown game type $game"
fi

#echo Fetching $url
wget -q -O "$tmpfile" "$url" || die "something wrong with url $url"
cat "$tmpfile" | grep "ERROR. name/game combination does not exist:" && die

# reduce to important things
cat "$tmpfile" | jq '{name,  APS, PWIN, ANPP, vote, survival, pairings, battles, latest}' > "$tmpout" || die

cat "$tmpout"  | jq '.APS'

cleanup

