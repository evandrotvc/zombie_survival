# ZSSN (Zombie Survival Social Network)

## Descrição do Problema

O mundo finalmente atingiu o seu estado apocalíptico, onde uma pandemia causada por um virus de laboratório transforma seres humanos e animais em zumbis, seres sedentos por carne.

Você, como membro da resistência (e último sobrevivente com conhecimentos em desenvolvimento de software) foi incubido à desenvolver um sistema para compartilhamento de recursos entre os humanos não infectados.

## Funcionalidades

O sistema consiste em uma ***API REST***, que irá armazenar informações sobre os sobreviventes, bem como os recursos que cada um detem.

Para isso, o sistema deverá contar com as seguintes funcionalidades:

- **Cadastrar usuários na base**:

  Um usuário é definido basicamente por seu *nome*, *idade*, *sexo* e *última localização (latitude, longitude)*.

  Ao ser criado, um usuário irá conter um inventário de itens que o mesmo detem (inicialmente vazio).

  Os itens aceitos são: **água**, **comida**, **medicamento** e **munição**.

- **Atualizar localização de usuário**:

  Um usuário deve ser capaz de atualizar sua última localização, informando a nova latitude/longitude.

- **Marcar usuário como infectado**:

  Em uma situação caótica como essa, é inevitável que um usuário do sistema venha a ser contaminado.

  Nesse caso, o mesmo deve ser atualizado no sistema como infectado.

  Um usuário infectado não pode realizar escambo, não pode manipular seu inventário nem ser listado nos relatórios (para fins práticos, o mesmo está inativo).

  **Um usuário é considerado infectado quando ao menos 3 outros usuários distintos do sistema reportaram sua contaminação**.

  Ao ser infectado, todos os itens do inventário do usuário ficam **inacessíveis**.

- **Adicionar/Remover itens do inventário de um usuário**:

  Um usuário poderá adicionar/remover itens de seu inventário.

  Os possíveis itens estão descritos na primeira opção acima;

- **Escambo de bens**:

  Usuários do sistema podem trocar bens entre si.

  Para isso, a tabela de equivalência abaixo será utilizada.
  
  Todos os escambos devem conter saldo final zero, ou seja, os dois usuários devem negociar a mesma quantidade de pontos.

  Não é necessário realizar o registro do escambo, apenas transferir os itens entre os dois usuários.

| Item      | Pontos   |
|-----------|----------|
| 1 Água    | 4 pontos |
| 1 Comida  | 3 pontos |
| 1 Remédio | 2 pontos |
| 1 Munição | 1 ponto  |

- **Relatórios**:

  Para fins de consulta, os seguintes relatórios devem estar disponíveis no sistema:
    1. Porcentagem de usuários infectados;
    2. Porcentagem de usuários não-infectados;
    3. Quantidade média de cada tipo de item por usuário (águas/usuário, comidas/usuário, etc);
    4. Número de pontos perdidos por usuários infectados;

## Orientações técnicas:

1. Utilize a linguagem e framework de sua preferência;
2. Utilize um banco de dados relacional (PostgreSql, MySql, etc);
3. Sistema REST, respondendo aos verbos HTTP (POST, GET, UPDATE, etc). A definição das rotas e verbos utilizados fica a seu critério, entretanto procure manter os *standards* e *best practices*;
4. Toda a comunicação é feita via JSON;
5. Não é necessário autenticação (afinal, quem vai perder tempo hackeando o sistema com um bando de zumbis na cola?! :P );
6. Como o número de sobreviventes é baixo, o tráfego no sistema não será alto;

## Dicas:

1. **Documente** todo o seu sistema, desde como fazer o *setup* e rodar os testes, até as rotas criadas, exemplos de chamadas à *API* e as decisões arquiteturais;
2. **Testes, testes e testes!** Num apocalipse zumbi, ninguém tem tempo a perder fazendo testes manuais, então automatize ao máximo sua suite;
3. **Utilize Git**, com commits pequenos e bem descritos (nada de um commit único com todo o código);





_____________________________________________________________



## Instalando projeto

É necessário ter Docker e docker-compose. A aplicação roda o banco e o server tudo em docker.

Para instalar o projeto, siga estas etapas:

Setando o .env
```
copie o arquivo .env.test com o nome .env
```
depois rode
```
docker compose build
```

depois rode
```
docker compose up
```

Se tudo foi instalado com sucesso, estará rodando os containers postgres(port: 5432) e o server(port: 3000).
Agora é possível realizar os testes se todos os containers executaram corretamente

## Tests

No terminal, caso queira rodar os testes, basta entrar no container e rodar o comando a seguir.
```
docker exec -it survivor bash
```
e depois:
```
rspec
```



## Examples
- POST create
![alt text](https://github.com/evandrotvc/zombie_survival/blob/main/app/assets/images/create.png)

- GET index
![alt text](https://github.com/evandrotvc/zombie_survival/blob/main/app/assets/images/index_users.png)

- PUT location => (users/user_id/location)
- params
```
{
	"location": {
		"latitude": 10.0,
		"longitude": 20.0
	}
}
```
![alt text](https://github.com/evandrotvc/zombie_survival/blob/main/app/assets/images/location.png)

- POST infected => (users/user_id/infected)
- params
```
{
	"name_target": "fulano2"
}
```
![alt text](https://github.com/evandrotvc/zombie_survival/blob/main/app/assets/images/infected.png)

- POST add_item => (users/user_id/add)
- params
```
{
	"item": {
		"kind": "ammunition",
		"quantity": 1
	}
}
```
![alt text](https://github.com/evandrotvc/zombie_survival/blob/main/app/assets/images/add_item.png)


- DELETE remove_item => (users/user_id/remove)
- params
```
{
	"item": {
		"kind": "ammunition"
	}
}
```
![alt text](https://github.com/evandrotvc/zombie_survival/blob/main/app/assets/images/remove_item.png)

- POST trade => (users/user_id/trade)
- params
```
{
	"user_to": {
		"name": "fulano2",
		"items": [
			{ 
				"kind": "water",
				"quantity": 1 
			}
		]
	},
	
	"user": {
		"items": [
			{ 
				"kind": "ammunition",
				"quantity": 1 
			},
			
			{ 
				"kind": "food",
				"quantity": 1 
			}
		]
	}
}
```
![alt text](https://github.com/evandrotvc/zombie_survival/blob/main/app/assets/images/trade.png)

- Exception example(users cannot to use inventory)
![alt text](https://github.com/evandrotvc/zombie_survival/blob/main/app/assets/images/exception.png)