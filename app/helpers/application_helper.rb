module ApplicationHelper

  protected

  def render_bg_img(url)
    "style=background-image:url(#{url});"
  end

  def stringify_dose_amount(dose)
    no_unit = dose.measurement.nil?
    if no_unit
      return dose.amount
    else
      plural = !(['1', 'one', 'single', 'a', 'an'].include? dose.amount)
      unit = dose.measurement.abbrev || (plural ? dose.measurement.name.pluralize : dose.measurement.name)
      "#{dose.amount} #{unit}"
    end
  end

  def random_dose_color
    ['orange', 'yellow', 'olive', 'teal', 'violet', 'purple', 'pink', 'brown'].sample
  end

end
