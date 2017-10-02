require 'pghub/base/version'
require 'pghub/engine'
require 'pghub/config'
require 'pghub/github_api'

module PgHub
  module Base
    @webhook_params = nil
    VALID_ACTIONS = %w[
      opened
      edited
      created
      edited
      review_requested
      submitted
    ]

    class << self
      def process_webhook(params)
        @webhook_params = params

        return unless VALID_ACTIONS.include?(@webhook_params[:action])

        if defined? Lgtm
          Lgtm.post_to(issue_path) if input.include?('LGTM') && !input.include?('[LGTM]')
        end

        IssueTitle.post_to(issue_path, input) if defined? IssueTitle
      end

      private

      def input
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
        path = @webhook_params[:issue].present? ? @webhook_params[:issue][:url] : @webhook_params[:pull_request][:issue_url]

        path.match(reg_organization).post_match
      end
    end
  end
end
