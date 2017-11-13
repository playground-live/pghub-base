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
        Pghub::AutoAssign.post(issue_path, opened_user) if action == 'opened'
      end

      head 200
    end

    private

    def webhook_params
      params[:webhook]
    end

    def action
      webhook_params[:action]
    end

    def permitted_params
      if webhook_params[:comment]
        webhook_params[:comment]
      elsif webhook_params[:review]
        webhook_params[:review]
      elsif webhook_params[:issue]
        webhook_params[:issue]
      else
        webhook_params[:pull_request]
      end
    end

    def input
      permitted_params[:body]
    end

    def opened_user
      permitted_params[:user][:login]
    end

    def issue_path
      reg_organization = %r{#{Pghub.config.github_organization}\/}
      path = webhook_params[:issue].present? ? webhook_params[:issue][:url] : webhook_params[:pull_request][:issue_url]

      path.match(reg_organization).post_match
    end
  end
end
