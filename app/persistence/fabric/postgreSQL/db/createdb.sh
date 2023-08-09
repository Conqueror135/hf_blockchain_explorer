#!/bin/bash

# SPDX-License-Identifier: Apache-2.0

echo "Copying ENV variables into temp file..."
node processenv.js

export USER=$( jq .postgreSQL.username ../../../../explorerconfig.json )


export DATABASE=$(jq .postgreSQL.database ../../../../explorerconfig.json )

export PASSWD=$(jq .postgreSQL.passwd ../../../../explorerconfig.json | sed "y/\"/'/")



echo "USER=${USER}"
echo "DATABASE=${DATABASE}"
echo "PASSWD=${PASSWD}"

echo "Executing SQL scripts, OS="$OSTYPE

#support for OS
case $OSTYPE in
darwin*) psql postgres -v dbname=$DATABASE -v user=$USER -v passwd=$PASSWD -f ./explorerpg.sql ;
psql postgres -v dbname=$DATABASE -v user=$USER -v passwd=$PASSWD -f ./updatepg.sql ;;
linux*)
if [ $(id -un) = 'postgres' ]; then
  PSQL="psql"
else
  PSQL="sudo -u postgres psql"
fi;
${PSQL} -v dbname=$DATABASE -v user=$USER -v passwd=$PASSWD -f ./explorerpg.sql ;
${PSQL} -v dbname=$DATABASE -v user=$USER -v passwd=$PASSWD -f ./updatepg.sql ;;
esac


