class LoginParamsContract < Dry::Validation::Contract
  params do
    required(:email).value(:string)
    required(:password).value(:string)
  end
end
