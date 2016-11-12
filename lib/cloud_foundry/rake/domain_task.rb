# frozen_string_literal: true
require 'rake/task'
require 'rake/tasklib'
require 'json'

module CloudFoundry
  module Rake
    class DomainTask < ::Rake::TaskLib
      attr_accessor :name
      attr_accessor :org_name
      attr_accessor :description
      attr_accessor :deps

      def initialize(name)
        @name = name
        @deps = []
        if @name.is_a?(Hash)
          @deps = @name.values.first
          @name = @name.keys.first
        end

        yield self if block_given?
        define
      end

      def define
        desc description
        task @name => Array(deps) do
          begin
            sh "cf create-domain #{org_name} #{name}" if needed?
          rescue
            warn "Could not create domain."
          end
        end

        self
      end

      def needed?
        needed = domains.none?{|o| o['entity']['name'] == name}
        warn "Creation of #{description} #{needed ? 'is': 'is not'} needed" if ::Rake.application.options.trace
        needed
      end

      def description
        "domain '#{name}' in org #{org_name}"
      end

      private

      def domains
        JSON.parse(`cf curl /v2/domains`)['resources'].tap do |result|
          if ::Rake.application.options.trace
            warn 'Domains:'
            warn result
          end
        end
      end
    end
  end
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
