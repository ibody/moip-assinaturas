module Moip::Assinaturas
  class Subscription

    class << self

      def create(subscription, new_customer = false)
        response = Moip::Assinaturas::Client.create_subscription(subscription, new_customer)
        hash     = JSON.load(response.body).with_indifferent_access

        case response.code
        when 201
          return {
            success: true,
            subscription: hash
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

      def list
        response = Moip::Assinaturas::Client.list_subscriptions
        hash     = JSON.load(response.body).with_indifferent_access

        case response.code
        when 200
          return {
            success: true,
            subscriptions: hash[:subscriptions]
          }
        else
          raise(WebServerResponseError, "Ocorreu um erro no retorno do webservice")
        end

      end

      def details(code)
        response = Moip::Assinaturas::Client.details_subscription(code)
        hash     = JSON.load(response.body).with_indifferent_access

        case response.code
        when 200
          return {
            success: true,
            subscription: hash
          }
        else
          raise(WebServerResponseError, "Ocorreu um erro no retorno do webservice")
        end      
      end

      def suspend(code)
        response = Moip::Assinaturas::Client.suspend_subscription(code)

        case response.code
        when 200
          return { success: true }
        else
          raise(WebServerResponseError, "Ocorreu um erro no retorno do webservice")
        end
      end

      def activate(code)
        response = Moip::Assinaturas::Client.activate_subscription(code)

        case response.code
        when 200
          return { success: true }
        else
          raise(WebServerResponseError, "Ocorreu um erro no retorno do webservice")
        end
      end

    end

  end
end