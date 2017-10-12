require_dependency "pghub/base/application_controller"

module Pghub::Base
  class WebhooksController < ApplicationController
    @webhook_params = nil
    VALID_ACTIONS = %w[
      opened
      edited
      created
      edited
      review_requested
      submitted
    ]

    def create
      binding.pry
      @webhook_params = params[:webhook]

      return unless VALID_ACTIONS.include?(@webhook_params[:action])

      if defined? PgHub::Lgtm
        PgHub::Lgtm.post(issue_path) if input.include?('LGTM')
      end

      if defined? PgHub::IssueTitle
        PgHub::IssueTitle.post(issue_path, input) if input.include?('ref')
      end

      render :nothing
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
      reg_organization = %r{#{Pghub.config.github_organization}\/}
      path = @webhook_params[:issue].present? ? @webhook_params[:issue][:url] : @webhook_params[:pull_request][:issue_url]

      path.match(reg_organization).post_match
    end
  end
end
