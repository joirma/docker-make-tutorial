#!/bin/bash
sleep 5
curl http://localhost -o salida
diff salida_esperada salida
res=$?
make stop
if [ "${res}" == "0" ]; then
   echo "TEST -> OK"
else
   echo "TEST -> KO"
fi

