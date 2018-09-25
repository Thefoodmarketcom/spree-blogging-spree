module Spree
  class BlogEntryImage < Asset
    module Configuration
      module Paperclip
        extend ActiveSupport::Concern

        included do
          def self.styles
            attachment_definitions[:attachment][:styles]
          end

          delegate :url, to: :attachment

          has_attached_file :attachment,
                            styles: { mini: '48x48>', normal: '200x200>', large: '600x600>' },
                            default_style: :large,
                            url: '/assets/blog_entry_images/:viewable_id/:style/:basename.:extension',
                            path: ':rails_root/public/assets/blog_entry_images/:viewable_id/:style/:basename.:extension'

          validates_attachment :attachment,
                               content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] }
        end
      end
    end
  end
end
