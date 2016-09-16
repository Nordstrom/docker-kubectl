container_name := kubectl
container_registry := quay.io/nordstrom
kubectl_version := 1.3.6
container_release := $(kubectl_version)

build := build

.PHONY: build/image tag/image push/image clean

build/image: Dockerfile SHA256SUMS.kubectl setup_kubectl.sh
	cp Dockerfile $(build)
	cp setup_kubectl.sh $(build)
	docker build --build-arg KUBECTL_RELEASE=$(kubectl_version) \
		-t $(container_name) $(build)

tag/image: build/image
	docker tag $(container_name) $(container_registry)/$(container_name):$(container_release)

push/image: tag/image
	docker push $(container_registry)/$(container_name):$(container_release)

$(build)/kubectl: | $(build)
	cd $(build) && curl -sLo kubectl https://storage.googleapis.com/kubernetes-release/release/v$(kubectl_version)/bin/linux/amd64/kubectl

SHA256SUMS.kubectl: $(build)/kubectl | $(build)
	cd $(build) && shasum -a256 kubectl > $@

$(build):
	mkdir -p $@

clean:
	rm -rf $(build)
