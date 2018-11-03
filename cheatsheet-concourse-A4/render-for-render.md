In variable.yml, let's assume we have some duplication like below

```
tile-fname: test-container-service-1.3.0-build.8.pivotal
tile-url: http://my.repo-test.com/zdenny/test-container-service-1.3.0-build.8.pivotal
```

Concourse supports high-order rendering, thus we can change to below
```
tile-fname: test-container-service-1.3.0-build.8.pivotal
tile-url: http://my.repo-test.com/zdenny/((tile-fname))
```

Then fly the pipeline again

```
fly -t my set-pipeline -p my-test --config my-test.yml --load-vars-from var.yml
```
