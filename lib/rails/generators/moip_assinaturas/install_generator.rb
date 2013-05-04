module MoipAssinaturas
  module Generators

    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)
      desc "Creates a Moip Assinaturas initializer"

      def copy_initializer
        template 'moip_assinaturas.rb', 'config/initializers/moip_assinaturas.rb'
      end
    end

  end
end