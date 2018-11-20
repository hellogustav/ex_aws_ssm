defmodule ExAws.SSMTest do
  use ExUnit.Case, async: true
  doctest ExAws.SSM

  setup context do
    if params = context[:create_params] do
      params
      |> Enum.each(fn param ->
        apply(ExAws.SSM, :put_parameter, param)
        |> ExAws.request!()
      end)

      unless context[:no_cleanup] do
        on_exit(fn ->
          params
          |> Enum.map(&hd/1)
          |> ExAws.SSM.delete_parameters()
          |> ExAws.request!()
        end)
      end
    end

    :ok
  end

  describe "put_parameter" do
    test "return ExAws.Operation" do
      assert %ExAws.Operation.JSON{
               before_request: nil,
               data: %{
                 "Name" => "/blueberry/pankakes",
                 "Overwrite" => true,
                 "Type" => "SecureString",
                 "Value" => "test1234",
                 "Description" => "A secure string",
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
                 "/blueberry/pankakes",
                 :secure_string,
                 "test1234",
                 overwrite: true,
                 description: "A secure string",
                 key_id: "3cd0aeb4-f30a-4676-a78f-242fb73e76d4"
               )
    end

    @tag create_params: [["/pie/blackberry", :string_list, "United States, Germany"]]
    @tag :integration
    test "puts a parameter" do
      assert %{
               "Parameter" => %{
                 "Name" => "/pie/blackberry",
                 "Type" => "StringList",
                 "Value" => "United States, Germany",
                 "Version" => 1
               }
             } = ExAws.SSM.get_parameter("/pie/blackberry") |> ExAws.request!()
    end
  end

  describe "get_parameter" do
    test "return ExAws.Operation" do
      assert %ExAws.Operation.JSON{
               before_request: nil,
               data: %{
                 "Name" => "/pie/derby",
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
             } = ExAws.SSM.get_parameter("/pie/derby", with_decryption: true)
    end

    @tag create_params: [["/pie/derby", :string, "Kentucky, United States"]]
    @tag :integration
    test "get parameter" do
      assert %{
               "Parameter" => %{
                 "Name" => "/pie/derby",
                 "Type" => "String",
                 "Value" => "Kentucky, United States",
                 "Version" => 1
               }
             } == ExAws.SSM.get_parameter("/pie/derby") |> ExAws.request!()
    end
  end

  describe "get_parameters" do
    test "return ExAws.Operation" do
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
             } =
               ExAws.SSM.get_parameters(["/test/db/user", "/test/db/pass"], with_decryption: true)
    end

    @tag create_params: [
           ["/pie/blueberry", :string_list, "New England, United States, Germany"],
           ["/pie/apple", :string_list, "Netherlands, Germany"]
         ]
    @tag :integration
    test "gets parameters" do
      assert %{
               "InvalidParameters" => [],
               "Parameters" => [
                 %{
                   "Name" => "/pie/blueberry",
                   "Type" => "StringList",
                   "Value" => "New England, United States, Germany",
                   "Version" => 1
                 },
                 %{
                   "Name" => "/pie/apple",
                   "Type" => "StringList",
                   "Value" => "Netherlands, Germany",
                   "Version" => 1
                 }
               ]
             } == ExAws.SSM.get_parameters(["/pie/blueberry", "/pie/apple"]) |> ExAws.request!()
    end

    @tag :integration
    test "invalid parameters" do
      assert %{
               "InvalidParameters" => ["/pie/key_lime", "/pie/knish"],
               "Parameters" => []
             } == ExAws.SSM.get_parameters(["/pie/key_lime", "/pie/knish"]) |> ExAws.request!()
    end
  end

  describe "get_parameters_by_path" do
    test "return ExAws.Operation" do
      assert %ExAws.Operation.JSON{
               before_request: nil,
               data: %{
                 "Path" => "/pie/",
                 "Recursive" => true,
                 "WithDecryption" => false,
                 "ParameterFilters" => [
                   %{
                     "Key" => "pie",
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
               ExAws.SSM.get_parameters_by_path("/pie/",
                 recursive: true,
                 parameter_filters: [
                   [
                     key: "pie",
                     option: "option",
                     values: ["value1", "value2"]
                   ]
                 ]
               )
    end
  end

  describe "delete_parameter" do
    test "return ExAws.Operation" do
      assert %ExAws.Operation.JSON{
               before_request: nil,
               data: %{"Name" => "/pie/buko"},
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
             } = ExAws.SSM.delete_parameter("/pie/buko")
    end

    @tag create_params: [
           ["/pie/buko", :string, "Philippines"]
         ]
    @tag :no_cleanup
    @tag :integration
    test "delete parameter" do
      assert {:ok, _} = ExAws.SSM.delete_parameter("/pie/buko") |> ExAws.request()

      assert {:error,
              {:http_error, 400,
               %{
                 "__type" => "ParameterNotFound",
                 "message" => _
               }}} = ExAws.SSM.get_parameter("/pie/buko") |> ExAws.request()
    end
  end

  describe "delete_parameters" do
    test "return ExAws.Operation" do
      assert %ExAws.Operation.JSON{
               before_request: nil,
               data: %{"Names" => ["/pie/cherry", "/pie/chestnut"]},
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
             } = ExAws.SSM.delete_parameters(["/pie/cherry", "/pie/chestnut"])
    end

    @tag create_params: [
           ["/pie/cherry", :string_list, "United States, Germany"],
           ["/pie/chestnut", :string, "n/a"]
         ]
    @tag :no_cleanup
    @tag :integration
    test "delete parameters" do
      assert {:ok, _} =
               ExAws.SSM.delete_parameters(["/pie/cherry", "/pie/chestnut"]) |> ExAws.request()

      assert {:ok,
              %{
                "InvalidParameters" => ["/pie/cherry", "/pie/chestnut"],
                "Parameters" => []
              }} = ExAws.SSM.get_parameters(["/pie/cherry", "/pie/chestnut"]) |> ExAws.request()
    end
  end

  describe "get_parameter_history" do
    test "return ExAws.Operation" do
      assert %ExAws.Operation.JSON{
               before_request: nil,
               data: %{"Name" => "/pie/killie", "WithDecryption" => false},
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
             } = ExAws.SSM.get_parameter_history("/pie/killie")
    end
  end
end
