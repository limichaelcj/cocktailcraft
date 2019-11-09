module ApplicationHelper

  protected

  def render_bg_img(url)
    "style=background-image:url(#{url});"
  end

  def stringify_dose_amount(dose)
    unit =  dose.measurement.name + ( dose.amount == '1' || dose.amount == 'one' ? '' : dose.measurement.plural )
    "#{dose.amount} #{unit}"
  end

end
