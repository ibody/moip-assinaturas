module Moip::Assinaturas
  class Webhooks
    attr_accessor :model, :event, :date, :env, :resource, :events 

    class << self
      def build(json) 
        object = new
        object.model    = get_model(json['event'])
        object.event    = get_event(json['event'])
        object.events   = {}
        object.date     = json['date']
        object.env      = json['env']
        object.resource = json['resource']

        object
      end

      def listen(params, &block)
        hook = build(params)
        yield hook
        hook.run
      end

      private
      def get_model(event)
        event.split(".")[0].to_sym
      end

      def get_event(event)
        event.split(".")[1].to_sym
      end
    end

    def on(model, on_events, &block)
      unless events[model]
        events[model] = {}
      end

      (on_events.is_a?(Array) ? on_events : [on_events]).each do |event|
        unless events[model][event]
          events[model][event] = []
        end

        events[model][event] = block
      end
    end

    def missing(&block)
      events[:missing] = block
    end

    def run
      return events[model][event].call(event) if (events[model] && events[model][event])
      events[:missing].call(model, event) if events[:missing]
    end
  end
end
