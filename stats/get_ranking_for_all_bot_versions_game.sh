#!/bin/sh

bot_base="eem.EvBotNG"

bot_base="$1"
game="$2"

echo "["
git tag | while read version
do
	bot="${bot_base} ${version}"
	result=`./get_ranking_bot_game.sh "${bot}" "$game"`
	if [ $? != 0 ]
	then
		result=NaN
	fi
	APS=$result
	echo "{name:\"${bot}\", APS:\"{$APS}\""
done
echo "]"
