module ApplicationHelper

  protected

  def render_bg_img(url)
    "style=background-image:url(#{url});"
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

end
