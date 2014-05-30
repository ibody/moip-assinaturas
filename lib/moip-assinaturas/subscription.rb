module Moip::Assinaturas
  class Subscription

    class << self

      def create(subscription, new_customer = false, opts={})
        response = Moip::Assinaturas::Client.create_subscription(subscription, new_customer, opts)
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

      def update(subscription_code, subscription_changes, opts = {})
        response = Moip::Assinaturas::Client.update_subscription(subscription_code, subscription_changes, opts)
        hash     = JSON.load(response.body)
        hash     = hash ? hash.with_indifferent_access : {}

        case response.code
        when 200
          return {
            success: true
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


      def list(opts={})
        response = Moip::Assinaturas::Client.list_subscriptions(opts)
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

      def details(code, opts={})
        response = Moip::Assinaturas::Client.details_subscription(code, opts)
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

      def suspend(code, opts={})
        response = Moip::Assinaturas::Client.suspend_subscription(code, opts)
        hash     = JSON.load(response.body)
        hash     = hash ? hash.with_indifferent_access : {}

        case response.code
        when 200
          return { success: true }
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

      def activate(code, opts={})
        response = Moip::Assinaturas::Client.activate_subscription(code, opts)
        hash     = JSON.load(response.body)
        hash     = hash ? hash.with_indifferent_access : {}

        case response.code
        when 200
          return { success: true }
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

      def cancel(code, opts={})
        response = Moip::Assinaturas::Client.cancel_subscription(code, opts)
        hash     = JSON.load(response.body)
        hash     = hash ? hash.with_indifferent_access : {}

        case response.code
        when 200
          return { success: true }
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