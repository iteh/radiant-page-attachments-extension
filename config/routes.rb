ActionController::Routing::Routes.draw do |map|
    map.namespace :admin do |admin|
      admin.resources :page_attachments
      admin.page_attachments_grid '/page_attachments_grid', :controller => 'page_attachments', :action => 'grid'
      admin.page_attachments_generate '/page_attachments_generate', :controller => 'page_attachments', :action => 'generate'
    end
end