defmodule ExAws.SSM do
  @moduledoc """
  Documentation for ExAws.SSM.
  """

  @version "2014-11-06"

  @type get_parameters_by_path_params :: [
    path: binary,
    recursive: boolean,
    with_decription: boolean,
    max_results: pos_integer,
    next_token: binary,
    parameter_filters: list(parameter_filters)
  ]

  @type parameter_filters :: [
    key: binary,
    option: binary,
    values: list(binary)
  ]

  @type put_parameter_params :: [
    allowed_pattern: binary,
    description: binary,
    key_id: binary,
    name: binary,
    overwrite: boolean,
    type: binary,
    value: binary
  ]

  @doc """
  Retrieve parameters in a specific hierarchy.
  """
  @spec get_parameters_by_path(path :: binary) :: ExAws.Operation.JSON.t
  @spec get_parameters_by_path(path :: binary, params :: get_parameters_by_path_params) :: ExAws.Operation.JSON.t
  def get_parameters_by_path(path, params \\ []) do
    query_params = %{
      "Path" => path,
      "Recursive" => params[:recursive] || false,
      "WithDecryption" => params[:with_decription] || false
    }

    query_params = case params[:max_results] do
      nil -> query_params
      _ -> Map.put(query_params, "MaxResults", params[:max_results])
    end

    query_params = case params[:next_token] do
      nil -> query_params
      _ -> Map.put(query_params, "NextToken", params[:next_token])
    end

    query_params = case is_list(params[:parameter_filters]) do
      false -> query_params
      true -> params[:parameter_filters]
        |> Enum.map(fn filter -> 
        %{
          "Key" => filter[:key],
          "Option" => filter[:option],
          "Values" => filter[:values]
        }
      end) |> (&(Map.put(query_params, "ParameterFilters", &1))).()
    end

    request(:get_parameters_by_path, query_params)
  end

  @spec put_parameter(params :: put_parameter_params) :: ExAws.Operation.JSON.t
  def put_parameter(params) do
    value_type = case params[:type] do
      :string -> "String"
      :string_list -> "StringList"
      :secure_string -> "SecureString"
    end

    query_params = %{
      "Name" => params[:name],
      "Overwrite" => params[:overwrite] || false,
      "Value" => params[:value],
      "Type" => value_type,
      "Description" => params[:description] || ""
    }

    query_params = case params[:key_id] do
      nil -> query_params
      _ -> Map.put(query_params, "KeyId", params[:key_id])
    end

    request(:put_parameter, query_params)
  end

  defp request(action, params) do
    operation = action |> Atom.to_string |> Macro.camelize

    ExAws.Operation.JSON.new(:ssm, %{
      data: params,
      headers: [
        {"x-amz-target", "AmazonSSM.#{operation}"},
        {"content-type", "application/x-amz-json-1.1"},
      ]
    })
  end
end
