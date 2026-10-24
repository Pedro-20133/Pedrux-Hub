import secrets

# Alfabeto padrão Base64
alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/!@#$%^&*()"

# Gera uma string aleatória de 50 caracteres
hash_base64 = "".join(secrets.choice(alphabet) for _ in range(51))

print(hash_base64)