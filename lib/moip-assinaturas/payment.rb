module Moip::Assinaturas
  class Payment

    class << self

      def list(invoice_id)
        response = Moip::Assinaturas::Client.list_payments(invoice_id)
        hash     = JSON.load(response.body).with_indifferent_access

        case response.code
        when 200
          return {
            success:  true,
            payments: hash[:payments]
          }
        else
          raise(WebServerResponseError, "Ocorreu um erro no retorno do webservice")
        end
      end

      def details(id)
        response = Moip::Assinaturas::Client.details_payment(id)
        hash     = JSON.load(response.body).with_indifferent_access

        case response.code
        when 200
          return {
            success:  true,
            payment:  hash
          }
        else
          raise(WebServerResponseError, "Ocorreu um erro no retorno do webservice")
        end
      end

    end
  end
end