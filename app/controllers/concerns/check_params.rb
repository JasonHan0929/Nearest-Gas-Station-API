module CheckParams

  def is_number?(string)
    # check if a param is number
    true if Float(string) rescue false
  end

  def check_params(params)
    # check the presence of longitude and latitude
    if (params.has_key?(:lng) && params.has_key?(:lat))
      if (is_number?(params[:lng]) && is_number?(params[:lat]))
        params[:lng] = params[:lng].to_f
        params[:lat] = params[:lat].to_f
        if (params[:lng] <= 180 && params[:lng] >= -180 && params[:lat] >= -85 && params[:lat] <= 85)
          return true
        end
      end
    end
  end

  def invalid_params(params)
    {object: {
      error: "Parameters are invalid or out of range!",
      params: {
        latitude: params[:lat],
        longitude: params[:lng]
      }
    },
    status_code: 422}
  end

end