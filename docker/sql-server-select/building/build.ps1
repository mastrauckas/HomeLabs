cd ../src/
dotnet publish -c Release -o ../building/build
cd ../building

docker build -t sql-server-select:v1.0 -f Dockerfile .
docker build -t sql-server-select:latest -f Dockerfile .
docker tag sql-server-select:v1.0 mastrauckas/sql-server-select:v1.0
docker tag sql-server-select:latest mastrauckas/sql-server-select:latest
docker push mastrauckas/sql-server-select:v1.0
docker push mastrauckas/sql-server-select:latest