require_dependency 'application_controller'

class PageAttachmentsExtension < Radiant::Extension
  version "#{File.read(File.expand_path(File.dirname(__FILE__)) + '/VERSION')}"
  description "Adds page-attachment-style asset management."
  url "http://radiantcms.org"

  def activate
    if self.respond_to?(:tab)
      tab "Content" do
        add_item I18n.t('page_attachments.menuitem'), "/admin/page_attachments"
      end
    else
      admin.tabs.add I18n.t('page_attachments.menuitem'), '/admin/page_attachments', :after => "Layouts", :visibility => [:admin]
    end
    Page.class_eval do
      include PageAttachmentAssociations
      include PageAttachmentTags
    end
    UserActionObserver.instance.send :add_observer!, PageAttachment
    Admin::PagesController.class_eval { helper Admin::PageAttachmentsHelper }
    admin.page.edit.add :form_bottom, 'attachments_box', :before => 'edit_buttons'
  end

  def deactivate
  end

end
