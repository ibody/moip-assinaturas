# coding: utf-8
require 'spec_helper'

describe Moip::Assinaturas::Plan do

  before(:all) do
    @plan = {
      code: "plano01",
      name: "Plano Especial",
      description: "Descrição do Plano Especial",
      amount: 990,
      setup_fee: 500,
      max_qty: 1,
      interval: {
        length: 1,
        unit: "MONTH"
      },
      billing_cycles: 12
    }

    FakeWeb.register_uri(
      :post, 
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/plans", 
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'create_plan.json'),
      status: [201, 'OK']
    )

    FakeWeb.register_uri(
      :get, 
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/plans", 
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'list_plans.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :get, 
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/plans/plano01", 
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'details_plan.json'),
      status: [200, 'OK']
    )
  end

  it "should can create a new plan" do
    request = Moip::Assinaturas::Plan.create(@plan)
    request[:success].should      be_true
    request[:plan][:code].should  == 'plano01'
  end

  it "should list all plans" do
    request = Moip::Assinaturas::Plan.list
    request[:success].should    be_true
    request[:plans].size.should == 1
  end

  it "should get details from a plan" do
    request = Moip::Assinaturas::Plan.details('plano01')
    request[:success].should      be_true
    request[:plan][:code].should  == 'plano01'
  end

end
