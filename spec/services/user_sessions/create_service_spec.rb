RSpec.describe UserSessions::CreateService do
  subject { described_class }

  context 'valid parameters' do
    let(:token) { 'jwt_token' }
    before do
      create(:user, email: 'bob@example.com', password: 'givemeatoken')

      allow(JWT).to receive(:encode).and_return(token)
    end

    it 'creates a new user session' do
      expect { subject.call(email: 'bob@example.com', password: 'givemeatoken') }
        .to change { UserSession.count }.from(0).to(1)
    end

    it 'assigns user session' do
      result = subject.call(email: 'bob@example.com', password: 'givemeatoken')

      expect(result.session).to be_kind_of(UserSession)
    end
  end

  context 'invalid parameters' do
    it 'does not create user session' do
      expect { subject.call(email: 'bob@example.com', password: 'invalidpassword') }
        .not_to change { UserSession.count }
    end

    it 'adds an error' do
      result = subject.call(email: 'bob@example.com', password: 'givemeatoken')

      expect(result).to be_failure
      expect(result.errors).to include('Сессия не может быть создана')
    end
  end

  context 'invalid password' do
    let!(:user) { create(:user, email: 'bob@example.com', password: 'givemeatoken') }

    it 'does not create session' do
      expect { subject.call(email: 'bob@example.com', password: 'invalid') }
        .not_to change { UserSession.count }
    end

    it 'adds an error' do
      result = subject.call(email: 'bob@example.com', password: 'invalid')

      expect(result).to be_failure
      expect(result.errors).to include('Сессия не может быть создана')
    end
  end
end
