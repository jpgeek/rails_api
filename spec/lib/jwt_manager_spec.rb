# frozen_string_literal: true

require "rails_helper"

RSpec.describe JwtManager do
  let(:payload) { { data: "payload data" } }
  let(:coder) { described_class }
  let(:token) { coder.encode(payload) }
  let(:decoded_token) { coder.decode(token) }
  let(:decoded_payload) { decoded_token[0] }
  let(:decoded_alg) { decoded_token[1] }

  describe ".encode" do
    it "encodes the token" do
      expect(Base64.decode64(token.split(".")[0])).to eq({ alg: "HS512" }.to_json)
      expect(Base64.decode64(token.split(".")[1]))
        .to include('"data":"payload data"')
    end

    it "uses HS512 for encoding" do
      expect(decoded_alg["alg"]).to eq("HS512")
    end
  end

  describe ".decode" do
    it "decodes the token" do
      expect(decoded_payload).to include(payload.stringify_keys)
    end

    it "has exp claim" do
      expected = Time.now.to_i + (2 * 60 * 60)
      expect(decoded_payload["exp"].to_i).to be_within(3).of(expected)
    end

    it "has nbf claim" do
      expected = Time.now.to_i - 3600
      expect(decoded_payload["nbf"].to_i).to be_within(3).of(expected)
    end

    it "has iat claim" do
      expected = Time.now.to_i
      expect(decoded_payload["iat"].to_i).to be_within(3).of(expected)
    end

    it "has jti claim" do
      expect(decoded_payload["jti"].to_i).not_to be_blank
    end
  end

  describe ".revoke" do
    before(:each) { coder.revoke(token) }
    it "handles revoke" do
      expect { coder.decode(token) }.to raise_error(JWT::RevokedToken)
    end
  end

  describe ".revoked?" do
    context "when revoked" do
      before(:each) { coder.revoke(token) }
      it "returns true" do
        expect(coder.revoked?(token)).to be_truthy
      end
    end

    context "when not revoked" do
      it "returns false" do
        expect(coder.revoked?(token)).to be_falsey
      end
    end
  end
end
