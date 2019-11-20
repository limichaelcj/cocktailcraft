module RemoteLinkPagination
  class LinkRenderer < WillPaginate::ActionView::LinkRenderer

    # make link remote for ajax calls
    def link(text, target, attributes = {})
      attributes['data-remote'] = true
      super
    end

    def html_container(html)
      container_attributes[:class] = "ui pagination menu"
      tag(:div, html, container_attributes)
    end

    def page_number(page)
      aria_label = @template.will_paginate_translate(:page_aria_label, :page => page.to_i) { "Page #{page}" }
      if page == current_page
        tag(:em, page, :class => 'active item', :"aria-label" => aria_label, :"aria-current" => 'page')
      else
        link(page, page, :class => 'item', :rel => rel_value(page), :"aria-label" => aria_label)
      end
    end

    def previous_or_next_page(page, text, classname)
      if page
        link(text, page, :class => classname + " item")
      else
        tag(:span, text, :class => classname + ' disabled item')
      end
    end

    private



  end
end
