json.dealers do
  json.array! @dealers, :id, :name, :longitude, :latitude
end
