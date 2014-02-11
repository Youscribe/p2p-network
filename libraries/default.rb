require 'digest/md5'

def interface_name(hostname)
  limit = 15 # iptable avoid interface > 15 characters
  if "tun_#{hostname}".length <= limit
    return "tun_#{hostname}"
  else
    return "tun_" + hostname[0..5] + Digest::MD5.hexdigest(hostname)[0, limit - 11]
  end
end
