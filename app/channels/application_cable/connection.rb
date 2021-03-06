# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    def session
      @request.session
    end
  end
end
