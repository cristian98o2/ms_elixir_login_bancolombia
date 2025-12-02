# ms_elixir_login_bancolombia
El ms_login_bancolombia es para la gestión de registro e ingreso de usuarios.

- SIGNUP


    curl --location 'http://localhost:8083/signup' \
    --header 'message-Id: 7c005eb4-a8ce-4ab9-8862-100af8d28c11' \
    --header 'x-request-id: 7c005eb4-a8ce-4ab9-8862-100af8d28c11' \
    --header 'Content-Type: application/json' \
    --data '{
    
        "data": {
            "email":"string",
            "password":"string",
            "name":"string"
        }
    
    }'

- SIGNIN


    curl --location 'http://localhost:8083/signin' \
    --header 'message-Id: 7c005eb4-a8ce-4ab9-8862-100af8d28c11' \
    --header 'x-request-id: 7c005eb4-a8ce-4ab9-8862-100af8d28c11' \
    --header 'Content-Type: application/json' \
    --data '{
    
        "data": {
            "email":"string",
            "password":"string"
        }
    
    }'