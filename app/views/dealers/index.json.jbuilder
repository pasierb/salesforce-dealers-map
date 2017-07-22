json.dealers do
  json.array! @dealers,
    :id,
    :name,
    :longitude,
    :latitude,
    :street,
    :city,
    :zip,
    :country,
    :phone
end
