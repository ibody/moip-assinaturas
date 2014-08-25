module Moip::Assinaturas
  class Customer

    class << self

      def create(customer, new_valt = true, opts = {})
        response = Moip::Assinaturas::Client.create_customer(customer, new_valt, opts)
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

      def list(opts = {})
        response = Moip::Assinaturas::Client.list_customers(opts)
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

      def update(code, changes, opts = {})
        response = Moip::Assinaturas::Client.update_customer(code, changes, opts)
        hash     = JSON.load(response.body)
        hash     = hash ? hash.with_indifferent_access : {}

        case response.code
        when 200
          return {
            success: true
          }
        when 404
          return {
            success: false,
            message: 'not found'
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

      def details(code, opts = {})
        response = Moip::Assinaturas::Client.details_customer(code, opts)
        hash     = JSON.load(response.body)
        hash     = hash.with_indifferent_access if hash

        case response.code
        when 200
          return {
            success:   true,
            customer:  hash
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

      def update_credit_card(customer_code, credit_card, opts = {})
        response = Moip::Assinaturas::Client.update_credit_card(customer_code, credit_card, opts)
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
