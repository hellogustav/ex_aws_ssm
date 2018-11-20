use Mix.Config

config :ex_aws,
  access_key_id: "accesskeyid",
  secret_access_key: "secretaccesskey",
  region: "us-east-1"

config :ex_aws,
  ssm: [
    host: "localhost",
    scheme: "http://",
    port: 4583
  ]
