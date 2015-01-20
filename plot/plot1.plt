set terminal png  transparent enhanced  fontscale 1.0 size 500, 350 
#set output 'contours.17.png'
set parametric 
set urange [-2:2]  
set vrange [0:6.28]
set isosample 40 
set view 75,30 
splot u*cos(v),u*sin(v),u

