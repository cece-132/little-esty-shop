class GithubFacade

  # def self.get_github_data
  #   github_data = Hash.new
  #   github_data[:repo_name] = get_repo_name_data
  #   github_data[:teammates] = get_teammate_data
  #   github_data[:pull_request_count] = get_pull_request_data
  #   github_data
  # end

  # def self.get_repo_name_data
  #   parsed = GithubService.get_data("")
  #   parsed[:name]
  # end

  # def self.get_teammate_data
  #   parsed = GithubService.get_data("/contributors")
  #   teammates = parsed.map do |teammate_data|
  #     Teammate.new(teammate_data)
  #   end
  #   our_teammates = [teammates[0], teammates[1], teammates[2], teammates[4]]
  # end

  # def self.get_pull_request_data
  #   parsed = GithubService.get_data("/pulls?state=all")
  #   parsed.size
  # end
end