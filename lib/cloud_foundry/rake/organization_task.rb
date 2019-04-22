# frozen_string_literal: true
require 'rake/tasklib'
require 'json'

module CloudFoundry
  module Rake
    class OrganizationTask < ::Rake::TaskLib
      attr_reader :name
      attr_reader :description
      attr_reader :deps

      def initialize(name)
        @name = name
        @deps = []
        if @name.is_a?(Hash)
          @deps = @name.values.first
          @name = @name.keys.first
        end

        yield self if block_given?
        define_task
      end

      def needed?
        organizations.none?{|o| o['entity']['name'] == name}.tap do |needed|
          warn "Creation of #{description} #{needed ? 'is': 'is not'} needed" if ::Rake.application.options.trace
        end
      end

      def description
        "Cloud Foundry organization '#{name}'"
      end

      def name=(name)
        @name = name
        define_task
      end

      private

      def define_task
        desc description
        task name => Array(deps) do
          begin
            sh "cf create-org #{name}" if needed?
          rescue
            warn "Could not create organization #{name}."
          end
        end

        self
      end

      def organizations
        JSON.parse(`cf curl /v2/organizations`)['resources'].tap do |result|
          if ::Rake.application.options.trace
            warn 'Organizations:'
            warn JSON.pretty_generate(result)
          end
        end
      end
    end
  end
end
