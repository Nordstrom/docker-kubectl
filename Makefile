image_name := kubectl
image_registry := quay.io/nordstrom
kubectl_version := 1.4.6
image_release := $(kubectl_version)-1

build := build

ifdef http_proxy
build_args := --build-arg=http_proxy=$(http_proxy) --build-arg=https_proxy=$(http_proxy)
endif

build_args += --build-arg KUBECTL_RELEASE=$(kubectl_version)

.PHONY: build/image tag/image push/image clean

build/image: build/SHA256SUMS.kubectl | build
	cp {Dockerfile,setup_kubectl.sh} build
	cd build && docker build -t $(image_name) $(build_args) .

tag/image: build/image
	docker tag $(image_name) $(image_registry)/$(image_name):$(image_release)

push/image: tag/image
	docker push $(image_registry)/$(image_name):$(image_release)

# When incrementing kubectl version, update the variable in this file,
# delete SHA256SUMS.kubectl & build/kubectl and this will recreate it
build/SHA256SUMS.kubectl: | build/kubectl build
	cd build && shasum -a256 kubectl > SHA256SUMS.kubectl

build/kubectl: | build
	curl -Lo $@ https://storage.googleapis.com/kubernetes-release/release/v$(kubectl_version)/bin/linux/amd64/kubectl

build:
	mkdir -p $@

clean:
	rm -rf build
