# frozen_string_literal: true
require 'rake/tasklib'
require 'json'

module CloudFoundry
  module Rake
    class DomainTask < ::Rake::TaskLib
      attr_reader :name
      attr_reader :org_name
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

      def name=(name)
        @name = name
        define_task
      end

      def org_name=(name)
        @org_name = name
        define_task
      end

      def needed?
        domains.none?{|o| o['entity']['name'] == name}.tap do |needed|
          warn "Creation of #{description} #{needed ? 'is': 'is not'} needed" if ::Rake.application.options.trace
        end
      end

      def description
        "Cloud Foundry domain '#{name}' in org #{org_name}"
      end

      private

      def define_task
        desc description
        task name => Array(deps) do
          begin
            sh "cf create-domain #{org_name} #{name}" if needed?
          rescue
            warn "Could not create domain #{name} for org #{org_name}."
          end
        end

        self
      end

      def domains
        JSON.parse(`cf curl /v2/domains`)['resources'].tap do |result|
          if ::Rake.application.options.trace
            warn 'Domains:'
            warn JSON.pretty_generate(result)
          end
        end
      end
    end
  end
end
