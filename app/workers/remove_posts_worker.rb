class RemovePostsWorker
  include Sidekiq::Worker

  def perform()
    # Do something
    Post.where('created_at <= :twenty_four_hours', twenty_four_hours: Time.now - 24.hours).destroy_all
    p (Post.all)
  end
end
