require 'moip-assinaturas/version'
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/deprecation'

module Moip
  module Assinaturas

    autoload :Customer,     'moip-assinaturas/customer'
    autoload :Subscription, 'moip-assinaturas/subscription'
    autoload :Invoice,      'moip-assinaturas/invoice'
    autoload :Payment,      'moip-assinaturas/payment'
    autoload :Client,       'moip-assinaturas/client'

    mattr_accessor :sandbox
    @@sandbox = false

    # Token de autenticação
    mattr_accessor :token

    # Chave de acesso ao serviço
    mattr_accessor :key

    class << self
      def config
        yield self
      end
    end

  end
end
