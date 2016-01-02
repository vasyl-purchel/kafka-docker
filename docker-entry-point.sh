#!/bin/bash

# update kafka heap options in kafka-server-start.sh before if needed
if [[ -n "$KAFKA_HEAP_OPTS" ]]; then
    sed -r -i "s/(export KAFKA_HEAP_OPTS)=\"(.*)\"/\1=\"$KAFKA_HEAP_OPTS\"/g" $KAFKA_HOME/bin/kafka-server-start.sh
    unset KAFKA_HEAP_OPTS
fi

for VAR in `env`
do
    # for each environment variable that starts with KAFKA_
    # and not KAFKA_HOME or KAFKA_CONFIG_FILE
    if [[ $VAR =~ ^KAFKA_ && ! $VAR =~ ^KAFKA_HOME && ! $VAR =~ ^KAFKA_CONFIG_FILE ]]; then
        # remove KAFKA_ and convert underscores to lowercase with dots
        config_name=`echo "$VAR" | sed -r "s/KAFKA_(.*)=.*/\1/g" | tr '[:upper:]' '[:lower:]' | tr _ .`
        # get the value of the variable
        config_value=`echo "$VAR" | sed -r "s/(.*)=.*/\1/g"`
        # if config name is already exists in config file then update value,
        # else add new entry to config file
        if egrep -q "(^|^#)$config_name=" $KAFKA_CONFIG_FILE; then
            sed -r -i "s@(^|^#)($config_name)=(.*)@\2=${!config_value}@g" $KAFKA_CONFIG_FILE
            # note that no config values may contain an '@' char
        else
            echo "$config_name=${!config_value}" >> $KAFKA_CONFIG_FILE
        fi
     fi
done

# Uncomment next 2 lines to verify script works fine
#echo "Generated config file:"
#cat $KAFKA_HOME/config/server.properties

exec "$@"
