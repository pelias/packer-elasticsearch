# Pelias Elasticsearch Packer Configuration

This repository contains [Packer](https://packer.io/) configuration for creating Elasticsearch [Amazon Machine Images](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) (AMIs).

These AMIs are most useful with the [Terraform](https://github.com/pelias/terraform-elasticsearch) scripts for using Elasticsearch with Pelias.

## Supported versions

This project supports Elasticsearch *7* and *8*. For Elasticsearch 5 or 6 support, use versions prior to git tag `v7.0.0`.

Elasticsearch 8 enables security by default, Pelias expects it to be disabled via `xpack.security.enabled: false` in `elasticsearch.yml`.

### Setup Instructions


1. (optional) Configure Elasticsearch version

This step is required only if you don't wish to use the default version of Elasticsearch, which will always be the [latest version of Elasticsearch supported by Pelias](https://github.com/pelias/documentation/blob/master/requirements.md).

Within the packer directory, create a file called `variables.json` and fill it in using the following template:

```
{
  "elasticsearch_version": "8.19.25-amd64"
}
```

To build an ARM image, also set the source AMI and instance type to match:

```
{
  "elasticsearch_version": "8.19.25-arm64",
  "source_ami_name": "*ubuntu-focal-20.04-arm64-server-*",
  "instance_type": "c6g.large"
}
```


2. Run packer

Then, run packer using the following command:
```
packer build -var-file=variables.json pelias-elasticsearch.json
```

In under 5 minutes Packer should have built an AMI.
