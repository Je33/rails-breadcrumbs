module Rails
  module Breadcrumbs

    class ActionController::Base

      protected

      def add_breadcrumb(name, url = '')
        @breadcrumbs ||= []
        url = send(url) if url.is_a?(Symbol)
        @breadcrumbs << [name, url]
      end

      def self.add_breadcrumb(name, url, options = {})
        before_filter options do |controller|
          controller.send(:add_breadcrumb, name, url)
        end
      end

    end

    module Helper

      def breadcrumbs(separator = "&rsaquo;")
        @breadcrumbs.map do |txt, path|
          link_to_unless (path.blank? || current_page?(path)), h(txt), path
        end.join(" #{separator} ").html_safe
      end

    end

  end
end

ActionController::Base.send(:include, Rails::Breadcrumbs)
ActionView::Base.send(:include, Rails::Breadcrumbs::Helper)
