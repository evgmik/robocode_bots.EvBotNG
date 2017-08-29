roborumbledata='roborumble.dat'
melerrumbledata='meleerumble.dat'

set term png size 1024,600
set output  'EvBotNG.stats.png'

set datafile separator ","
#set timefmt "%Y-%m-%d %H:%M:%S"
#set xdata time

set xtics rotate
set ylabel "APS"
set key bottom

set title "eem.EvBotNG progress"
set yrange [:]
#plot datafname u 0:2:3 with labels rotate by 90 right,  datafname u 0:2 w boxes
plot roborumbledata u 0:2:xtic(3) title 'roborumble' with lp lt -1 pt 7, \
     melerrumbledata u 0:2:xtic(3) title 'meleerumble' with lp lt -1 pt 6

