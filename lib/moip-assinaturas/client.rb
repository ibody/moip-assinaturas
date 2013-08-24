# coding: utf-8

require 'httparty'
require 'json'

module Moip::Assinaturas

  class WebServerResponseError < StandardError ; end
  class MissingTokenError < StandardError ; end

  class Client
    include HTTParty

    if Moip::Assinaturas.sandbox
      base_uri "https://sandbox.moip.com.br/assinaturas/v1"
    else
      base_uri "https://api.moip.com.br/assinaturas/v1"
    end

    basic_auth Moip::Assinaturas.token, Moip::Assinaturas.key

    class << self

      def create_plan(plan)
        peform_action!(:post, "/plans", { body: plan.to_json, headers: { 'Content-Type' => 'application/json' } })
      end

      def list_plans
        peform_action!(:get, "/plans", { headers: { 'Content-Type' => 'application/json' } })
      end

      def details_plan(code)
        peform_action!(:get, "/plans/#{code}", { headers: { 'Content-Type' => 'application/json' } })
      end

      def create_customer(customer, new_vault)
        peform_action!(:post, "/customers?new_vault=#{new_vault}", { body: customer.to_json, headers: { 'Content-Type' => 'application/json' } })
      end

      def update_customer(code, customer)
        peform_action!(:put, "/customers/#{code}", { body: customer.to_json, headers: { 'Content-Type' => 'application/json' } })
      end

      def update_billing_info(code, billing_info)
        peform_action!(:put, "/customers/#{code}/billing_infos", { body: billing_info.to_json, headers: { 'Content-Type' => 'application/json' } })
      end

      def list_customers
        peform_action!(:get, "/customers", { headers: { 'Content-Type' => 'application/json' } })
      end

      def details_customer(code)
        peform_action!(:get, "/customers/#{code}", { headers: { 'Content-Type' => 'application/json' } })
      end

      def create_subscription(subscription, new_customer)
        peform_action!(:post, "/subscriptions?new_customer=#{new_customer}", { body: subscription.to_json, headers: { 'Content-Type' => 'application/json' } })
      end

      def list_subscriptions
        peform_action!(:get, "/subscriptions", { headers: { 'Content-Type' => 'application/json' } })
      end

      def details_subscription(code)
        peform_action!(:get, "/subscriptions/#{code}", { headers: { 'Content-Type' => 'application/json' } })
      end

      def suspend_subscription(code)
        peform_action!(:put, "/subscriptions/#{code}/suspend", { headers: { 'Content-Type' => 'application/json' } })
      end

      def activate_subscription(code)
        peform_action!(:put, "/subscriptions/#{code}/activate", { headers: { 'Content-Type' => 'application/json' } })
      end

      def list_invoices(subscription_code)
        peform_action!(:get, "/subscriptions/#{subscription_code}/invoices", { headers: { 'Content-Type' => 'application/json' } })
      end

      def details_invoice(id)
        peform_action!(:get, "/invoices/#{id}", { headers: { 'Content-Type' => 'application/json' } })
      end

      def list_payments(invoice_id)
        peform_action!(:get, "/invoices/#{invoice_id}/payments", { headers: { 'Content-Type' => 'application/json' } })
      end

      def details_payment(id)
        peform_action!(:get, "/payments/#{id}", { headers: { 'Content-Type' => 'application/json' } })
      end

      private

        def peform_action!(action_name, url, options = {})
          if (Moip::Assinaturas.token.blank? or Moip::Assinaturas.key.blank?)
            raise(MissingTokenError, "Informe o token e a key para realizar a autenticação no webservice")
          end

          response = self.send(action_name, url, options)
          raise(WebServerResponseError, "Ocorreu um erro ao chamar o webservice") if response.nil?
          response
        end

    end
  end

end