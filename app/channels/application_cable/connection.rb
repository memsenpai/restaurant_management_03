module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected

    def find_verified_user
      current_user ||=
        Staff.find_by id: cookies.signed[:staff_id]
      reject_unauthorized_connection unless current_user
    end
  end
end
