# coding: utf-8
require 'spec_helper'

describe Moip::Assinaturas::Customer do
  
  before(:all) do
    @customer = {
      code:             "18",
      email:            "nome@exemplo.com.br",
      fullname:         "Nome Sobrenome",
      cpf:              "22222222222",
      phone_area_code:  "11",
      phone_number:     "34343434",
      birthdate_day:    "26",
      birthdate_month:  "04",
      birthdate_year:   "1980",
      address: {
        street:       "Rua Nome da Rua",
        number:       "100",
        complement:   "Casa",
        district:     "Nome do Bairro",
        city:         "São Paulo",
        state:        "SP",
        country:      "BRA",
        zipcode:      "05015010"
      },
      billing_info: {
        credit_card: {
          holder_name:        "Nome Completo",
          number:             "4111111111111111",
          expiration_month:   "04",
          expiration_year:    "15"
        }
      }
    }

    FakeWeb.register_uri(
      :post, 
      "https://TOKEN:KEY@wwww.moip.com.br/assinaturas/v1/customers?new_vault=true", 
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'create_customer.json'),
      status: [201, 'CREATED']
    )

    FakeWeb.register_uri(
      :get, 
      "https://TOKEN:KEY@wwww.moip.com.br/assinaturas/v1/customers", 
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'list_customers.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :get, 
      "https://TOKEN:KEY@wwww.moip.com.br/assinaturas/v1/customers/18", 
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'details_customer.json'),
      status: [200, 'OK']
    )
  end

  it "should create a new customer" do
    request = Moip::Assinaturas::Customer.create(@customer)
    request[:success].should be_true
  end

  it "should list all customers" do
    request = Moip::Assinaturas::Customer.list
    request[:success].should         be_true
    request[:customers].size.should  == 1
  end

  it "should get the customer details" do
    request = Moip::Assinaturas::Customer.details('18')
    request[:success].should             be_true
    request[:customer][:code].should     == '18'
  end

end