defmodule ExAws.SSMTest do
  use ExUnit.Case
  doctest ExAws.SSM

  test "GetParametersByPath" do
    assert %ExAws.Operation.JSON{
      before_request: nil,
      data: %{
        "Path" => "/test/",
        "Recursive" => true,
        "WithDecryption" => false
      },
      headers: [{"x-amz-target", "AmazonSSM.GetParametersByPath"},
                {"content-type", "application/x-amz-json-1.1"}],
      http_method: :post,
      parser: _,
      path: "/",
      service: :ssm,
      stream_builder: nil} = ExAws.SSM.get_parameters_by_path("/test/", [recursive: true])
  end
end
