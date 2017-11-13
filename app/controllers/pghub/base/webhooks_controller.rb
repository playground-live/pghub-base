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

    def action
      params[:webhook][:action]
    end

    def input
      if params[:webhook][:comment]
        params[:webhook][:comment][:body]
      elsif params[:webhook][:review]
        params[:webhook][:review][:body]
      elsif params[:webhook][:issue]
        params[:webhook][:issue][:body]
      else
        params[:webhook][:pull_request][:body]
      end
    end

    def issue_path
      reg_organization = %r{#{Pghub.config.github_organization}\/}
      path = params[:webhook][:issue].present? ? params[:webhook][:issue][:url] : params[:webhook][:pull_request][:issue_url]

      path.match(reg_organization).post_match
    end

    def opened_user
      if params[:webhook][:comment]
        params[:webhook][:comment][:user][:login]
      elsif params[:webhook][:review]
        params[:webhook][:review][:user][:login]
      elsif params[:webhook][:issue]
        params[:webhook][:issue][:user][:login]
      else
        params[:webhook][:pull_request][:user][:login]
      end
    end
  end
end
