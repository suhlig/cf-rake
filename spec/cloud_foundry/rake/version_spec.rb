# frozen_string_literal: true
require 'spec_helper'

describe CloudFoundry::Rake do
  it 'has a version number' do
    expect(CloudFoundry::Rake::VERSION).not_to be nil
  end
end
