RSpec.describe UserRoutes, type: :routes do
  describe 'POST /v1/signup' do
    context 'missing parameters' do
      it 'returns an error' do
        post '/v1/signup'

        expect(last_response.status).to eq(422)
      end
    end

    context 'invalid parameters' do
      it 'returns an error' do
        post '/v1/signup', name: 'b.o.b', email: 'bob@example.com', password: 'givemeatoken'

        expect(last_response.status).to eq(422)
        expect(response_body['errors']).to include(
          {
            'detail' => 'Укажите имя, используя буквы, цифры или символ подчёркивания',
            'source' => {
              'pointer' => '/data/attributes/name'
            }
          }
        )
      end
    end

    context 'valid parameters' do
      let(:signup_params) do
        {
          name: 'Name',
          email: 'name@email.com',
          password: '123'
        }
      end

      let(:last_user) { User.last }

      it 'creates a new user' do
        expect { post '/v1/signup', signup_params }
          .to change { User.count }.from(0).to(1)

        expect(last_response.status).to eq(201)
      end
    end
  end

  describe 'POST /v1/login' do
    context 'missing parameters' do
      it 'returns an error' do
        post '/v1/login'

        expect(last_response.status).to eq(422)
      end
    end

    context 'invalid parameters' do
      it 'returns an error' do
        post '/v1/login', email: 'bob@example.com', password: 'invalidpassword'

        expect(last_response.status).to eq(422)
        expect(response_body['errors']).to include('detail' => 'Сессия не может быть создана')
      end
    end

    context 'valid parameters' do
      let(:token) { 'jwt_token' }
      before do
        create(:user, email: 'bob@example.com', password: 'givemeatoken')

        allow(JWT).to receive(:encode).and_return(token)
      end

      it 'returns created status' do
        post '/v1/login', email: 'bob@example.com', password: 'givemeatoken'

        expect(last_response.status).to eq(201)
        expect(response_body['meta']).to eq('token' => token)
      end
    end
  end
end
