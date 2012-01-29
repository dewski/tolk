module Tolk
  module ApplicationHelper
    def completed_percentage_link(locale)
      content_tag :li, :style => "background-position: 0 #{locale.completed_percentage}%;",
        :class => locale.phrases_completed? ? 'completed' : nil do
        link_to locale.language_name, locale_path(locale)
      end
    end
  end
end
