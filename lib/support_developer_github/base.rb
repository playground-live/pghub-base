require 'support_developer_github/base/version'
require 'support_developer_github/engine'
require 'support_developer_github/config'
require 'support_developer_github/github_api'
# TODO : lgtmに移植
require 'mechanize'

module SupportDeveloperGithub
  module Base
    # TODO : lgtmに移植
    LGTM_MARKDOWN_PATTERN = /(!\[LGTM\]\(.+\))\]/
    @webhook_params = nil

    def process_webhook(params)
      @webhook_params = params

      # TODO : lgtmをincludeしているかどうか判定
      post_lgtm_image if input.include?('LGTM') && !input.include?('[LGTM]')

      # TODO : issue-titleをincludeしているかどうか判定
      case @webhook_params[:action]
      when 'opened', 'edited', 'reopened', 'submitted', 'created'
        # TODO : issue_titleで１つのメソッドにまとめる
        issue_client = GithubAPI.new(issue_path_from(input))
        content = issue_client.get_title
        comment_client = GithubAPI.new(issue_path)
        comment_client.post(content)
      end
    end

    private

    # TODO : lgtmに移植
    def post_lgtm_image
      text = get_markdown_lgtm_from('http://lgtm.in')

      raise 'Invalid text near "LGTM"' unless text =~ LGTM_MARKDOWN_PATTERN

      image_md_link = Regexp.last_match[1]
      # image_md_linkが正常なURLか判定する
      comment_client = GithubAPI.new(issue_path)
      comment_client.post(image_md_link)
    end

    # TODO : lgtmに移植
    def get_markdown_lgtm_from(url)
      agent = Mechanize.new

      raise 'Random button is not found in http://lgtm.in.' unless agent.get(url).link_with(text: 'Random')
      page = agent.get(url).link_with(text: 'Random').click

      raise 'Markdown text is not found in http://lgtm.in.' unless page.at('textarea#markdown')
      page.at('textarea#markdown').inner_text
    end

    def input
      unless  %w[opened edited reopened created submitted].include?(@webhook_params[:action])
        raise "#{@webhook_params[:action]} is invalid action."
      end

      if @webhook_params[:comment]
        @webhook_params[:comment][:body]
      elsif @webhook_params[:review]
        @webhook_params[:review][:body]
      elsif @webhook_params[:issue]
        @webhook_params[:issue][:body]
      else
        @webhook_params[:pull_request][:body]
      end
    end

    # TODO : issue_titleに移植
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
