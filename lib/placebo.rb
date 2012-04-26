require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/hash'
require 'active_support/inflector'
require 'httparty'
require 'hashie'

module Placebo
  mattr_accessor :name
  mattr_accessor :token

  class PlaceboResource < Hash
    include HTTParty
    include Hashie::Extensions::Coercion
    include Hashie::Extensions::MethodAccess
    include Hashie::Extensions::MergeInitializer
    include Hashie::Extensions::IndifferentAccess

    class NoParent < Exception; end

    attr_accessor :attributes

    format :xml

    def self.base_uri
      "https://#{Placebo.name}.capsulecrm.com/api"
    end

    def self.get(uri, opts = {})
      opts[:basic_auth] = {:username => Placebo.token, :password => 'x'}
      super(uri, opts)
    end

    def self.post(uri, opts = {})
      opts[:basic_auth] = {:username => Placebo.token, :password => 'x'}
      super(uri, opts)
    end

    def self.put(uri, opts = {})
      opts[:basic_auth] = {:username => Placebo.token, :password => 'x'}
      super(uri, opts)
    end

    def self.delete(uri, opts = {})
      opts[:basic_auth] = {:username => Placebo.token, :password => 'x'}
      super(uri, opts)
    end

    def self.resource_name
      self.to_s.split('::').last.downcase
    end

    def self.xml_name
      self.resource_name
    end

    def self.where(options = {})
      response = self.get(self.new.resource_path, :query => {'q' => options[:q]})

      singular_types = [resource_name] + options[:possible_resource_types]
      plural_types = singular_types.collect{|type|
        ActiveSupport::Inflector.pluralize(type)
      }

      resources = []
      plural_types.each{|collection_name|
        singular_types.each{|singular_type|
          objects = response.parsed_response[collection_name][singular_type]
          case objects
          when Array
          objects.each {|obj|
            resources << self.new(obj)
          }
          when Hash
            resources << self.new(objects)
          end
        } if response.parsed_response[collection_name]
      }

      resources
    end

    def self.find(id, options = {}) # TODO: DRY up this & .where
      response = self.get(self.new.resource_path(id))

      resource = nil
      ([resource_name] + options[:possible_resource_types]).each{|possible_type|
        attrs = response.parsed_response[possible_type]
        resource = self.new(attrs) if attrs # TODO: break out of here, we got the resource
        # TODO: raise an exception if there's multiples
      }

      resource
    end

    def resource_path(id = nil)
      [self.class.base_uri, self.class.resource_name, id].compact.join('/')
    end

    def write_path(id = nil)
      resource_path(id)
    end

    def save # TODO: refactor
      body = self.to_hash.to_xml(:root => self.class.xml_name)

      if self['id'] then
        result = self.class.put(write_path(self['id']), {
          :body => body,
          :headers => {'Content-Type' => 'text/xml'}
        })
        if result.response.is_a?(Net::HTTPOK) then
          true
        else
          result.response
        end
      else
        result = self.class.post(write_path, {
          :body => body,
          :headers => {'Content-Type' => 'text/xml'}
        })
        if result.response.is_a?(Net::HTTPCreated) then

          self.id = result.headers['location'].split('/').last # HACK HACK HACK

          true
        else
          result.response
        end
      end
    end

    def destroy
      result = self.class.delete(write_path(self['id']))
      if result.response.is_a?(Net::HTTPOK) then
        true
      else
        result.response
      end
    end

  end

end

require 'party'
