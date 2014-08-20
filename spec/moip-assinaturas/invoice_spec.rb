# coding: utf-8
require 'spec_helper'

describe Moip::Assinaturas::Invoice do

  before(:all) do

    FakeWeb.register_uri(
      :get,
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/subscriptions/assinatura1/invoices",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'list_invoices.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :get,
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/invoices/13",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'details_invoice.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :get,
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/invoices/not_found",
      body: '',
      status: [404, 'Not found']
    )

    FakeWeb.register_uri(
      :get,
      "https://TOKEN2:KEY2@api.moip.com.br/assinaturas/v1/subscriptions/assinatura2/invoices",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'custom_authentication', 'list_invoices.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :get,
      "https://TOKEN2:KEY2@api.moip.com.br/assinaturas/v1/invoices/14",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'custom_authentication', 'details_invoice.json'),
      status: [200, 'OK']
    )

  end

  it "should list all invoices from a subscription" do
    request = Moip::Assinaturas::Invoice.list('assinatura1')
    request[:success].should  be_true
  end

  describe 'invoice details' do
    it  "should get the invoice details" do
      request = Moip::Assinaturas::Invoice.details(13)
      request[:success].should       be_true
      request[:invoice][:id].should  == 13
    end

    it 'should return not found when invoice does not exist' do
      request = Moip::Assinaturas::Invoice.details('not_found')
      request[:success].should       be_false
      request[:message].should  == 'not found'
    end
  end

  context "Custom Authentication" do
    it "should list all invoices from a subscription from a custom moip account" do
      request = Moip::Assinaturas::Invoice.list('assinatura2', moip_auth: $custom_moip_auth)
      request[:success].should  be_true
    end

    it  "should get the invoice details from a custom moip account" do
      request = Moip::Assinaturas::Invoice.details(14, moip_auth: $custom_moip_auth)
      request[:success].should       be_true
      request[:invoice][:id].should  == 14
    end
  end

end
