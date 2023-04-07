module ApplicationHelper # В папке helpers помещаются хелперы это типо вспомогательных функций в RoR(по типу link_to, form_with)
  include Pagy::Frontend #улучшеная альтернатива kaminari, мы импортируем методы для фронта


  def full_title(page_title = "")
    base_title = "AskIt"
    if page_title.present? # функция present(установлена)?
      "#{page_title} | #{base_title}" # если переменная page_title установлена, то выводим название название страницы
    else
      base_title # Иначе же просто название страницы
    end
  end

  def currently_at(current_page = '') #это хелпер который поможет выводит на экран то что нужно и как нужно
    render partial: 'shared/menu', locals: {current_page: current_page} # рендерим именно паршал если просто написать рендер программа выведет еще и макет 
  end

  def nav_tab(title, url, options = {}) #аналог link_to от Ильи Круковского!!!
    current_page = options.delete :current_page

    css_class = current_page == title ? 'text-secondary' : 'text-white'  #тернарный оператор

    options[:class] = if options[:class]
                        options[:class] + ' ' + css_class
                      else
                        css_class
                      end
    link_to title, url, options
  end
end
