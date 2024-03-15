# frozen_string_literal: true

class TestsController < Simpler::Controller
  def index
    render plain: 'Plain text response'
    status(201)
    headers['Content-Type'] = 'text/plain'
  end

  def create; end

  def show
    @test_id = params[:id]
  end
end
