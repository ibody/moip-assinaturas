# coding: utf-8
require 'spec_helper'
require 'json'

describe Moip::Assinaturas::Webhooks do

  let!(:params) do
    {
      'event' => 'model.event',
      'date' => '28/12/2012 15:38:46',
      'env' => 'generic_env',
      'resource' => {
        'test' => 'test generic resource'
      }
    }
  end

  describe '.listen(params, &block)' do
    let!(:block) { lambda { |hook| } }
    let!(:hook) { Moip::Assinaturas::Webhooks.build(params) }

    before(:each) do
      Moip::Assinaturas::Webhooks.stub(:build) { hook }
    end

    it 'should call build' do
      Moip::Assinaturas::Webhooks.should_receive(:build).with(params)
      Moip::Assinaturas::Webhooks.listen(params, &block)
    end

    it 'should yield block' do
      Moip::Assinaturas::Webhooks.should_receive(:listen).and_yield(block)
      Moip::Assinaturas::Webhooks.listen(params, &block)
    end

    it 'should call run' do
      hook.should_receive(:run).once
      Moip::Assinaturas::Webhooks.listen(params, &block)
    end
  end

  describe '.build(params)' do
    subject(:hook) { Moip::Assinaturas::Webhooks.build(params) }

    its(:model) { should eq(:model) }
    its(:event) { should eq(:event) }
    its(:events) { should eq({}) }

    its(:date) { should eq('28/12/2012 15:38:46') }

    its(:env) { should eq('generic_env') }
    its(:resource) { should eq({ 'test' => 'test generic resource' }) }
  end

  describe '#on(model, on_events, &block)' do
    let!(:model) { 'model' }
    let!(:event_1) { 'event_1' }
    let!(:event_2) { 'event_2' }
    let!(:block) { lambda { } }

    subject(:hook) { Moip::Assinaturas::Webhooks.build(params) }

    it "should adding this block to events" do
      hook.on(model, event_1, &block)
      hook.events[model][event_1].should eq(block)
    end

    it "should receive an array of events and add this block to events" do
      hook.on(model, [event_1, event_2], &block)
      hook.events[model][event_1].should eq(block)
      hook.events[model][event_2].should eq(block)
    end
  end

  describe '#missing(&block)' do
    let!(:model) { 'model' }
    let!(:missing) { 'missing_event' }
    let!(:block) { lambda { 'missing_event' } }

    subject(:hook) { Moip::Assinaturas::Webhooks.build(params) }

    it "should adding this block to events" do
      hook.missing(&block)
      hook.events[:missing].should eq(block)
    end
  end

  describe '#run' do
    let!(:model) { :model }
    let!(:event) { :event }
    let!(:block) { lambda { } }
    let!(:params2) do
      params2 = params.clone
      params2['event'] = 'model.event2'
      params2
    end

    subject(:hook) { Moip::Assinaturas::Webhooks.build(params) }

    it 'should call block once' do
      hook.on(model, event, &block)

      block.should_receive(:call).once.with(:event)

      hook.run
    end

    it 'should call twice when hook accepted 2 events' do
      hook2 = Moip::Assinaturas::Webhooks.build(params2)

      hook.on(model, [event, :event2], &block)
      hook2.on(model, [event, :event2], &block)

      block.should_receive(:call).with(:event)
      block.should_receive(:call).with(:event2)

      hook.run
      hook2.run
    end

    it "should return the hook's return" do
      hook.on(model, event) { |event| "#{event}_called" }

      expect(hook.run).to eql("event_called")
    end

    describe 'missing hook' do
      it 'should run the missing event if no model is found' do
        params['event'] = 'not exist.event'
        hook = Moip::Assinaturas::Webhooks.build(params)
        hook.missing { |model, event| "#{model}_#{event}" }

        expect(hook.run).to eql("not exist_event")
      end

      it 'should run the missing event if no event is found' do
        params['event'] = 'model.not exist'
        hook = Moip::Assinaturas::Webhooks.build(params)
        hook.missing { |model, event| "#{model}_#{event}" }

        expect(hook.run).to eql("model_not exist")
      end
    end
  end
end
