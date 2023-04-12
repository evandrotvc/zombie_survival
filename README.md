# ZSSN (Zombie Survival Social Network)

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
- Atualiza a localização do usuário
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
- Marca o usuário alvo como infectado
- params
```
{
	"name_target": "fulano2"
}
```
![alt text](https://github.com/evandrotvc/zombie_survival/blob/main/app/assets/images/infected.png)

- POST add_item => (users/user_id/add)
- adiciona o item no inventário
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
- deleta o item do inventário
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
- Realiza troca
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