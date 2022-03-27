# frozen_string_literal: true

module Api::Qdc
  class Qr::ReflectionsController < ApiController
    before_action :init_presenter

    def index
      render
    end

    def show
      render
    end

    def report
      @issue = ::Qr::ReportedIssue.new(report_params)

      if @issue.save
        render status: :created
      else
        render status: :unprocessable_entity
      end
    end

    def verses
      render
    end

    protected

    def init_presenter
      params[:verified] = true if params[:verified].nil?

      @presenter = ::Qr::ReflectionsPresenter.new(params)
    end

    def report_params
      params.require(:report).permit(
        :comment_id,
        :body,
        :name,
        :email
      ).merge(post_id: params[:post_id])
    end
  end
end
