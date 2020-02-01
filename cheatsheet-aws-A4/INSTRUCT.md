# List all resources

```
aws ec2 describe-regions | jq .Regions[].RegionName | xargs -I{} aws resourcegroupstaggingapi get-resources --region {}
```
