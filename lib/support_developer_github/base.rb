require "support_developer_github/base/version"
require "support_developer_github/engine"
require 'support_developer_github/config'
require "support_developer_github/github_api"
require "mechanize"

module SupportDeveloperGithub
  module Base
    LGTM_MARKDOWN_PATTERN = /(!\[LGTM\]\(.+\))\]/
    @webhook_params = nil

    def process_webhook(params)
      @webhook_params = params

      if input.include?('LGTM') && !input.include?('[LGTM]')
        post_lgtm_image
      end

      case @webhook_params[:action]
      when 'opened', 'edited', 'reopened', 'submitted', 'created'
        issue_client = GithubAPI.new(issue_path_from(input))
        content = issue_client.get_title
        comment_client = GithubAPI.new(issue_path)
        comment_client.post(content)
      end
    end

    private

    def post_lgtm_image
      agent = Mechanize.new
      page = agent.get('http://lgtm.in').link_with(text: 'Random').click
      text = page.at('textarea#markdown').inner_text

      if text =~ LGTM_MARKDOWN_PATTERN
        image_md_link = Regexp.last_match[1]
        comment_client = GithubAPI.new(issue_path)
        comment_client.post(image_md_link)
      else
        raise 'Invalid text near "LGTM"'
      end
    end

    def input
      if %w[opened edited reopened created submitted].include?(@webhook_params[:action])
        if @webhook_params[:comment]
          @webhook_params[:comment][:body]
        elsif @webhook_params[:review]
          @webhook_params[:review][:body]
        elsif @webhook_params[:issue]
          @webhook_params[:issue][:body]
        else
          @webhook_params[:pull_request][:body]
        end
      else
        raise "#{@webhook_params[:action]} is invalid action."
      end
    end

    def issue_path_from(input)
      reg_organization         = %r{#{SupportDeveloperGithub.config.github_organization}\/}
      ref_issue_url            = %r{ref https:\/\/github.com\/#{SupportDeveloperGithub.config.github_organization}\/.+\/\d+}
      ref_completion_issue_url = %r{ref #\d+}

      if input.match(ref_issue_url).present?
        matched_word = input.match(ref_issue_url)[0]
        issue_url = matched_word.match(reg_organization).post_match
      elsif input.match(ref_completion_issue_url).present?
        matched_word = input.match(ref_completion_issue_url)[0]
        issue_num = matched_word.match(/#/).post_match
        data = issue_path.split('/')
        data[data.length - 1] = issue_num
        issue_url = data.join('/')
      else
        raise 'issue_url is not found.'
      end

      issue_url.gsub(/pull/, 'issues')
    end

    def issue_path
      reg_organization = %r{#{SupportDeveloperGithub.config.github_organization}\/}

      if %w[opened edited reopened created submitted].include?(@webhook_params[:action])
        path = @webhook_params[:issue].present? ? @webhook_params[:issue][:url] : @webhook_params[:pull_request][:issue_url]
      else
        raise "#{@webhook_params[:action]} is invalid action."
      end

      path.match(reg_organization).post_match
    end
  end
end
