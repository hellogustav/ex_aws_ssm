# ExAws.SSM

Service module for https://github.com/ex-aws/ex_aws

Add support for SSM to ExAws

Documentation can be found at [https://hexdocs.pm/ex_aws_ssm](https://hexdocs.pm/ex_aws_ssm).

## API Coverage

The following actions are currently supported.

| action              |
| ---------------------- |
| delete_parameter       |
| delete_parameters      |
| get_parameter          |
| get_parameters         |
| get_parameters_by_path |
| get_parameter_history  |
| put_parameter          |

## Installation

The package can be installed by adding ex_aws_ssm to your list of dependencies in mix.exs along with :ex_aws and your preferred JSON codec / http client

```elixir
def deps do
  [
    {:ex_aws, "~> 2.0"},
    {:ex_aws_ssm, "~> 2.0.0"},
    {:poison, "~> 3.0"},
    {:hackney, "~> 1.9"},
  ]
end
```

## Testing
To run integration tests run the included `docker-compose.yml` using `docker-compose up` to start [localstack](https://github.com/localstack/localstack).
Now we can include integration tests by running `mix test` as:
```
$ mix test --include integration:true
```

## Configuration
You can set service specific configuration for `:ssm` in the same way as with other `ex_aws` service modules.

```elixir
config :ex_aws, ssm: [
  region: "us-west-2"
]
```


