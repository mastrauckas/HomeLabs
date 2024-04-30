dotnet publish -c Release -o ./build
docker build -t printdotnet8:v1.0 -f Dockerfile .
docker build -t printdotnet8:latest -f Dockerfile .
docker tag printdotnet8:v1.0 mastrauckas/printdotnet8:v1.0
docker tag printdotnet8:latest mastrauckas/printdotnet8:latest
docker push mastrauckas/printdotnet8:v1.0
docker push mastrauckas/printdotnet8:latest