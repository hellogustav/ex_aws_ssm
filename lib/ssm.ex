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

  @doc """
  Retrieve parameters in a specific hierarchy.
  """
  @spec get_parameters_by_path(path :: binary) :: ExAws.Operation.JSON.t
  @spec get_parameters_by_path(path :: binary, params :: get_parameters_by_path_params) :: ExAws.Operation.JSON.t
  def get_parameters_by_path(path, params \\ []) do
    params = %{
      "Path" => path,
      "Recursive" => params[:recursive] || false,
      "WithDecryption" => params[:with_decription] || false
    }

    params = case params[:max_results] do
      nil -> params
      _ -> Map.put(params, "MaxResults", params[:max_results])
    end  

    params = case params[:next_token] do
      nil -> params
      _ -> Map.put(params, "NextToken", params[:next_token])
    end

    case is_list(params[:parameter_filters]) do
      false -> params
      true -> params[:parameter_filters] 
        |> Enum.map(fn filter -> 
        %{
          "Key" => filter[:key],
          "Option" => filter[:option],
          "Values" => filter[:values]
        }
      end)
    end

    request(:get_parameters_by_path, params)
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
