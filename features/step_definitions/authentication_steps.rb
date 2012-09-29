When /I fill in the "(*.)" form with "(*.)" and "(*.)"/ do |form,email,pass|
  form=format_path(form)
  eval("visit #{form}_path")
end
