# Chart Dependencies

## we are going to add caching to our application
- `helm search repo "redis"`
- `helm install redis01 bitnami/redis`
  - we need to inform our chart users that they need to deploy redis too
  - we need the way to inform out app chart how to communicate with it
  - port host etc

the place to specify dependencies is a `chart.yaml` file

- then use:
  - `help dependency update ./myapp`

- `helm dependency build`

## how we can pass variables to the child chart?
https://artifacthub.io/packages/helm/bitnami/redis/16.12.1

- auth.enabled	Enable password authentication	true

So to pass values to child chart you need to use the command bellow:
- `--set redis.auth.enabled=false`
- so basically it is like object dot notation - again just object alike abstraction 

or thru the values.yaml files

```
# at the bottom of the file in this example
redis:
    auth:
        enabled: false
```

## checking if the redis was really used:

`kubectl exec -it myapp01-redis-master-0 redis-cli`

and then: 

`keys *`

