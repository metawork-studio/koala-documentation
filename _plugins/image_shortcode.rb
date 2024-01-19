module Jekyll
  class ImageTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
      @params = parse_params(markup)
    end

    def parse_params(markup)
      params = {}

    markup.scan(/(\w+)\s*=\s*["']([^"']*)["']/) do |key, value|
        params[key] = value
      end
      params
    end

    def render(context)
      baseurl = context['site']['baseurl']
      image_folder = "#{baseurl}/assets/images/"

      filename = @params['link'] || ''
      alt_text = @params['alt'] || ''
      css_classes = @params['class'] || ''

      if context['page']['url'].include?('tablet') && !filename.empty?
       tablet_path = "tablet/#{filename}"
        image_tag = "<a href=\"#{image_folder}#{tablet_path}\" data-fancybox=\"gallery\" class=\"fancybox\">"
        image_tag += "<img src=\"#{image_folder}#{tablet_path}\" alt=\"#{alt_text}\" class=\"#{css_classes}\" />"
        image_tag += "</a>"
      else
        css_classes = "img-phone"
        image_tag = "<a href=\"#{image_folder}#{filename}\" data-fancybox=\"gallery\" class=\"fancybox\">"
        image_tag += "<img src=\"#{image_folder}#{filename}\" alt=\"#{alt_text}\" class=\"#{css_classes}\" />"
        image_tag += "</a>"
      end

      image_tag
    end
  end
end

Liquid::Template.register_tag('flexible_image', Jekyll::ImageTag)
