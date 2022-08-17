require 'rails_helper'

RSpec.describe LocalJwt::Coder do
  let(:payload) { { stuff: 'more stuff' } }
  let(:coder) { described_class }
  let(:token) { coder.encode(payload) }
  let(:decoded_token) { coder.decode(token) }
  let(:decoded_payload) { decoded_token[0] }
  let(:decoded_alg) { decoded_token[1] }

  it 'encodes the token' do
    expect(Base64.decode64(token.split('.')[0])).to eq({alg: "HS512"}.to_json)
    expect(Base64.decode64(token.split('.')[1])).to eq(payload.to_json)
  end

  it 'decodes the token' do
    expect(decoded_payload).to eq(payload.stringify_keys)
  end

  it 'uses HS512 for encoding' do
    expect(decoded_alg['alg']).to eq('HS512')
  end

  it 'has iss claim' do
    expect(decoded_payload['iss']).not_to be_nil
  end

  it 'has aud claim'
  it 'has exp claim'
  it 'has nbf claim'

  it 'handles logout'
  it 'handles secure cookie based token-sidejacing prevention'
end
