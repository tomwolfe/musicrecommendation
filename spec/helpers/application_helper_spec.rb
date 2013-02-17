require_relative '../spec_helper'

describe ApplicationHelper do
	before :each do
		@user = FactoryGirl.create(:user)
	end
	
	describe 'count_and_max_updated_at(model_name)' do
		it 'returns an array containing model_name.count and the last updated record of that model' do
			helper.count_and_max_updated_at(User).should == [1, @user.updated_at.try(:utc).try(:to_s, :number)]
		end
	end

	describe 'cache_key(model_name, optional_attributes={})' do
		it 'returns a key to be used for caching' do
			helper.cache_key("user", {action: "fake"}).should == "model_name-user/count-1/updated-#{@user.updated_at.try(:utc).try(:to_s, :number)}/action-fake"
		end
	end
end
