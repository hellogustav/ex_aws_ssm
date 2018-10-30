defmodule ExAws.SSM.Utils do
  def maybe_add_max_results(query_params, input_params) do
    if input_params[:max_results],
      do: Map.put(query_params, "MaxResults", input_params[:max_results]),
      else: query_params
  end

  def maybe_add_next_token(query_params, input_params) do
    if input_params[:next_token],
      do: Map.put(query_params, "NextToken", input_params[:next_token]),
      else: query_params
  end

  def maybe_add_key_id(query_params, input_params) do
    if input_params[:key_id],
      do: Map.put(query_params, "KeyId", input_params[:key_id]),
      else: query_params
  end
end
