# Deploying Grafana to Azure App Service with Terraform (and Active Directory integration)
## Intro
Grafana is a free and open source platform which allows you to query, visualize, alert on and understand your metrics.
As your system grows bigger and has more moving parts, it becomes vital to be able to tell wheter it's healthy and operational at a glance. 

In Azure you can get your Grafana up and running by different means:

### Use Azure Managed Grafana
This is a fully managed service which can become a feasible option if there are no resources to spare on maintaining your monitoring solution. You can be sure that your managed Grafana instance will be up-to-date with the latest patches.

The downside of this approach is the price - it would cost ~5.7 euros per user per month at the time of writing, which is not too expensive if you don't need a lot of people to have access to the dashboard. Another limitation is that you can't install custom plugins due to security concerns.

### Deploy Grafana on Azure App Service
This option would shift more responsibility to the engineers as they would be responsible for making sure that the Grafana instance is patched and has all the necessary plugins installed. On the bright side, you will have more control over the platform and you don't have to pay per user.

## Prerequisites
In order to provision these resources, you will need:
 - Terraform (v1.1.9 at the time of writing)
 - Azure account with Owner rights on your subscription
 - Azure CLI
 - sqlite