module Moip::Assinaturas
  class Coupon

    class << self

      def list(opts={})
        response = Moip::Assinaturas::Client.list_coupon(opts)
        array     = JSON.load(response.body)

        case response.code
        when 200
          return {
            success:  true,
            coupons:  array
          }
        else
          raise(WebServerResponseError, "Ocorreu um erro no retorno do webservice")
        end
      end

      def details(code, opts={})
        response = Moip::Assinaturas::Client.details_coupon(code,opts)
        hash     = JSON.load(response.body).with_indifferent_access

        case response.code
        when 200
          return {
            success: true,
            coupon:    hash
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

      def create(coupon, opts={})
        response = Moip::Assinaturas::Client.create_coupon(coupon, opts)
        hash     = JSON.load(response.body).with_indifferent_access

        case response.code
        when 201
          return {
            success: true,
            coupon:    hash
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

      def active(code)
        response = Moip::Assinaturas::Client.active_coupon(code)
        hash     = JSON.load(response.body).with_indifferent_access

        case response.code
        when 200
          return {
            success: true,
            coupon:    hash
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

      def inactive(code)
        response = Moip::Assinaturas::Client.inactive_coupon(code)
        hash     = JSON.load(response.body).with_indifferent_access

        case response.code
        when 200
          return {
            success: true,
            coupon:    hash
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

      def delete(coupon, opts={})
      end
    end
  end
end
