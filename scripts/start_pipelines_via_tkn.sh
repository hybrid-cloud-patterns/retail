#!/bin/bash -x

namespace='quarkuscoffeeshop-cicd'

# These apps build with the default pipeline
apps=('quarkuscoffeeshop-barista' 'quarkuscoffeeshop-counter' 'quarkuscoffeeshop-counter' 'quarkuscoffeeshop-customermocker' 'quarkuscoffeeshop-inventory' 'quarkuscoffeeshop-kitchen' 'quarkuscoffeeshop-majestic-monolith' 'quarkuscoffeeshop-web' 'quarkuscoffeeshop-customerloyalty' 'homeoffice-backend' 'homeoffice-ingress')
for app in ${apps[@]}; do
    pipeline="build-and-push-$app"
    mavenpvc="$app-maven-settings-pvc"
    workspacepvc="$app-shared-workspace-pvc"
    gitresource="$app-git"
    imageresource="$app-image"
    tkn pipeline start $pipeline -n $namespace \
        --resource 'app-git'="$gitresource" \
        --resource image="$imageresource" \
        --workspace name='shared-workspace',claimName="$workspacepvc" \
        --workspace name='maven-settings',claimName="$mavenpvc" \
        --use-param-defaults
done

for plr in $(ls charts/hub/quarkuscoffeeshop-pipelines/extra/*.yaml); do
    oc create -f $plr
done
