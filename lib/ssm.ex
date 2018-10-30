defmodule ExAws.SSM do
  @moduledoc """
  Documentation for ExAws.SSM.
  """

  @version "2014-11-06"

  @type get_parameters_by_path_params :: [
    path: binary,
    recursive: boolean,
    with_decryption: boolean,
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

  @type get_parameter_params :: [
    with_decryption: boolean
  ]

  @type get_parameter_history_params :: [
    max_results: pos_integer,
    name: binary,
    next_token: binary,
    with_decryption: boolean
  ]

  @doc """
  Get information about a parameter by using the parameter name.
  """
  @spec get_parameter(name :: binary) :: ExAws.Operation.JSON.t
  @spec get_parameter(name :: binary, params :: get_parameter_params) :: ExAws.Operation.JSON.t
  def get_parameter(name, params \\ []) do
    query_params = %{
      "Name" => name,
      "WithDecryption" => params[:with_decryption] || false
    }

    request(:get_parameter, query_params)
  end

  @doc """
  Get details of a parameter
  """
  @spec get_parameters(names :: list(binary)) :: ExAws.Operation.JSON.t
  @spec get_parameters(names :: list(binary), params :: get_parameter_params) :: ExAws.Operation.JSON.t
  def get_parameters(names, params \\ []) do
    query_params = %{
      "Names" => names,
      "WithDecryption" => params[:with_decryption] || false
    }

    request(:get_parameters, query_params)
  end

  @doc """
  Retrieve parameters in a specific hierarchy.
  """
  @spec get_parameters_by_path(path :: binary) :: ExAws.Operation.JSON.t
  @spec get_parameters_by_path(path :: binary, params :: get_parameters_by_path_params) :: ExAws.Operation.JSON.t
  def get_parameters_by_path(path, params \\ []) do
    query_params = %{
      "Path" => path,
      "Recursive" => params[:recursive] || false,
      "WithDecryption" => params[:with_decryption] || false
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

  @doc """
  Add a parameter to the system.
  """
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

  @doc """
  Delete a parameter from the system.
  """
  @spec delete_parameter(name :: binary) :: ExAws.Operation.JSON.t
  def delete_parameter(name) do
    request(:delete_parameter, %{"Name" => name})
  end

  @doc """
  Delete a list of parameters.
  """
  @spec delete_parameters(names :: list(binary)) :: ExAws.Operation.JSON.t
  def delete_parameters(names) do
    request(:delete_parameters, %{"Names" => names})
  end

  @doc """
  Query a list of all parameters used by the AWS account.
  """
  @spec get_parameter_history(name :: binary, params :: get_parameter_history_params) :: ExAws.Operation.JSON.t
  def get_parameter_history(name, params \\ []) do
    query_params = %{
      "Name" => name,
      "WithDecryption" => params[:with_decryption] || false
    }
    query_params = case params[:max_results] do
      nil -> query_params
      _ -> Map.put(query_params, "MaxResults", params[:max_results])
    end

    query_params = case params[:next_token] do
      nil -> query_params
      _ -> Map.put(query_params, "NextToken", params[:next_token])
    end

    request(:get_parameter_history, query_params)
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
