module Encode
  def generate_code
    arg = id.to_s + created_at.to_s
    update_attributes code: Digest::MD5.base64digest(arg)[1..20] unless code
  end
end
