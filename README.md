# Moip Assinaturas

Essa gem permite utilizar a API do Moip Assinaturas.

O Moip Assinaturas permite que você faça cobranças de forma automática, no valor e intervalo que escolher por meio da criação de planos.

[http://site.moip.com.br/assinaturas/](http://site.moip.com.br/assinaturas)

## Instalação

Adicione a Gem no Gemfile da sua aplicação:

    gem 'moip-assinaturas'

Então execute:

    $ bundle

Ou instale você mesmo:

    $ gem install moip-assinaturas

## Configuração

Use o generator para gerar o arquivo de inicialização do Rails

    $ rails g moip_assinaturas:install

Configure a sua conta

```ruby
Moip::Assinaturas.config do |config|
  config.sandbox = false
  config.token   = "SEU TOKEN"
  config.key     = "SUA KEY"
end
```

## Usando

Exemplo da criação de um novo plano usando a API do Moip

```ruby
plan = {
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
  billing_cycles: 12,
  trial: {
    enabled: true,
    days: 10
  }
}

request = Moip::Assinaturas::Plan.create(plan)

if request[:success]
  # O plano foi criado com sucesso
else
  # Houve um erro ao gravar o plano, dê uma olhada em request[:errors]
end
```

O uso é bem simples, basta seguir a API para obter os atributos específicos de cada método.
[http://moiplabs.github.io/assinaturas-docs/api.html](http://moiplabs.github.io/assinaturas-docs/api.html)

## Planos

Criar um novo plano:

```ruby
Moip::Assinaturas::Plan.create(plan_attributes)
```

Listar todos planos:

```ruby
Moip::Assinaturas::Plan.list
```

Obter detalhes do plano:

```ruby
Moip::Assinaturas::Plan.details(plan_code)
```

Atualizar informações do plano:

```ruby
Moip::Assinaturas::Plan.update(plan_attributes)
```

## Clientes

Criar um novo cliente:

```ruby
Moip::Assinaturas::Customer.create(customer_attributes, new_valt = true)
```

Listar todos clientes:

```ruby
Moip::Assinaturas::Customer.list
```

Obter detalhes do cliente:

```ruby
Moip::Assinaturas::Customer.details(customer_code)
```

Atualizar cliente existente:

```ruby
Moip::Assinaturas::Customer.update(customer_code, { fullname: 'Foo Bar' })
```
## Assinaturas

Criar uma nova assinatura:

```ruby
Moip::Assinaturas::Subscription.create(subscription_attributes, new_customer = false)
```

Atualizar uma assinatura:

```ruby
Moip::Assinaturas::Subscription.update(subscription_code, { plan: { code: 'plan2' } })
```

Listar todas assinaturas:

```ruby
Moip::Assinaturas::Subscription.list
```

Obter detalhes da assinatura:

```ruby
Moip::Assinaturas::Subscription.details(subscription_code)
```

Suspender uma assinatura:

```ruby
Moip::Assinaturas::Subscription.suspend(subscription_code)
```

Ativar uma assinatura:

```ruby
Moip::Assinaturas::Subscription.activate(subscription_code)
```

Cancelar uma assinatura:

```ruby
Moip::Assinaturas::Subscription.cancel(subscription_code)
```

## Faturas

Listar faturas de uma assinatura:

```ruby
Moip::Assinaturas::Invoice.list(subscription_code)
```

Obter detalhes da fatura:

```ruby
Moip::Assinaturas::Invoice.details(invoice_id)
```

## Pagamentos

Listar pagamentos de uma cobrança:

```ruby
Moip::Assinaturas::Payment.list(invoice_id)
```

Obter detalhes de um pagamento:

```ruby
Moip::Assinaturas::Invoice.details(payment_id)
```

## Webhooks

A classe Webhooks foi desenvolvida para cobrir qualquer caso de envio do Moip. Um exemplo de como ela é utilizada.

```ruby
# como eu costumo usar o rails então
class WebhooksController < ApplicationController
  def webhooks
    resultado = Moip::Assinaturas::Webhooks.listen(request) do |hook|

      # quando o moip envia dado sobre a criação de um plano
      hook.on(:plan, :created) do
        # Fazer algo
      end

      hook.on(:payment, :status_updated) do
        # quando o pagamento do meu cliente está confirmado
        if hook.resource['status']['code'] == 4
          # Fazer algo
        end
      end

      # trata vários eventos de um model no mesmo hook
      hook.on(:subscription, [:canceled, :suspended]) do |status|
        deleta_assinatura(motivo: status)
      end

      hook.on(:subscription, :created) do
        # Fazer algo
      end

      # hook para capturar eventos que ainda não são explicitamente tratados
      hook.missing do |model, event| do
        Rails.logger.warn "Não encontrado hook para o modelo #{model} e evento #{event}"
        false
      end
    end

    render :text => "done ok" and return if resultado
    render nothing: true, status: :bad_request
  end
end
```
A ideia da arquitetura da classe Webhooks foi baseada na gem - [https://github.com/xdougx/api-moip-assinaturas](https://github.com/xdougx/api-moip-assinaturas) - substituindo os objetos daquela gem por hashs

## Múltiplas Contas Moip

Caso seja preciso utilizar assinaturas com mais de uma conta Moip, basta passar as chaves de acesso na chamada dos métodos demonstrados acima, por exemplo:

Criar um novo plano:

```ruby
Moip::Assinaturas::Plan.create(plan_attributes, moip_auth: { token: 'TOKEN', key: 'KEY', sandbox: false })
```

Listar todos planos:

```ruby
Moip::Assinaturas::Plan.list(moip_auth: { token: 'TOKEN', key: 'KEY', sandbox: false })
```

Obter detalhes do plano:

```ruby
Moip::Assinaturas::Plan.details(plan_code, moip_auth: { token: 'TOKEN', key: 'KEY', sandbox: false })
```

Atualizar informações do plano:

```ruby
Moip::Assinaturas::Plan.update(plan_attributes, moip_auth: { token: 'TOKEN', key: 'KEY', sandbox: false })
```

## Contribuindo

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Agradecimentos

Gem baseada no código da gem de pagamentos do **Guilherme Nascimento** - [https://github.com/guinascimento/moip-ruby](https://github.com/guinascimento/moip-ruby)
