
set datafile separator ","
#set timefmt "%Y-%m-%d %H:%M:%S"
#set xdata time
set nokey

set yrange [40:100]
plot 'roborumble.dat' u 0:2:3 with labels rotate by 90 right,  'roborumble.dat' u 0:2 w boxes

