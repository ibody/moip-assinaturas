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
  billing_cycles: 12
}

request = Moip::Assinaturas::Plan.create(@plan)

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

## Assinaturas

Criar uma nova Assinatura:

```ruby
Moip::Assinaturas::Subscription.create(subscription_attributes, new_customer = false)
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

## Cobranças

Listar cobranças de uma assinatura:

```ruby
Moip::Assinaturas::Invoice.list(subscription_code)
```

Obter detalhes da cobrança

```ruby
Moip::Assinaturas::Invoice.details(invoice_id)
```

## Pagamentos

Listar pagamentos de uma cobrança:

```ruby
Moip::Assinaturas::Payment.list(invoice_id)
```

Obter detalhes de um pagamento

```ruby
Moip::Assinaturas::Invoice.details(payment_id)
```

## Contribuindo

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Agradecimentos

Gem baseada no código da gem de pagamentos do **Guilherme Nascimento** - [https://github.com/guinascimento/moip-ruby](https://github.com/guinascimento/moip-ruby)
