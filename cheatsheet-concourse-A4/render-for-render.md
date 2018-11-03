In variable.yml, let's assume we have some duplication like below

```
tile-fname: test-container-service-1.3.0-build.8.pivotal
tile-url: http://my.repo-test.com/zdenny/test-container-service-1.3.0-build.8.pivotal
```

Concourse support high-order rendering, thus we can change to below
```
tile-fname: test-container-service-1.3.0-build.8.pivotal
tile-url: http://my.repo-test.com/zdenny/((tile-fname))
```

Run fly the pipeline

```
fly -t my set-pipeline -p my-test --config my-test.yml --load-vars-from var.yml
```
