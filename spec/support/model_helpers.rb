module ModelHelpers
  def recursively_delete_timestamps(object)
    object.transform_values do |value|
      next value unless value.is_a?(Array)

      value.map do |inner_hash|
        recursively_delete_timestamps(inner_hash)
      end
    end.reject do |key, _|
      key.in?(%w[created_at updated_at])
    end
  end
end
