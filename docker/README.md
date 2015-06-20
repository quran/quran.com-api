quran-api docker deployment
===========================
build the image:
docker build -t quran-api .

run it:
docker run --name quran-api -d --link postgres:postgres quran-api

where postgres is an instance of the quran database docker image.
