class UserRoutes < Application
  helpers PaginationLinks

  # before do
  #   if request.request_method == 'POST'
  #     body_parameters = request.body.read
  #     params.merge!(JSON.parse(body_parameters))
  #   end
  # end

  namespace '/v1' do
    post '/login' do
      content_type :json
      login_params = validate_with!(LoginParamsContract).to_h
      result = UserSessions::CreateService.call(login_params)

      if result.success?
        token = JwtEncoder.encode(uuid: result.session.uuid)
        meta = { token: token }

        status 201
        json(meta: meta)
      else
        status 422
        error_response result.errors
      end
    end

    post '/signup' do
      content_type :json
      user_params = validate_with!(SignupParamsContract).to_h
      result = Users::CreateService.call(user_params)

      if result.success?
        status 201
      else
        status 422
        error_response result.user
      end
    end
  end
end
