cd ../src/
dotnet publish -c Release -o ../building/build
cd ../building

docker build -t dotnet8-environment-variables:v1.0 -f Dockerfile .
docker build -t dotnet8-environment-variables:latest -f Dockerfile .
docker tag dotnet8-environment-variables:v1.0 mastrauckas/dotnet8-environment-variables:v1.0
docker tag dotnet8-environment-variables:latest mastrauckas/dotnet8-environment-variables:latest
docker push mastrauckas/dotnet8-environment-variables:v1.0
docker push mastrauckas/dotnet8-environment-variables:latest