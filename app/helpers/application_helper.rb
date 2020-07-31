module ApplicationHelper
  # Returns the full title on a per-page basic.
  def full_title page_title = "", base_title = ""
    if page_title.blank?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
