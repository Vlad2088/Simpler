class TestsController < Simpler::Controller
  
  def index 
    #render 'tests/list'
    #@time = Time.now
    @test = Test.all
  end

  def create
  
  end
end

