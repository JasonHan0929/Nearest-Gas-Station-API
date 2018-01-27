module Response
  def json_response(object: {}, status_code: :ok)
    render json: JSON.pretty_generate(object), status: status_code
  end
end