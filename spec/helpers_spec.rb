require 'spec_helper'

describe 'Castle helpers' do
  let(:token) { 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImlhdCI6MTM5ODIzOTIwMywiZXhwIjoxMzk4MjQyODAzfQ.eyJ1c2VyX2lkIjoiZUF3djVIdGRiU2s4Yk1OWVpvanNZdW13UXlLcFhxS3IifQ.Apa7EmT5T1sOYz4Af0ERTDzcnUvSalailNJbejZ2ddQ' }

  xit 'creates a session' do
    Castle::Session.should_receive(:post).
      with("users/user%201234/sessions", user: {email: 'valid@example.com'}).
      and_return(Castle::Session.new(token: token))
    Castleauthenticate(nil, 'user 1234', properties: {email: 'valid@example.com'})
  end

  xit 'refreshes, and does not create a session' do
    Castle::Session.should_not_receive(:create)
    Castle::Session.any_instance.should_receive(:refresh).
      and_return(Castle::Session.new(token: token))
    opts = {
      user_id: '1234',
      properties: {
        email: 'valid@example.com'
      },
      context: {
        ip: '8.8.8.8',
        user_agent: 'Mozilla'
      }
    }
    Castleauthenticate(token, opts)
  end

  xit 'deauthenticates with context' do
    Castle::Session.should_receive(:destroy_existing)

    jwt = Castle::JWT.new(token)
    jwt.merge!(context: { ip: '8.8.8.8', user_agent: 'Mozilla' })

    Castledeauthenticate(jwt.to_token)
  end
end
