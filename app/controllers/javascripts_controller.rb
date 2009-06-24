class JavascriptsController < ApplicationController
  def pending_assets
    @id = params[:id]
    @asset_names = params[:files] || []
    respond_to do |wants|
      wants.js
    end
  end
end
