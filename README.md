# Sistema de Frete
## Sistema de entregas desenvolvido durante o TreinaDev 8 da Campus Code.

A aplicação web é responsável por gerenciar meios de transporte disponíveis para e-commerces. O sistema é desenvolvido em Ruby on Rails utilizando testes com as gems [RSpec](https://github.com/rspec/rspec-rails) e [Capybara](https://github.com/teamcapybara/capybara). O banco dados é o SQLite.

### Versões
- Ruby 3.1.2
- Rails 7.0.3

# Dependências
- ***Devise***: A *gem* é uma solução flexível e segura para gerenciar a autenticação da aplicação, utilizada por ser bem mais prática, eficiente e segura do que desenvolver uma solução própria.


# Executando o projeto
1. Clone o projeto
  ```
  git clone https://github.com/fabiojrfla/shipping-system.git
  ```
2. Entre na pasta e instale as dependências
  ```
  bundle install
  ```
3. Execute as migrações
  ```
  rails db:migrate
  ```
4. Adicione dados ao banco
  ```
  rails db:seed
  #Os dados podem ser acessados no arquivo db/seeds.rb
  ```
5. Inicie o servidor web
  ```
  rails server
  ```

# Executando os testes
- Execute todos os testes
  ```
  rspec
  ```
- Ou execute testes de pastas ou arquivos específicos dentro da pasta ***spec***. Por exemplo:
  ```
  rspec spec/system
  ```

# Quadro de projeto
Disponível em:

[GitHub.com/FabioJrFla/Projects/Shipping-System](https://github.com/users/fabiojrfla/projects/1/views/1?layout=board)
