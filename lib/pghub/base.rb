require 'pghub/base/version'
require 'pghub/engine'
require 'pghub/config'
require 'pghub/github_api'

module PgHub
  module Base
    @webhook_params = nil

    class << self
      def process_webhook(params)
        @webhook_params = params

        if defined? Lgtm
          Lgtm.post_to(issue_path) if input.include?('LGTM') && !input.include?('[LGTM]')
        end

        case @webhook_params[:action]
        when 'opened', 'edited', 'reopened', 'submitted', 'created'
          IssueTitle.post_to(issue_path, input) if defined? IssueTitle
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
end
