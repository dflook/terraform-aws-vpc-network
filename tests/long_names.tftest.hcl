provider "aws" {
  region = "eu-west-2"
}

run "init" {
  command = apply

  module {
    source = "./tests/long_names"
  }
}
