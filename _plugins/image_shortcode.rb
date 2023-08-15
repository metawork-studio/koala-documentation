# module Jekyll
#   class ImageTag < Liquid::Tag
#     def initialize(tag_name, markup, tokens)
#       super
#       @markup = markup.strip
#     end
#
#         def render(context)
#           baseurl = context['site']['baseurl']
#           image_folder = "#{baseurl}/assets/images"
#
#             filename, alt_text, css_classes = parse_markup(context)
#
#           if context['page']['url'].include?('tablet')
#             generate_tablet_images(image_folder, filename, alt_text, css_classes)
#           else
#             generate_default_image(image_folder, filename, alt_text, css_classes)
#           end
#         end
#
#    def parse_markup(context)
#       # Extract the filename, alt text, and class attributes from the markup
#       params = @markup.split(' ')
#
#       filename = params[0]
#       alt_text = params[1..]&.join(' ')
#       css_classes = params[2..]&.join(' ')
#
#       [filename, alt_text, css_classes]
#     end
#
#     def generate_tablet_images(folder, filename, alt_text, css_classes)
#     tablet_path = filename.sub(%r{\/(\d+)\/}, '/\1/tablet/')
#     p tablet_path
#     image_tag = "<a href=\"#{folder}#{tablet_path}\" data-fancybox=\"gallery\" class=\"fancybox\">"
#     image_tag += "<img src=\"#{folder}#{tablet_path}\" alt=\"#{alt_text}\" class=\"#{css_classes}\" />"
#     image_tag += "</a>"
#
#     image_tag
#     end
#
#     def generate_default_image(folder, filename, alt_text, css_classes)
#     image_tag = "<a href=\"#{folder}#{filename}\" data-fancybox=\"gallery\" class=\"fancybox\">"
#     image_tag += "<img src=\"#{folder}#{filename}\" alt=\"#{alt_text}\" class=\"#{css_classes}\" />"
#     image_tag += "</a>"
#
#     image_tag
#     end
#   end
# end
#
# Liquid::Template.register_tag('flexible_image', Jekyll::ImageTag)

# Shortcode - {% flexible_image link="/2/IMG_8148.png" alt="Alt text" class="img-class" %}

module Jekyll
  class ImageTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
      @params = parse_params(markup)
    end

    def parse_params(markup)
      params = {}
#       markup.scan(/(\w+)\s*=\s*["']([^"']+)["']/) do |key, value|
 markup.scan(/(\w+)\s*=\s*["']([^"']*)["']/) do |key, value|
        params[key] = value
      end
      params
    end

    def render(context)
      baseurl = context['site']['baseurl']
      image_folder = "#{baseurl}/assets/images"

      filename = @params['link'] || ''
      alt_text = @params['alt'] || ''
      css_classes = @params['class'] || ''

      if context['page']['url'].include?('tablet') && !filename.empty?
       tablet_path = filename.sub(%r{\/(\d+)\/}, '/\1/tablet/')
        image_tag = "<a href=\"#{image_folder}#{tablet_path}\" data-fancybox=\"gallery\" class=\"fancybox\">"
        image_tag += "<img src=\"#{image_folder}#{tablet_path}\" alt=\"#{alt_text}\" class=\"#{css_classes}\" />"
        image_tag += "</a>"
      else
        image_tag = "<a href=\"#{image_folder}#{filename}\" data-fancybox=\"gallery\" class=\"fancybox\">"
        image_tag += "<img src=\"#{image_folder}#{filename}\" alt=\"#{alt_text}\" class=\"#{css_classes}\" />"
        image_tag += "</a>"
      end

      image_tag
    end
  end
end

Liquid::Template.register_tag('flexible_image', Jekyll::ImageTag)
