// main template for openshift4-slos
local com = import 'lib/commodore.libjsonnet';
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';

local slo = import 'slos.libsonnet';

local inv = kap.inventory();
// The hiera parameters for the component
local params = inv.parameters.lieutenant_keycloak_idp_controller;

local upstreamNamespace = 'lieutenant-keycloak-idp-controller-system';

local removeUpstreamNamespace = kube.Namespace(upstreamNamespace) {
  metadata: {
    name: upstreamNamespace,
  } + com.makeMergeable(params.namespaceMetadata),
};

local controllerPatch = {
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    name: 'lieutenant-keycloak-idp-controller-controller-manager',
    namespace: upstreamNamespace,
  },
  spec: {
    template: {
      spec: {
        containers: [ {
          name: 'manager',
          args: params.controller.args,
          env: com.envList(params.controller.env),
          volumeMounts: [ {
            name: 'templates',
            mountPath: '/templates',
          } ],
        } ],
        volumes: [ {
          name: 'templates',
          configMap: {
            name: 'lieutenant-keycloak-idp-controller-templates',
          },
        } ],
      },
    },
  },
};

local patch = function(p) {
  patch: std.manifestJsonMinified(p),
};

com.Kustomization(
  'https://github.com/projectsyn/lieutenant-keycloak-idp-controller//config/default',
  params.manifests_version,
  {
    'ghcr.io/projectsyn/lieutenant-keycloak-idp-controller': {
      local image = params.images.lieutenant_keycloak_idp_controller,
      newTag: image.tag,
      newName: '%(registry)s/%(image)s' % image,
    },
    'gcr.io/kubebuilder/kube-rbac-proxy': {
      local image = params.images.kube_rbac_proxy,
      newTag: image.tag,
      newName: '%(registry)s/%(image)s' % image,
    },
  },
  params.kustomize_input {
    patches+: [
      patch(removeUpstreamNamespace),
      patch(controllerPatch),
    ],
    labels+: [
      {
        pairs: {
          'app.kubernetes.io/managed-by': 'commodore',
        },
      },
    ],
  },
)
