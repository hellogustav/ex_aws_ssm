defmodule ExAws.SSMTest do
  use ExUnit.Case, async: true
  doctest ExAws.SSM

  test "GetParameter" do
    assert %ExAws.Operation.JSON{
             before_request: nil,
             data: %{
               "Name" => "/test/db/pass",
               "WithDecryption" => true
             },
             headers: [
               {"x-amz-target", "AmazonSSM.GetParameter"},
               {"content-type", "application/x-amz-json-1.1"}
             ],
             http_method: :post,
             parser: _,
             path: "/",
             service: :ssm,
             stream_builder: nil
           } = ExAws.SSM.get_parameter("/test/db/pass", with_decryption: true)
  end

  test "GetParameters" do
    assert %ExAws.Operation.JSON{
             before_request: nil,
             data: %{
               "Names" => ["/test/db/user", "/test/db/pass"],
               "WithDecryption" => true
             },
             headers: [
               {"x-amz-target", "AmazonSSM.GetParameters"},
               {"content-type", "application/x-amz-json-1.1"}
             ],
             http_method: :post,
             parser: _,
             path: "/",
             service: :ssm,
             stream_builder: nil
           } = ExAws.SSM.get_parameters(["/test/db/user", "/test/db/pass"], with_decryption: true)
  end

  test "GetParametersByPath" do
    assert %ExAws.Operation.JSON{
             before_request: nil,
             data: %{
               "Path" => "/test/",
               "Recursive" => true,
               "WithDecryption" => false,
               "ParameterFilters" => [
                 %{
                   "Key" => "test",
                   "Option" => "option",
                   "Values" => ["value1", "value2"]
                 }
               ]
             },
             headers: [
               {"x-amz-target", "AmazonSSM.GetParametersByPath"},
               {"content-type", "application/x-amz-json-1.1"}
             ],
             http_method: :post,
             parser: _,
             path: "/",
             service: :ssm,
             stream_builder: nil
           } =
             ExAws.SSM.get_parameters_by_path("/test/",
               recursive: true,
               parameter_filters: [
                 [
                   key: "test",
                   option: "option",
                   values: ["value1", "value2"]
                 ]
               ]
             )
  end

  test "PutParameter" do
    assert %ExAws.Operation.JSON{
             before_request: nil,
             data: %{
               "Name" => "pass",
               "Overwrite" => true,
               "Type" => "String",
               "Value" => "test1234",
               "Description" => "A password",
               "KeyId" => "3cd0aeb4-f30a-4676-a78f-242fb73e76d4"
             },
             headers: [
               {"x-amz-target", "AmazonSSM.PutParameter"},
               {"content-type", "application/x-amz-json-1.1"}
             ],
             http_method: :post,
             parser: _,
             path: "/",
             service: :ssm,
             stream_builder: nil
           } =
             ExAws.SSM.put_parameter(
               name: "pass",
               overwrite: true,
               type: :string,
               value: "test1234",
               description: "A password",
               key_id: "3cd0aeb4-f30a-4676-a78f-242fb73e76d4"
             )
  end

  test "DeleteParameter" do
    assert %ExAws.Operation.JSON{
             before_request: nil,
             data: %{"Name" => "/apple/pie"},
             headers: [
               {"x-amz-target", "AmazonSSM.DeleteParameter"},
               {"content-type", "application/x-amz-json-1.1"}
             ],
             http_method: :post,
             params: %{},
             parser: _,
             path: "/",
             service: :ssm,
             stream_builder: nil
           } = ExAws.SSM.delete_parameter("/apple/pie")
  end

  test "DeleteParameters" do
    assert %ExAws.Operation.JSON{
             before_request: nil,
             data: %{"Names" => ["/apple/pie", "/blueberry/pie"]},
             headers: [
               {"x-amz-target", "AmazonSSM.DeleteParameters"},
               {"content-type", "application/x-amz-json-1.1"}
             ],
             http_method: :post,
             params: %{},
             parser: _,
             path: "/",
             service: :ssm,
             stream_builder: nil
           } = ExAws.SSM.delete_parameters(["/apple/pie", "/blueberry/pie"])
  end

  test "GetParameterHistory" do
    assert %ExAws.Operation.JSON{
             before_request: nil,
             data: %{"Name" => "/blueberry/pankakes", "WithDecryption" => false},
             headers: [
               {"x-amz-target", "AmazonSSM.GetParameterHistory"},
               {"content-type", "application/x-amz-json-1.1"}
             ],
             http_method: :post,
             params: %{},
             parser: _,
             path: "/",
             service: :ssm,
             stream_builder: nil
           } = ExAws.SSM.get_parameter_history("/blueberry/pankakes")
  end
end
