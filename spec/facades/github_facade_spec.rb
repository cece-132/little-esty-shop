require 'rails_helper'

RSpec.describe GithubFacade do
  # describe "get_github_data" do
  #   it 'returns a hash' do
  #     VCR.use_cassette("pull_request_data", :allow_playback_repeats => true) do
  #       VCR.use_cassette("teammate_data", :allow_playback_repeats => true) do
  #         VCR.use_cassette("repo_name_data", :allow_playback_repeats => true) do
  #           expect(GithubFacade.get_github_data).to be_instance_of(Hash)
  #           expect(GithubFacade.get_github_data[:teammates]).to be_instance_of(Array)
  #         end
  #       end
  #     end
  #   end
  # end

  # describe 'get_repo_name_data' do
  #   it 'returns the name of the repo' do
  #     VCR.use_cassette "repo_name_data" do
  #       expect(GithubFacade.get_repo_name_data).to eq("little-esty-shop")
  #     end
  #   end
  # end

  # describe '#teammate_data' do
  #   it 'displays the correct amount of data in the correct format' do
  #     VCR.use_cassette "teammate_data" do
  #       expect(GithubFacade.get_teammate_data.count).to eq(4)
  #     end
  #   end

  #   it 'gets teammate usernames' do
  #     VCR.use_cassette "teammate_data" do
  #       expect(GithubFacade.get_teammate_data.first.username).to eq("cballrun")
  #     end
  #   end

  #   it 'gets teammate commits' do
  #     VCR.use_cassette "teammate_data" do
  #       expect(GithubFacade.get_teammate_data.first.commits).to eq(73)
  #     end
  #   end
  # end

  # describe 'get_pull_request_data' do
  #   it 'returns the name of the repo' do
  #     VCR.use_cassette "pull_request_data" do
  #       expect(GithubFacade.get_pull_request_data).to be_instance_of(Integer)
  #     end
  #   end
  # end
end