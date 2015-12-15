module Moip::Assinaturas
  class Plan

    class << self

      def create(plan, opts={})
        response = Moip::Assinaturas::Client.create_plan(plan, opts)
        hash     = JSON.load(response.body).with_indifferent_access

        case response.code
        when 201
          return {
            success: true,
            plan:    hash
          }
        when 400
          return {
            success: false,
            message: hash['message'],
            errors:  hash['errors']
          }
        else
          raise(WebServerResponseError, "Ocorreu um erro no retorno do webservice")
        end
      end

      def list(opts={})
        response = Moip::Assinaturas::Client.list_plans(opts)
        hash     = JSON.load(response.body).with_indifferent_access

        case response.code
        when 200
          return {
            success:  true,
            plans:    hash[:plans]
          }
        else
          raise(WebServerResponseError, "Ocorreu um erro no retorno do webservice")
        end
      end

      def details(code, opts={})
        response = Moip::Assinaturas::Client.details_plan(code, opts)
        hash     = JSON.load(response.body)
        hash     = hash.with_indifferent_access if hash

        case response.code
        when 200
          return {
            success:  true,
            plan:     hash
          }
        when 404
          return {
            success: false,
            message: 'not found'
          }
        else
          raise(WebServerResponseError, "Ocorreu um erro no retorno do webservice")
        end
      end

      def update(plan, opts={})
        response = Moip::Assinaturas::Client.update_plan(plan, opts)
        hash     = JSON.load(response.body) if response.body

        case response.code
        when 200
          return {
            success: true
          }
        when 400
          return {
            success: false
            plan: hash
          }
        else
          raise(WebServerResponseError, "Ocorreu um erro no retorno do webservice")
        end
      end

    end
  end
end
