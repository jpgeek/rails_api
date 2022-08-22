# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserPolicy, type: :policy do
  let(:admin_user) { create(:admin_user) }
  let(:plain_user) { create(:user) }
  subject { described_class.new(user, target) }

  include Support::PunditHelper

  context "as plain user" do
    let(:user) { plain_user }

    context "accessing self" do
      let(:target) { plain_user }

      it { is_expected.to forbid_action(:index) }
      it { is_expected.to permit_action(:show) }
      it { is_expected.to permit_action(:create) }
      it { is_expected.to permit_action(:new) }
      it { is_expected.to permit_action(:edit) }
      it { is_expected.to permit_action(:update) }
      it { is_expected.to forbid_action(:destroy) }
    end

    context "accessing other" do
      let(:target) { admin_user }

      it { is_expected.to forbid_action(:index) }
      it { is_expected.to forbid_action(:show) }
      it { is_expected.to permit_action(:create) }
      it { is_expected.to permit_action(:new) }
      it { is_expected.to forbid_action(:edit) }
      it { is_expected.to forbid_action(:update) }
      it { is_expected.to forbid_action(:destroy) }
    end
  end

  context "as admin user" do
    let(:user) { admin_user }

    context "accessing self" do
      let(:target) { admin_user }

      it { is_expected.to permit_action(:index) }
      it { is_expected.to permit_action(:show) }
      it { is_expected.to permit_action(:create) }
      it { is_expected.to permit_action(:new) }
      it { is_expected.to permit_action(:edit) }
      it { is_expected.to permit_action(:update) }
      it { is_expected.to forbid_action(:destroy) }
    end

    context "accessing other" do
      let(:target) { plain_user }

      it { is_expected.to permit_action(:index) }
      it { is_expected.to permit_action(:show) }
      it { is_expected.to permit_action(:create) }
      it { is_expected.to permit_action(:new) }
      it { is_expected.to permit_action(:edit) }
      it { is_expected.to permit_action(:update) }
      it { is_expected.to forbid_action(:destroy) }
    end
  end

  context "when not logged in" do
    let(:user) { nil }

    context "accessing a user" do
      let(:target) { plain_user }

      it { is_expected.to raise_not_authorized(:index) }
      it { is_expected.to raise_not_authorized(:show) }
      it { is_expected.to permit_action(:create) }
      it { is_expected.to permit_action(:new) }
      it { is_expected.to raise_not_authorized(:edit) }
      it { is_expected.to raise_not_authorized(:update) }
      it { is_expected.to raise_not_authorized(:destroy) }
    end
  end


  # unauthorized check
  # let(:target) { create(:user) }
  # methods = %i[index? show? edit? update? destroy?]
  # it_behaves_like 'it raises NotAuthorizeError when not logged in', methods

  describe ".scope" do
    let(:target_class) { model_from_policy(described_class) }
    let(:scope) { described_class::Scope.new(user, target_class).resolve }
    context "for plain user" do
      let!(:user) { plain_user }
      let!(:other) { admin_user }

      it "includes the user" do
        expect(scope).to include(user)
      end

      it "does not include other users" do
        expect(scope).not_to include(other)
      end
    end

    context "for admin user" do
      let!(:user) { admin_user }
      let!(:other) { plain_user }

      it "includes the user" do
        expect(scope).to include(user)
      end

      it "includes other users" do
        expect(scope).to include(other)
      end
    end
  end
end
