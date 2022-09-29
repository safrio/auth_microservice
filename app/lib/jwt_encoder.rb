module JwtEncoder
  extend self

  def encode(payload)
    JWT.encode(payload, ENV['SECRET'])
  end

  def decode(token)
    JWT.decode(token, ENV['SECRET']).first
  end
end
