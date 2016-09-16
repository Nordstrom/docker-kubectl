image_name := kubectl
image_registry := quay.io/nordstrom
kubectl_version := 1.3.6
image_release := $(kubectl_version)

build := build

ifdef http_proxy
build_args := --build-arg=http_proxy=$(http_proxy) --build-arg=https_proxy=$(http_proxy)
endif

build_args += --build-arg KUBECTL_RELEASE=$(kubectl_version)

.PHONY: build/image tag/image push/image clean

build/image: Dockerfile SHA256SUMS.kubectl setup_kubectl.sh
	docker build -t $(image_name) $(build_args) .

tag/image: build/image
	docker tag $(image_name) $(image_registry)/$(image_name):$(image_release)

push/image: tag/image
	docker push $(image_registry)/$(image_name):$(image_release)

build/kubectl: | build
	curl -sLO $@ https://storage.googleapis.com/kubernetes-release/release/v$(kubectl_version)/bin/linux/amd64/kubectl

SHA256SUMS.kubectl: build/kubectl | build
	cd build && shasum -a256 kubectl > $@

build:
	mkdir -p $@

clean:
	rm -rf build
