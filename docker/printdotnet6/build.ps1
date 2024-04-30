dotnet publish -c Release -o ./build
docker build -t printdotnet6:v1.0 -f Dockerfile .
docker build -t printdotnet6:latest -f Dockerfile .
docker tag printdotnet6:v1.0 mastrauckas/printdotnet6:v1.0
docker tag printdotnet6:latest mastrauckas/printdotnet6:latest
docker push mastrauckas/printdotnet6:v1.0
docker push mastrauckas/printdotnet6:latest