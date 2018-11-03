~/Downloads/fly-v4.1.0 -t pks set-pipeline -p pipeline1 --config concret.yml

~/Downloads/fly-v4.1.0 -t pks set-pipeline -p pipeline2 --config split-part1.yml --load-vars-from split-part2.yml
