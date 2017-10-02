require 'pghub/base/version'
require 'pghub/engine'
require 'pghub/config'
require 'pghub/github_api'

module PgHub
  module Base
    @webhook_params = nil

    def process_webhook(params)
      @webhook_params = params

      if defined? Lgtm
        Lgtm.post_md_image(issue_path) if input.include?('LGTM') && !input.include?('[LGTM]')
      end

      case @webhook_params[:action]
      when 'opened', 'edited', 'reopened', 'submitted', 'created'
        # TODO : issue_titleをincludeしているかどうか判定
        # TODO : 以下の２行をissue_titleに移植
        issue_client = GithubAPI.new(issue_path_from(input))
        content = issue_client.get_title

        comment_client = GithubAPI.new(issue_path)
        comment_client.post(content)
      end
    end

    private

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
      reg_organization         = %r{#{PgHub.config.github_organization}\/}
      ref_issue_url            = %r{ref https:\/\/github.com\/#{PgHub.config.github_organization}\/.+\/\d+}
      ref_completion_issue_url = %r{ref #(\d+)}

      if input.match(ref_issue_url).present?
        matched_word = input.match(ref_issue_url)[0]
        issue_url = matched_word.match(reg_organization).post_match
      elsif input.match(ref_completion_issue_url).present?
        issue_num = input.match(ref_completion_issue_url)[1]
        data = issue_path.split('/')
        data[data.length - 1] = issue_num
        issue_url = data.join('/')
      else
        raise 'issue_url is not found.'
      end

      issue_url.gsub(/pull/, 'issues')
    end

    def issue_path
      reg_organization = %r{#{PgHub.config.github_organization}\/}

      if %w[opened edited reopened created submitted].include?(@webhook_params[:action])
        path = @webhook_params[:issue].present? ? @webhook_params[:issue][:url] : @webhook_params[:pull_request][:issue_url]
      else
        raise "#{@webhook_params[:action]} is invalid action."
      end

      path.match(reg_organization).post_match
    end
  end
end
