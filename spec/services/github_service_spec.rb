require 'rails_helper'


RSpec.describe GithubService do
  # it 'gets base github repo hash with name field as a string' do
  #   VCR.use_cassette("repo_name_data", :allow_playback_repeats => true) do
  #     expect(GithubService.get_data("")).to be_instance_of(Hash)
  #     require 'pry'; binding.pry
  #     expect(GithubService.get_data("")[:name]).to be_instance_of(String)
  #   end
  # end

  # it 'gets contributors github array with contributor field as a string' do
  #   VCR.use_cassette("teammate_data", :allow_playback_repeats => true) do
  #     expect(GithubService.get_data("/contributors")).to be_instance_of(Array)
  #     expect(GithubService.get_data("/contributors").first[:login]).to be_instance_of(String)
  #   end
  # end

  # it 'gets contributors github array with contributions field as a number' do
  #   VCR.use_cassette("teammate_data", :allow_playback_repeats => true) do
  #     expect(GithubService.get_data("/contributors").first[:contributions]).to be_instance_of(Integer)
  #   end
  # end

  # it 'gets pull requests github array with id field as a number' do
  #   VCR.use_cassette("pull_request_data", :allow_playback_repeats => true) do
  #     expect(GithubService.get_data("/pulls?state=all")).to be_instance_of(Array)
  #     expect(GithubService.get_data("/pulls?state=all").first[:id]).to be_instance_of(Integer)
  #   end
  # end
end