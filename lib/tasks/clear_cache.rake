# courtesy: http://stackoverflow.com/a/14524721/477788

if Rake::Task.task_defined?("assets:precompile:nondigest")
	Rake::Task["assets:precompile:nondigest"].enhance do
		Rails.cache.clear
	end
else
	Rake::Task["assets:precompile"].enhance do
		# rails 3.1.1 will clear out Rails.application.config if the env vars
		# RAILS_GROUP and RAILS_ENV are not defined. We need to reload the
		# assets environment in this case.
		# Rake::Task["assets:environment"].invoke if Rake::Task.task_defined?("assets:environment")
		Rails.cache.clear
	end
end
