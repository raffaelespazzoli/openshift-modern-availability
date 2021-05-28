CREATE USER '{{name}}' WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';
GRANT ALL ON DATABASE keycloak${version_no_dots} TO "{{name}}";