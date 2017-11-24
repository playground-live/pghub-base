require_dependency "pghub/base/application_controller"

module Pghub::Base
  class WebhooksController < ApplicationController
    VALID_ACTIONS = %w[
      opened
      edited
      created
      edited
      review_requested
      submitted
    ].freeze

    def create
      return unless VALID_ACTIONS.include?(action)

      if defined? Pghub::Lgtm
        Pghub::Lgtm.post(issue_path) if input.include?('LGTM')
      end

      if defined? Pghub::IssueTitle
        Pghub::IssueTitle.post(issue_path, input) if input.include?('ref')
      end

      if defined? Pghub::AutoAssign
        Pghub::AutoAssign.post(issue_path, opened_pr_user) if action == 'opened'
      end

      head 200
    end

    private

    def action
      params[:webhook][:action]
    end

    def webhook_params
      @webhook_params ||=
        if params[:webhook][:comment]
          params[:webhook][:comment]
        elsif params[:webhook][:review]
          params[:webhook][:review]
        elsif params[:webhook][:issue]
          params[:webhook][:issue]
        else
          params[:webhook][:pull_request]
        end
    end

    def input
      webhook_params[:body]
    end

    def opened_pr_user
      webhook_params[:user][:login]
    end

    def issue_path
      reg_organization = %r{#{Pghub.config.github_organization}\/}
      path = params[:webhook][:issue].present? ? params[:webhook][:issue][:url] : params[:webhook][:pull_request][:issue_url]

      path.match(reg_organization).post_match
    end
  end
end
