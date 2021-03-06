# EtherPad Helm
Helm chart to deploy [Etherpad](https://github.com/ether/etherpad-lite) into kubernetes along with Etherpad's user management plugin:  "[mypads](https://www.npmjs.com/package/ep_mypads)".
It includes a container image based on the official one. It adds user management, Abiword for exporting pads, and several extra plugins (checkout build).

* Based on:
  - https://github.com/Muelsy/ep_helm
  - https://github.com/focused-labs/charts/tree/master/focused/etherpad

## Requirements
* Helm 3

## Install
```
# install with helm-git
helm install -n etherpad --create-namespace -g etherpad --repo "git+https://github.com/krestomatio/ep_helm@?ref=main&sparse=1"

# OR

# install cloning repo
git clone --depth 1 https://github.com/krestomatio/ep_helm
cd ep_helm
helm install -n etherpad --create-namespace etherpad .
```

## Image build
```
# image tag
image_next_tag=1.8.6

# modify tag in Dockerfile
sed -i "s@^FROM etherpad.*@FROM etherpad/etherpad:${image_next_tag}@" Dockerfile

# modify version and appVversion in Chart.yaml
sed -i  \
    -e "s@^appVersion.*@appVersion: ${image_next_tag}@" \
    Chart.yaml

# modify README
sed -i \
    -E "s@:([0-9]+)\.([0-9]+)\.([0-9]+)@:${image_next_tag}@" \
    -E "s@=([0-9]+)\.([0-9]+)\.([0-9]+)@=${image_next_tag}@" \
    README.md

# modify values.yaml
sed -i -E "s@etherpad:([0-9]+)\.([0-9]+)\.([0-9]+)@etherpad:${image_next_tag}@" values.yaml

# build
docker build --build-arg \
    ETHERPAD_PLUGINS="ep_health_check ep_comments_page ep_author_neat ep_authornames ep_mypads ep_embedded_hyperlinks2 ep_font_color ep_font_family ep_font_size ep_tables4 ep_spellcheck" \
    -t krestomatio/etherpad:${image_next_tag} .

docker push krestomatio/etherpad:${image_next_tag}

# test
## TODO: add tests


# git
git add Dockerfile README Chart.yaml
git commit -m "chore: update image tag to ${image_next_tag}"
git push origin main
```

## Semantic version
```
# git tag
git_next_tag=$(git semver --next-patch)

# modify version and appVversion in Chart.yaml
sed -i  \
    -e "s@^version.*@version: ${git_next_tag}@" \
    Chart.yaml

# git
git add Chart.yaml
git commit -m "Release ${git_next_tag}"
git tag -f ${git_next_tag}
git push origin main --tags
```
