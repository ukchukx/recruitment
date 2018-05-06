#/bin/bash
docker run --restart=unless-stopped \
   --network=host \
   -e "PORT=4000" \
   -v=${PWD}/logs:/app/logs \
   -v=/var/www/html/nps/prison_cms_files:/var/www/html/nps/prison_cms_files \
   --name recruitment0 \
   -d recruitment

docker run --restart=unless-stopped \
   --network=host \
   -e "PORT=4100" \
   -v=${PWD}/logs:/app/logs \
   -v=/var/www/html/nps/prison_cms_files:/var/www/html/nps/prison_cms_files \
   --name recruitment1 \
   -d recruitment

docker run --restart=unless-stopped \
   --network=host \
   -e "PORT=4200" \
   -v=${PWD}/logs:/app/logs \
   -v=/var/www/html/nps/prison_cms_files:/var/www/html/nps/prison_cms_files \
   --name recruitment2 \
   -d recruitment

docker run --restart=unless-stopped \
   --network=host \
   -e "PORT=4300" \
   -v=${PWD}/logs:/app/logs \
   -v=/var/www/html/nps/prison_cms_files:/var/www/html/nps/prison_cms_files \
   --name recruitment3 \
   -d recruitment

docker run --restart=unless-stopped \
   --network=host \
   -e "PORT=4400" \
   -v=${PWD}/logs:/app/logs \
   -v=/var/www/html/nps/prison_cms_files:/var/www/html/nps/prison_cms_files \
   --name recruitment4 \
   -d recruitment
