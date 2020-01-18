module ApplicationHelper
  include RemoteLinkPagination

  protected

  def render_bg_img(url)
    "style=background-image:url(#{url});"
  end

  def body_bg_img
    case controller_name
      when "cocktails"
        case action_name
          when "new"
            cl_image_path('bar.jpg')
          else
            ""
        end
      else
        ""
    end
  end

  def add_css_class(cls)
    " class=\"#{cls}\""
  end

  def stringify_dose_amount(dose, full = false)
    no_unit = dose.measurement.nil?
    if no_unit
      return dose.amount
    else
      is_plural = !(['1', 'one', 'single', 'a', 'an'].include? dose.amount)
      name = is_plural ? dose.measurement.name.pluralize : dose.measurement.name
      if dose.measurement.abbrev.nil?
        display = name
      else
        display = full ? "#{name} (#{dose.measurement.abbrev})" : "#{dose.measurement.abbrev}"
      end
      "#{dose.amount} #{display}"
    end
  end

  def random_dose_color
    ['orange', 'yellow', 'olive', 'teal', 'violet', 'purple', 'pink', 'brown'].sample
  end

  def htmlify_errors(errors)
    "<div class=\"ui negative message\"><ul class=\"list\"><li>#{errors.join('</li><li>')}</li></ul></div>"
  end

end
