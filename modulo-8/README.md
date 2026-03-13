# Projeto integrador

## Fazendo autenticação

```sh
read password
curl -X POST localhost:8080/login \
    -d '{"username": "dummy", "password": "'$password'"}' \
    -H "Content-Type: application/json" \
    | jq -r '.token' \
    | read -r token
```

## Fazendo uma requisição aleatória

```sh
curl -X GET localhost:8080/policies \
    -H "Authorization: Bearer ${token}" \
    -H "Content-Type: application/json"
```

## Criando uma policy

```sh
curl -X POST localhost:8080/policies \
    -H "Authorization: Bearer ${token}" \
    -H "Content-Type: application/json" \
    -d '{"username": "dummy", "verb": "getPolicies", "action": "ALLOW"}'
```

## Criando uma instância

```sh
curl -X POST localhost:8080/instance \
    -H "Authorization: Bearer ${token}" \
    -H "Content-Type: application/json" \
    -d '{
        "fqdn": "staging.alura.com", 
        "memory": 1024,
        "cpu": 2,
        "user_data": "echo 'provisioned!'"
    }'
```

## Pegando logs

```sh
curl -X GET localhost:8080/instance/d4efe240-19c4-4067-bdf6-b198a15894ba/logs \
    -H "Authorization: Bearer ${token}" \
    -H "Content-Type: application/json"
```