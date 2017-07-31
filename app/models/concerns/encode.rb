module Encode
  def generate_code
    arg = (id + created_at.to_i).to_s
    update_attributes code: Digest::MD5.hexdigest(arg)[1..8] unless code
  end
end
