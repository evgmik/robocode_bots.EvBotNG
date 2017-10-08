#!/bin/sh

bot_base="eem.EvBotNG"

bot_base="$1"
game="$2"

function get_version2refresh () {
	git tag | tail -1 
}

function get_rating () {
first=1;
echo "["
git tag | sort -V | while read version
do
	bot="${bot_base} ${version}"

	force_update="false"
	test "${version}" == "${version2refresh}" && force_update="true"

	result=`./get_ranking_bot_game.sh "${bot}" "$game" "${force_update}"`
	if [ $? != 0 ]
	then
		#result="{}"
		result="{\"latest\":NaN, \"APS\":NaN,\"name\":\"${bot}\"}"
		#continue
	fi
	if [ $first == 1 ]
       	then
		first=0
	else
		echo ","
	fi
	echo "$result"
done
echo "]"
}

version2refresh=`get_version2refresh`

all_results="${game}.${bot_base}.json"
get_rating  > "${all_results}"

cat "${all_results}" | jq -c '.[] | [.latest, .APS, .name] ' | sed -e 's/\[//' -e 's/\]//'

