#/bin/bash
docker run --restart=unless-stopped \
   -p 4000:4000 \
   -v=${PWD}/logs:/app/logs \
   -v=/var/www/html/nps/prison_cms_files:/var/www/html/nps/prison_cms_files \
   --name recruitment \
   -d recruitment

docker run --restart=unless-stopped \
   -p 4100:4000 \
   -v=${PWD}/logs:/app/logs \
   -v=/var/www/html/nps/prison_cms_files:/var/www/html/nps/prison_cms_files \
   --name recruitment \
   -d recruitment

docker run --restart=unless-stopped \
   -p 4200:4000 \
   -v=${PWD}/logs:/app/logs \
   -v=/var/www/html/nps/prison_cms_files:/var/www/html/nps/prison_cms_files \
   --name recruitment \
   -d recruitment

docker run --restart=unless-stopped \
   -p 4300:4000 \
   -v=${PWD}/logs:/app/logs \
   -v=/var/www/html/nps/prison_cms_files:/var/www/html/nps/prison_cms_files \
   --name recruitment \
   -d recruitment

docker run --restart=unless-stopped \
   -p 4400:4000 \
   -v=${PWD}/logs:/app/logs \
   -v=/var/www/html/nps/prison_cms_files:/var/www/html/nps/prison_cms_files \
   --name recruitment \
   -d recruitment
