require 'rails_helper'
require 'teammate'

RSpec.describe Teammate do
  # it 'exists and has attributes' do
  #   VCR.use_cassette("teammate_data", :allow_playback_repeats => true) do
  #     teammate_hash = GithubService.get_data("contributors").first
  #     teammate = Teammate.new(teammate_hash)
  #     expect(teammate).to be_instance_of(Teammate)
  #     expect(teammate.username).to be_instance_of(String)
  #     expect(teammate.username).to eq("cballrun")
  #     expect(teammate.commits).to be_instance_of(Integer)
  #     expect(teammate.commits).to eq(73)
  #   end
  # end
end