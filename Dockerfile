FROM ghcr.io/runatlantis/atlantis:v0.21.0
RUN apk --update  add aws-cli \
	curl \
	make \
	unzip	

ENV TERRAGRUNT=0.42.5
ENV TERRAGRUNT_ATLANTIS_CONFIG=1.16.0


### Ensure Terragrunt version is present and validated
###
RUN set -eux \
	&& if [ "${TERRAGRUNT}" = "latest" ]; then \
		TERRAGRUNT="$( \
			curl -L -sS https://github.com/gruntwork-io/terragrunt/releases \
			| tac | tac \
			| grep -Eo '"/gruntwork-io/terragrunt/releases/tag/v?[0-9]+\.[0-9]+\.[0-9]+"' \
			| grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' \
			| sort -V \
			| tail -1 \
		)"; \
	fi \
	&& curl -L -sS "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT}/terragrunt_linux_amd64" -o /usr/local/bin/terragrunt \
	&& chmod +x /usr/local/bin/terragrunt \
	&& terragrunt --version | grep "v${TERRAGRUNT}"

###
### Ensure the Terragrunt Atlantis Config is present
###
ADD https://github.com/transcend-io/terragrunt-atlantis-config/releases/download/v${TERRAGRUNT_ATLANTIS_CONFIG}/terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG}_linux_amd64.tar.gz /usr/local/bin/
RUN set -eux \
	&& cd /usr/local/bin \
	&& tar xvzf terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG}_linux_amd64.tar.gz \
	&& mv terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG}_linux_amd64/terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG}_linux_amd64 terragrunt-atlantis-config \
	&& chmod +x terragrunt-atlantis-config \
	&& rm -rf terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG}_linux_amd64*


###
RUN mv /usr/local/bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint-original.sh
# the new docker-entrypoint.sh will do some work and then call the original entry point
ADD data/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ADD data/create_gitlab_user_ssh_key.sh /usr/local/bin/create_gitlab_user_ssh_key.sh
# if you need enable terraform mirror for atlantis
# ADD data/.terraformrc /home/atlantis/.terraformrc

