# coding: utf-8
require 'spec_helper'

describe Moip::Assinaturas::Invoice do

  before(:all) do

    FakeWeb.register_uri(
      :get, 
      "https://TOKEN:KEY@wwww.moip.com.br/assinaturas/v1/subscriptions/assinatura1/invoices", 
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'list_invoices.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :get, 
      "https://TOKEN:KEY@wwww.moip.com.br/assinaturas/v1/invoices/13", 
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'details_invoice.json'),
      status: [200, 'OK']
    )

  end

  it "should list all invoices from a subscription" do
    request = Moip::Assinaturas::Invoice.list('assinatura1')
    request[:success].should  be_true
  end

  it  "should get the invoice details" do
    request = Moip::Assinaturas::Invoice.details(13)
    request[:success].should       be_true
    request[:invoice][:id].should  == 13
  end

end