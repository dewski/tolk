module Tolk
  class SearchesController < ApplicationController
    before_filter :find_locale
  
    def show
      @phrases = @locale.search_phrases(params[:q], params[:scope].to_sym, params[:page])
    end

    private

    def find_locale
      @locale = Tolk::Locale.find!(params[:locale])
    end
  end
end
