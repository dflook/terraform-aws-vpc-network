# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - Unreleased
### Added

- The `vpc` module has a new `secondary_cidr_blocks` input variable that allows additional CIDR blocks to be added to the VPC.
  These are included in the structured `vpc` output value.
  
### Changed

- The `vpc` module now enables Network Address Usage metrics. This also means that the minimum AWS provider version for this module is now 4.35.0.

## [1.0.0] - 2024-05-28
### Added

- Initial release of the module and submodules:
  - `vpc`
  - `subnets`
  - `internet-gateway`
  - `nat-gateway`
  - `cloudwatch-flow-logs`
  - `aws_endpoint_subnets`

[1.1.0]: https://github.com/dflook/terraform-aws-vpc-network/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/dflook/terraform-aws-vpc-network/tree/v1.0.0
