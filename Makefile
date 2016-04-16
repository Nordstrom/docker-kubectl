container_name := kubectl
container_registry := quay.io/nordstrom
kubectl_version := 1.2.2
container_release := $(kubectl_version)

.PHONY: build/image tag/image push/image

build/image:
	docker build -t $(container_name) .

tag/image: build/image
	docker tag $(container_name) $(container_registry)/$(container_name):$(container_release)

push/image: tag/image
	docker push $(container_registry)/$(container_name):$(container_release)
