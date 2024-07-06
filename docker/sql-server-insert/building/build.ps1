cd ../src/
dotnet publish -c Release -o ../building/build
cd ../building

docker build -t sql-server-insert:v1.0 -f Dockerfile .
docker build -t sql-server-insert:latest -f Dockerfile .
docker tag sql-server-insert:v1.0 mastrauckas/sql-server-insert:v1.0
docker tag sql-server-insert:latest mastrauckas/sql-server-insert:latest
docker push mastrauckas/sql-server-insert:v1.0
docker push mastrauckas/sql-server-insert:latest