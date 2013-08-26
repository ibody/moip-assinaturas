module Moip::Assinaturas
  class Customer

    class << self

      def create(customer, new_valt = true)
        response = Moip::Assinaturas::Client.create_customer(customer, new_valt)
        hash     = JSON.load(response.body).with_indifferent_access

        case response.code
        when 201
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
        hash     = JSON.load(response.body).with_indifferent_access

        case response.code
        when 200
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
        hash     = JSON.load(response.body).with_indifferent_access

        case response.code
        when 200
          return {
            success:   true,
            customer:  hash
          }
        else
          raise(WebServerResponseError, "Ocorreu um erro no retorno do webservice")
        end
      end

      def update_credit_card(customer_code, credit_card)
        response = Moip::Assinaturas::Client.update_credit_card(customer_code, credit_card)
        hash     = JSON.load(response.body).with_indifferent_access

        case response.code
        when 200
          return {
            success: true,
            message: hash[:message]
          }
        when 400
          return {
            success: false,
            message: hash[:message],
            errors:  hash[:errors]
          }
        else
          raise(WebServerResponseError, "Ocorreu um erro no retorno do webservice")
        end

      end

    end
  end
end