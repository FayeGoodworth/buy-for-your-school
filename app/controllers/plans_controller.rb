# frozen_string_literal: true

class PlansController < ApplicationController
  def new
    plan = Plan.create(category: "catering")
    redirect_to new_plan_question_path(plan)
  end

  def show
    @plan = Plan.find(plan_id)
  end

  private

  def plan_id
    params[:id]
  end
end