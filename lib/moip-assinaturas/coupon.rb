module Moip::Assinaturas
  class Invoice

    class << self

      def list(opts={})
      end

      def details(id, opts={})
      end

      def create(coupon, opts={})
        response = Moip::Assinaturas::Client.create_coupon(coupon, opts)
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

      def update(coupon, opts={})
      end

      def delete(coupon, opts={})
      end
    end
  end
end
