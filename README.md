## Backend

build:  
`docker build -t worker:latest .`

launch (with linking to redis_queue):  
`docker run -itd --link redis_queue --name=worker1 worker:latest`

see logs:  
`docker logs worker1 -f`

stop & delete active worker1:  
`docker stop worker1 && docker rm worker1`
