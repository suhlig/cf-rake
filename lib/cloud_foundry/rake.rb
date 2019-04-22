# frozen_string_literal: true
require 'cloud_foundry/rake/domain_task'
require 'cloud_foundry/rake/organization_task'

module CloudFoundry
  module Rake
    def organization(name)
      task = CloudFoundry::Rake::OrganizationTask.new(name)
      yield task if block_given?
    end

    def domain(name, org_and_deps)
      deps = []
      org = nil

      if org_and_deps.is_a?(Hash)
        deps = org_and_deps.values.first
        org = org_and_deps.keys.first
      else
        org = org_and_deps
      end

      task = CloudFoundry::Rake::DomainTask.new({name => deps}) do |t|
        t.org_name = org
      end

      yield task if block_given?
    end
  end
end

# Make the DSL globally available
self.extend CloudFoundry::Rake
