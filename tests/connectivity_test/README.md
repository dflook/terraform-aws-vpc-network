# VPC Connectivity Test

This module performs a connectivity test from inside a VPC. It is designed for use in Terraform tests.

Since we cannot assume there is network connectivity, reporting the result is tricky. The instance will stop itself if the test succeeds. The instance will continue running if the test fails.

