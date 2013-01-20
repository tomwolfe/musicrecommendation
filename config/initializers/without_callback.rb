# thanks to http://jeffkreeftmeijer.com/2010/disabling-activemodel-callbacks/
module ActiveSupport::Callbacks::ClassMethods
	def without_callback(*args, &block)
		skip_callback(*args)
		yield
		set_callback(*args)
	end
end


