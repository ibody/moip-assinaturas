module Moip::Assinaturas
  class Customer

    class << self

      def create(customer, new_valt = true)
        response = Moip::Assinaturas::Client.create_customer(customer, new_valt)

        case response.code
        when 201
          hash = JSON.load(response.body).with_indifferent_access
          return {
            success: true,
            message: hash['message']
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
        response = Moip::Assinaturas::Client.list_customers

        case response.code
        when 200
          hash = JSON.load(response.body).with_indifferent_access
          return {
            success:    true,
            customers:  hash['customers']
          }
        else
          raise(WebServerResponseError, "Ocorreu um erro no retorno do webservice")
        end
      end

      def details(code)
        response = Moip::Assinaturas::Client.details_customer(code)

        case response.code
        when 200
          hash = JSON.load(response.body).with_indifferent_access
          return {
            success:   true,
            customer:  hash
          }
        else
          raise(WebServerResponseError, "Ocorreu um erro no retorno do webservice")
        end
      end

    end
  end
end