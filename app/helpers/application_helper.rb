module ApplicationHelper
	def count_and_max_updated_at(model)
		[model.count, model.maximum(:updated_at).try(:utc).try(:to_s, :number)]
	end

	def cache_key(model, optional_attributes={})
		count, max_updated_at = count_and_max_updated_at(model.classify.constantize)
		base = "model-#{model}/count-#{count}/updated-#{max_updated_at}"
		optional_attributes.each { |name, value| base << "/#{name}-#{value}" } if optional_attributes
		base
	end
end
