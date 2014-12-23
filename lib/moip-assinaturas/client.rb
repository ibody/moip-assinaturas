# coding: utf-8

require 'httparty'
require 'json'

module Moip::Assinaturas

  class WebServerResponseError < StandardError ; end
  class MissingTokenError < StandardError ; end

  class Client
    include HTTParty
    
    debug_output $stdout

    if Moip::Assinaturas.sandbox
      base_uri "https://sandbox.moip.com.br/assinaturas/v1"
    else
      base_uri "https://api.moip.com.br/assinaturas/v1"
    end

    basic_auth Moip::Assinaturas.token, Moip::Assinaturas.key

    class << self

      def create_plan(plan, opts={})
        prepare_options(opts, { body: plan.to_json, headers: { 'Content-Type' => 'application/json' } })
        peform_action!(:post, "/plans", opts)
      end

      def list_plans(opts={})
        prepare_options(opts, { headers: { 'Content-Type' => 'application/json' } })
        peform_action!(:get, "/plans", opts)
      end

      def details_plan(code, opts={})
        prepare_options(opts, { headers: { 'Content-Type' => 'application/json' } })
        peform_action!(:get, "/plans/#{code}", opts, true)
      end

      def update_plan(plan, opts={})
        prepare_options(opts, { body: plan.to_json, headers: { 'Content-Type' => 'application/json' } })
        peform_action!(:put, "/plans/#{plan[:code]}", opts, true)
      end

      def create_customer(customer, new_vault, opts={})
        prepare_options(opts, { body: customer.to_json, headers: { 'Content-Type' => 'application/json' } })
        peform_action!(:post, "/customers?new_vault=#{new_vault}", opts)
      end

      def list_customers(opts={})
        prepare_options(opts, { headers: { 'Content-Type' => 'application/json' } })
        peform_action!(:get, "/customers", opts)
      end

      def update_customer(code, changes, opts={})
        prepare_options(opts, { body: changes.to_json, headers: { 'Content-Type' => 'application/json' } })
        peform_action!(:put, "/customers/#{code}", opts, true)
      end

      def details_customer(code, opts={})
        prepare_options(opts, { headers: { 'Content-Type' => 'application/json' } })
        peform_action!(:get, "/customers/#{code}", opts, true)
      end

      def update_credit_card(customer_code, credit_card, opts={})
        prepare_options(opts, { body: credit_card.to_json, headers: { 'Content-Type' => 'application/json' } })
        peform_action!(:put, "/customers/#{customer_code}/billing_infos", opts)
      end

      def create_subscription(subscription, new_customer, opts={})
        prepare_options(opts, { body: subscription.to_json, headers: { 'Content-Type' => 'application/json' } })
        peform_action!(:post, "/subscriptions?new_customer=#{new_customer}", opts)
      end

      def update_subscription(subscription_code, subscription_changes, opts={})
        prepare_options(opts, { body: subscription_changes.to_json, headers: { 'Content-Type' => 'application/json' } })
        peform_action!(:put, "/subscriptions/#{subscription_code}", opts, true)
      end

      def list_subscriptions(opts={})
        prepare_options(opts, { headers: { 'Content-Type' => 'application/json' } })
        peform_action!(:get, "/subscriptions", opts)
      end

      def details_subscription(code, opts={})
        prepare_options(opts, { headers: { 'Content-Type' => 'application/json' } })
        peform_action!(:get, "/subscriptions/#{code}", opts, true)
      end

      def suspend_subscription(code, opts={})
        prepare_options(opts, { headers: { 'Content-Type' => 'application/json' } })
        peform_action!(:put, "/subscriptions/#{code}/suspend", opts, true)
      end

      def activate_subscription(code, opts={})
        prepare_options(opts, { headers: { 'Content-Type' => 'application/json' } })
        peform_action!(:put, "/subscriptions/#{code}/activate", opts, true)
      end

      def cancel_subscription(code, opts={})
        prepare_options(opts, { headers: { 'Content-Type' => 'application/json' } })
        peform_action!(:put, "/subscriptions/#{code}/cancel", opts, true)
      end

      def list_invoices(subscription_code, opts={})
        prepare_options(opts, { headers: { 'Content-Type' => 'application/json' } })
        peform_action!(:get, "/subscriptions/#{subscription_code}/invoices", opts)
      end

      def details_invoice(id, opts={})
        prepare_options(opts, { headers: { 'Content-Type' => 'application/json' } })
        peform_action!(:get, "/invoices/#{id}", opts, true)
      end

      def list_payments(invoice_id, opts={})
        prepare_options(opts, { headers: { 'Content-Type' => 'application/json' } })
        peform_action!(:get, "/invoices/#{invoice_id}/payments", opts)
      end

      def details_payment(id, opts={})
        prepare_options(opts, { headers: { 'Content-Type' => 'application/json' } })
        peform_action!(:get, "/payments/#{id}", opts)
      end

      private

        def prepare_options(custom_options, required_options)
          custom_options.merge!(required_options)

          if custom_options.include?(:moip_auth)
            custom_options[:basic_auth] = {
              username: custom_options[:moip_auth][:token],
              password: custom_options[:moip_auth][:key]
            }

            if custom_options[:moip_auth].include?(:sandbox)
              if custom_options[:moip_auth][:sandbox]
                custom_options[:base_uri] = "https://sandbox.moip.com.br/assinaturas/v1"
              else
                custom_options[:base_uri] = "https://api.moip.com.br/assinaturas/v1"
              end
            end

            custom_options.delete(:moip_auth)
          end

          custom_options
        end

        def peform_action!(action_name, url, options = {}, accepts_blank_body = false)
          if (Moip::Assinaturas.token.blank? or Moip::Assinaturas.key.blank?)
            raise(MissingTokenError, "Informe o token e a key para realizar a autenticação no webservice")
          end

          response = self.send(action_name, url, options)

          # when updating a plan the response body is empty and then
          # the response.nil? returns true despite that the response code was 200 OK
          # that is why I changed the response.nil? by the current
          if response.nil? && !accepts_blank_body
            raise(WebServerResponseError, "Ocorreu um erro ao chamar o webservice")
          end

          response
        end

    end
  end

end
