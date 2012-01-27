module Tolk
  class PhrasesController < ApplicationController
    respond_to :json, :only => :translate
    
    def translate
      render :json => {
        :text => current_phrase.key.translate(Tolk.locale, :from => Tolk.default_locale)
      }
    end
    
    private
    
    def current_phrase
      @current_phrase ||= Tolk::Phrase.find(params[:id])
    end
  end
end
