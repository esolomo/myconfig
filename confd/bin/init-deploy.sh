#!/bin/sh

export SERVICE_ID=${ENV:-DEV}
export LABEL="[VivaCloud]"

for service in ${SERVICE_ID}
do
    echo "Initializing service : ${service}"
    mkdir /etc/confd/${service}
    mkdir /etc/confd/${service}/conf.d
    mkdir /etc/confd/${service}/templates
    cat /etc/confd/service_tpl/deploy.conf.toml | sed s/"viva-service"/${service}/g | tee -a > "/etc/confd/${service}/conf.d/deploy.sh.toml"
    cat /etc/confd/service_tpl/deploy.sh.tmpl | sed s/"viva-service"/${service}/g | tee -a > "/etc/confd/${service}/templates/deploy.sh.tmpl"
    sleep 5
    echo $ETCD
    /usr/local/bin/confd  -watch=true  -node $ETCD  -confdir="/etc/confd/${service}" &
    echo "Initialization for service  ${service} : completed"
done

echo "Vivacloud Completed"
exit 0