# aws.greengrass.labs.SecretsManagerClient

This component deploys a SecretManagerClient java cli tool that can be used by other components to retrieve secrets that have been synchronized locally to the Greengrass core via the `aws.greengrass.SecretManager` component.

This component does not perform any processing on its own and only deploys the executable. You need to invoke the executable from another component which you made dependent on `aws.greengrass.labs.SecretsManagerClient` by executing:

```
java -jar
  {aws.greengrass.labs.SecrectsManagerClient:artifacts:path}/secrets.jar
  <secretId>
```

To allow the component using the SecretManagerClient to access the secret, you need to add an `accessControl` section in the [Retrieve Secret Values](https://docs.aws.amazon.com/greengrass/v2/developerguide/ipc-secret-manager.html#ipc-secret-manager-authorization). Refer also to the [Requirements](https://docs.aws.amazon.com/greengrass/v2/developerguide/secret-manager-component.html#secret-manager-component-requirements) for the necessary authorization policies to be added to the Greengrass Token Exchange Role.

For example, the recipe of a component using SecretsManagerClient would look like:

```yaml
RecipeFormatVersion: 2020-01-25
...
ComponentDependencies:
  aws.greengrass.labs.SecretsManagerClient:
    VersionRequirement: ">0.0.0"
ComponentConfiguration:
  DefaultConfiguration:
    username: "test"
    accessControl:
      aws.greengrass.SecretManager:
        auth-1:
          operations:
          - aws.greengrass#GetSecretValue
          resources:
          - "*"
Manifests:
  - Lifecycle:
      Startup:
        Script: |-
          PWD=$(java -jar {aws.greengrass.labs.SecretsManagerClient:artifacts:path}/secrets.jar aws.greengrass.labs.nodered/{configuration:/username})
          ...
```

## Installation

To install this component follow the instructions in [BUILD.md](./BUILD.md)

## Versions
This component has the following versions:

* 1.0.0

## Type

This component is a generic component. The [Greengrass nucleus](https://docs.aws.amazon.com/greengrass/v2/developerguide/greengrass-nucleus-component.html) runs the component's lifecycle scripts.

For more information, see [component types](https://docs.aws.amazon.com/greengrass/v2/developerguide/manage-components.html#component-types)


## Requirements

This component does not have any additional requirements to Greengrass Nucleus.

## Dependencies

When you deploy a component, AWS IoT Greengrass also deploys compatible versions of its dependencies. This means that you must meet the requirements for the component and all of its dependencies to successfully deploy the component. This section lists the dependencies for the released versions of this component and the semantic version constraints that define the component versions for each dependency. You can also view the dependencies for each version of the component in the [AWS IoT Greengrass console](https://console.aws.amazon.com/greengrass). On the component details page, look for the Dependencies list.

### 1.0.0

| Dependency | Compatible versions | Dependency type |
|---|---|---|
| Secret Manger | >=0.0.0 <3.0.0 | Soft |


## Configuration

This component does not have any configuration


## Local log file

This component does not generate any log. You can find log entries in the log file of the component using it.


## Changelog

The following table describes the changes in each version of the component.

| Version | Changes |
|---|---|
| 1.0.0 | Initial version |


<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.39.1 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_component_bucket"></a> [component\_bucket](#module\_component\_bucket) | terraform-aws-modules/s3-bucket/aws | 3.15.1 |

## Resources

| Name | Type |
|------|------|
| [null_resource.build_and_publish](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_component_version"></a> [component\_version](#input\_component\_version) | n/a | `string` | `"1.0.0"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
