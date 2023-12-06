// main template for lieutenant-keycloak-idp-controller
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local inv = kap.inventory();
// The hiera parameters for the component
local params = inv.parameters.lieutenant_keycloak_idp_controller;

// Define outputs below
{
}
