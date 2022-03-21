
module Pagination
  extend ActiveSupport::Concern

  def default_per_page
    10
  end

  def page_no
    params[:page]&.to_i || 1
  end

  def per_page
    params[:per_page]&.to_i || default_per_page
  end

  def paginate_offset
    (page_no-1)*per_page
  end

  def prev_page
    index = page_no - 1
    return request.base_url + "/posts?page=" + index.to_s + "&per_page=" + per_page.to_s
  end

  def next_page
    index = page_no + 1
    return request.base_url + "/posts?page=" + index.to_s + "&per_page=" + per_page.to_s
  end

  def show_next_page(posts)
    posts.length > paginate_offset + per_page || (page_no === 1 && posts.length > paginate_offset + per_page)
  end

  def show_prev_page(posts)
    page_no != 1 && (paginate_offset < posts.length)
  end

  def paginate
    ->(it){ it.limit(per_page).offset(paginate_offset) }
  end
end