module Tolk
  class LocalesController < ApplicationController
    before_filter :find_locale, :only => [:show, :all, :update, :updated]
    respond_to :json, :only => :update
    
    def index
      @phrases = current_locale.phrases
    end
  
    def show
      @phrases = Tolk::Phrase.localized
      render :index
    end

    def update
      # TODO: Add check for key
      @phrase = Tolk::Phrase.find(params[:phrase][:key])
      if @phrase.update_attributes(params[:phrase])
        render :nothing => true
      else
        render :json => { :status => 404, :message => 'Couldnt find key' }
      end
    end
    
    def missing
      @phrases = current_locale.missing_phrases
    end

    def updated
      @phrases = @locale.phrases_with_updated_translation(params[:page])
      render :all
    end

    def create
      Tolk::Locale.create!(params[:tolk_locale])
      redirect_to :action => :index
    end

    private

    def find_locale
      @locale = Tolk::Locale.find!(params[:id])
    end
  end
end
