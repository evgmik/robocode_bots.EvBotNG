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

stats roborumbledata using 0:2 prefix "one_on_one"
stats melerrumbledata using 0:2 prefix "melee"

set obj 10 circle at one_on_one_pos_max_y, one_on_one_max_y size screen .01 fc rgb "red"
set arrow 11 from one_on_one_pos_max_y, graph 0 to one_on_one_pos_max_y, one_on_one_max_y 

set obj 20 circle at melee_pos_max_y, melee_max_y size screen .01 fc rgb "red"
set arrow 21 from melee_pos_max_y, graph 0 to melee_pos_max_y, melee_max_y 

set title "eem.EvBotNG progress"
set yrange [:]
#plot datafname u 0:2:3 with labels rotate by 90 right,  datafname u 0:2 w boxes
plot roborumbledata u 0:2:xtic(3) title 'roborumble' with lp lt -1 pt 7, \
     melerrumbledata u 0:2:xtic(3) title 'meleerumble' with lp lt -1 pt 6, \


