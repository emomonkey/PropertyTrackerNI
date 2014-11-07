cd $1/highchart/exporting-server/phantomjs
phantomjs highcharts-convert.js -infile $2 -outfile $1/public/export/$3 -scale 2.5 -width 300 -constr Chart
