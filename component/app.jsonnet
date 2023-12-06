local kap = import 'lib/kapitan.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.lieutenant_keycloak_idp_controller;
local argocd = import 'lib/argocd.libjsonnet';

local app = argocd.App('lieutenant-keycloak-idp-controller', params.namespace);

{
  'lieutenant-keycloak-idp-controller': app,
}
