
# Custom Atlantis image

## Reasons

Custom image for [atlantis](https://www.runatlantis.io/) was needed:
- to add missing components
  - terragrunt
  - terragrunt-atlantis-config (https://github.com/transcend-io/terragrunt-atlantis-config)
  - taking care of the SSH key for the user atlantis uses to clone GitLab repos (the key is NOT embedded into the image)

## Key implementation details

- The following values are passed to the atlantis Helm chart (through a values file)
  
      environment:
        GITLAB_USER_SSH_KEY: 
  
 private ssh key need to be encode in base64
 
- We are placing a custom `/usr/local/bin/docker-entrypoint.sh` on the custom Atlantis image. It copies the GitLab SSH key to the atlantis home directory and then calls the original entrypoint.
