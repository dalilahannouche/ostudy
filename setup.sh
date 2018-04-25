#!/bin/bash

is_present (){
    docker images | grep "$1" | grep "$2" &> /dev/null;
}

if is_present "postgres" "9.6" ; then
    echo -n ""
else
    echo "Postgres image is not present on this system: Pulling"
    docker pull postgres:9.6
fi

if is_present "odoo" "8.0" ; then
    echo -n ""
else
    echo "Odoo image is not present on this system: Pulling"
    docker pull odoo:8.0
fi


if [ ! -d  $(pwd)/extra-addons ]; then
    mkdir -p $(pwd)/extra-addons
fi

if [ ! -d $(pwd)/filestore/ ]; then
    echo "Creating the filestore directory with the correct ownership"
    docker run -it --rm -u root -v $(pwd)/filestore/:/var/lib/odoo odoo:8.0 chown -R odoo: /var/lib/odoo
fi

filestore_proprio=$(stat -c %u:%g $(pwd)/filestore/)
curruser=$(echo $(id -u $USER):$(id -g $USER))

if [ $filestore_proprio == $curruser ]; then
    echo "filestore folder have not the adequate ownership: Fixing"
    docker run -it --rm -u root -v $(pwd)/filestore/:/var/lib/odoo odoo:8.0 chown -R odoo: /var/lib/odoo
fi

echo "Please run 'source conf/aliases' to get dcu and dcd aliases"
