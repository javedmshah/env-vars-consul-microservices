#!/bin/sh

export SERVICE_HOME=/opt/token-validation-microservice
export CLASSPATH="$SERVICE_HOME/lib/*:$SERVICE_HOME/framework/*:$SERVICE_HOME/bin/*"

__PROJECT_HOME="$SERVICE_HOME"
if [ -n "$PROJECT_HOME" ]; then
    __PROJECT_HOME="$PROJECT_HOME"
fi

echo "SERVICE_HOME is $SERVICE_HOME"
echo "PROJECT_HOME is $__PROJECT_HOME"

__JAVA_OPTS="-server -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=1 -XshowSettings:vm"
if [ -n "$JAVA_OPTS" ]; then
    __JAVA_OPTS="$JAVA_OPTS"
fi

# start envconsul with address for consul and use key namespace for token-validation to spawn new container
/usr/bin/envconsul -log-level debug -consul=192.168.99.100:31100 -pristine -prefix=token-validation /bin/sh -c bin/docker-entrypoint.sh 
