# frozen_string_literal: true

require 'spec_helper'

module SocialWeb
  RSpec.describe ActivityPub do
    describe '.process' do
      %i[inbox outbox].each do |collection|
        it "stores, dereferences, and forwards to #{collection}" do
          actor = create :object
          activity = build :object

          stubbed_collection = instance_double(SocialWeb::ActivityPub["collections.#{collection}"])

          expect(SocialWeb::ActivityPub["collections.#{collection}"]).
            to receive(:for_actor).
            with(actor).
            and_return(stubbed_collection)
          expect(SocialWeb::ActivityPub['repositories.objects']).
            to receive(:store).
            with(activity)

          dereferencer = instance_double(SocialWeb::ActivityPub['services.dereference'])
          expect(SocialWeb::ActivityPub['services.dereference']).
            to receive(:for_actor).
            with(actor).
            and_return(dereferencer)
          expect(dereferencer).
            to receive(:call).
            with(activity).
            and_return(activity.dup)

          expect(stubbed_collection).to receive(:process).with(activity)

          described_class.process(activity.to_json, actor[:id], collection)
        end
      end
    end
  end
end