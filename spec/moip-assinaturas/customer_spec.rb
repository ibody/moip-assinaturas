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
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/customers?new_vault=true",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'create_customer.json'),
      status: [201, 'CREATED']
    )

    FakeWeb.register_uri(
      :get,
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/customers",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'list_customers.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :get,
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/customers/18",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'details_customer.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :get,
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/customers/not_found",
      body:   '',
      status: [404, 'Not found']
    )

    FakeWeb.register_uri(
      :put,
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/customers/18/billing_infos",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'update_credit_card.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :put,
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/customers/18",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'update_customer.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :put,
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/customers/not_found",
      body: '',
      status: [404, 'Not found']
    )

    FakeWeb.register_uri(
      :post,
      "https://TOKEN2:KEY2@api.moip.com.br/assinaturas/v1/customers?new_vault=true",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'custom_authentication', 'create_customer.json'),
      status: [201, 'CREATED']
    )

    FakeWeb.register_uri(
      :get,
      "https://TOKEN2:KEY2@api.moip.com.br/assinaturas/v1/customers",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'custom_authentication', 'list_customers.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :get,
      "https://TOKEN2:KEY2@api.moip.com.br/assinaturas/v1/customers/18",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'custom_authentication', 'details_customer.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :put,
      "https://TOKEN2:KEY2@api.moip.com.br/assinaturas/v1/customers/19/billing_infos",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'custom_authentication', 'update_credit_card.json'),
      status: [200, 'OK']
    )
  end

  it "should create a new customer" do
    request = Moip::Assinaturas::Customer.create(@customer)
    request[:success].should be_truthy
  end

  it "should list all customers" do
    request = Moip::Assinaturas::Customer.list
    request[:success].should be_truthy
    request[:customers].size.should  == 1
  end

  describe 'update customer information' do
    it 'should update a customer information' do
      request = Moip::Assinaturas::Customer.update(@customer[:code], { fullname: 'Foo Bar' })
      request[:success].should be_truthy
    end

    it 'should return not found when updating a customer that does not exist' do
      request = Moip::Assinaturas::Customer.update('not_found', { fullname: 'Foo Bar' })
      request[:success].should be_falsey
      request[:message].should == 'not found'
    end
  end

  describe 'customer details' do
    it "should get the customer details" do
      request = Moip::Assinaturas::Customer.details('18')
      request[:success].should be_truthy
      request[:customer][:code].should     == '18'
    end

    it "should return not found when the customer does not exist" do
      request = Moip::Assinaturas::Customer.details('not_found')
      request[:success].should be_falsey
      request[:message].should ==          'not found'
    end
  end

  it "should update the customer card info" do
    request = Moip::Assinaturas::Customer.update_credit_card(18, {
      credit_card: {
        holder_name:      'Novo nome',
        number:           '5555666677778884',
        expiration_month: '04',
        expiration_year:  '15'
      }
    })

    request[:success].should be_truthy
  end

  context "Custom Authentication" do
    it "should create a new customer in other moip account" do
      request = Moip::Assinaturas::Customer.create(@customer, true, moip_auth: $custom_moip_auth)
      request[:success].should be_truthy
    end

    it "should list all customers from custom moip account" do
      request = Moip::Assinaturas::Customer.list(moip_auth: $custom_moip_auth)
      request[:success].should be_truthy
      request[:customers].size.should  == 1
    end

    it "should get the customer details of custom moip account" do
      request = Moip::Assinaturas::Customer.details('18', moip_auth: $custom_moip_auth)
      request[:success].should be_truthy
      request[:customer][:code].should     == '19'
    end

    it "should update the customer card info from custom moip account" do
      request = Moip::Assinaturas::Customer.update_credit_card(19, {
        credit_card: {
          holder_name:      'Novo nome 2',
          number:           '5555666677778884',
          expiration_month: '04',
          expiration_year:  '15'
        }
      }, moip_auth: $custom_moip_auth)

      request[:success].should be_truthy
    end
  end
end
