FROM buoyantio/emojivoto-svc-base:v12
WORKDIR svc_name
ARG svc_name

COPY $svc_name/target/ /usr/local/bin/

# ARG variables arent available for ENTRYPOINT
ENV SVC_NAME $svc_name
ENTRYPOINT cd /usr/local/bin && $SVC_NAME
