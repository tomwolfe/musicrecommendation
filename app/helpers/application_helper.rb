module ApplicationHelper
	def count_and_max_updated_at(model_name)
		[model_name.count, model_name.maximum(:updated_at).try(:utc).try(:to_s, :number)]
	end

	def cache_key(model_name, optional_attributes={})
		base = ""
		unless model_name.nil? # skip this for non active-record models
			count, max_updated_at = count_and_max_updated_at(model_name.classify.constantize)
			base = "model_name-#{model_name}/count-#{count}/updated-#{max_updated_at}"
		end
		optional_attributes.each { |name, value| base << "/#{name}-#{value}" } if optional_attributes
		base
	end
end
