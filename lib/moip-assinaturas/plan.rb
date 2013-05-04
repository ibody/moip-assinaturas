module Moip::Assinaturas
  class Plan

    class << self

      def create(plan)
        response = Moip::Assinaturas::Client.create_plan(plan)

        case response.code
        when 201
          hash = JSON.load(response.body).with_indifferent_access
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

      def list
        response = Moip::Assinaturas::Client.list_plans

        case response.code
        when 200
          hash = JSON.load(response.body).with_indifferent_access
          return {
            success:  true,
            plans:    hash[:plans]
          }
        else
          raise(WebServerResponseError, "Ocorreu um erro no retorno do webservice")
        end
      end

      def details(code)
        response = Moip::Assinaturas::Client.details_plan(code)

        case response.code
        when 200
          hash = JSON.load(response.body).with_indifferent_access
          return {
            success:  true,
            plan:     hash
          }
        else
          raise(WebServerResponseError, "Ocorreu um erro no retorno do webservice")
        end
      end

    end
  end
end