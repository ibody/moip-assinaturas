module Moip::Assinaturas
  class Invoice

    class << self

      def list(subscription_code)
        response = Moip::Assinaturas::Client.list_invoices(subscription_code)

        case response.code
        when 200
          hash = JSON.load(response.body).with_indifferent_access
          return {
            success:  true,
            invoices: hash[:invoices]
          }
        else
          raise(WebServerResponseError, "Ocorreu um erro no retorno do webservice")
        end
      end

      def details(id)
        response = Moip::Assinaturas::Client.details_invoice(id)

        case response.code
        when 200
          hash = JSON.load(response.body).with_indifferent_access
          return {
            success:  true,
            invoice:  hash
          }
        else
          raise(WebServerResponseError, "Ocorreu um erro no retorno do webservice")
        end
      end

    end
  end
end