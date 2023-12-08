// main template for lieutenant-keycloak-idp-controller\
local com = import 'lib/commodore.libjsonnet';
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local inv = kap.inventory();
// The hiera parameters for the component
local params = inv.parameters.lieutenant_keycloak_idp_controller;

local secrets = com.generateResources(params.secrets, kube.Secret);
local configMaps = com.generateResources(params.config_maps, kube.ConfigMap);

// Define outputs below
{
  '10_secrets': secrets,
  '10_config_maps': configMaps,
}
