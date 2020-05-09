istio-install:
	istioctl manifest apply --set profile=default \
		--set values.kiali.enabled=true \
		--set values.global.proxy.accessLogFile="/dev/stdout" \
		--set values.gateways.istio-ingressgateway.sds.enabled=true \
		-f istio-installation/istio-ingressgateway-operator.yaml

gen-privkey:
	openssl genrsa -out self-signed.key 2048

gen-csr:
	openssl req -new -key self-signed.key -out self-signed.csr

gen-cert:
	openssl x509 -req -days 3650 -in self-signed.csr -signkey self-signed.key -out self-signed.crt

create-secret-for-ingressgateway:
	kubectl create -n istio-system secret generic ingressgateway-credential --from-file=key=self-signed.key \
--from-file=cert=self-signed.crt