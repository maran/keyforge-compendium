require 'sidekiq/api'
class SqService
  def c_q
    Sidekiq::Queue.new.clear
  end

  def q_s
    Sidekiq::Queue.new.size
  end

  def q
    Sidekiq::Queue.new
  end

  def r
    Sidekiq::RetrySet.new
  end
end
