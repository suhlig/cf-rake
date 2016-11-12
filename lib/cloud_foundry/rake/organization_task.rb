# frozen_string_literal: true
require 'rake/task'
require 'rake/tasklib'
require 'json'

module CloudFoundry
  module Rake
    class OrganizationTask < ::Rake::TaskLib
      attr_accessor :name
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
            sh "cf create-org #{name}" if needed?
          rescue
            warn "Could not create organization."
          end
        end

        self
      end

      def needed?
        needed = organizations.none?{|o| o['entity']['name'] == name}
        warn "Creation of #{description} #{needed ? 'is': 'is not'} needed" if ::Rake.application.options.trace
        needed
      end

      def description
        "organization '#{name}'"
      end

      private

      def organizations
        JSON.parse(`cf curl /v2/organizations`)['resources'].tap do |result|
          if ::Rake.application.options.trace
            warn 'Organizations:'
            warn result
          end
        end
      end
    end
  end
end

def organization(name)
  task = CloudFoundry::Rake::OrganizationTask.new(name)
  yield task if block_given?
end
