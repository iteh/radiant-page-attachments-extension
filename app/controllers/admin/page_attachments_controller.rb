class Admin::PageAttachmentsController < Admin::ResourceController
  paginate_models

  def index
    collection = self.respond_to?(:current_site) ? current_site.page_attachments : PageAttachment
    @attachments = collection.all(:conditions => {:parent_id => nil}, :include => [:page], :order => 'title, filename')
  end
  
  def grid
    collection = self.respond_to?(:current_site) ? current_site.page_attachments : PageAttachment
    @attachments = collection.all(:conditions => {:parent_id => nil}, :include => [:page], :order => 'title, filename')
  end

  def generate
    collection = self.respond_to?(:current_site) ? current_site.page_attachments : PageAttachment
    collection.all(:conditions => {:parent_id => nil}).each do |attachment|
      attachment.save!
    end
    redirect_to admin_page_attachments_path
  end

  
  def update
    @page_attachment = PageAttachment.find(params[:id])
    params[:page_attachment].each do |k,v|
      @page_attachment[k] = v
    end
    @page_attachment.save!
    response_for :update
  end

end