cd showversionsv6
dotnet publish -c Release -o ./build
docker build -t showversionsv6:v1.0.0 -f Dockerfile .
docker tag showversionsv6:v1.0.0 localhost:8000/showversionsv6:v1.0.0
docker push localhost:8000/showversionsv6:v1.0.0
cd ..
cd showversionsv8
dotnet publish -c Release -o ./build
docker build -t showversionsv8:v1.0.0 -f Dockerfile .
docker tag showversionsv8:v1.0.0 localhost:8000/showversionsv8:v1.0.0
docker push localhost:8000/showversionsv6:v1.0.0
cd ..