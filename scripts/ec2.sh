# Clone repo into 'backend' directory
git clone https://github.com/ENG4000-SOSO/New-SOSO-Server.git backend

cd backend

# Start the database Docker container
docker compose up database -d

# Execute database schema creation script
docker \
    exec -i soso-db sh -c \
    'PGPASSWORD="$POSTGRES_PASSWORD" psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"' \
    < ./app/db/SOSO.sql

# Execute database population script
docker \
    exec -i soso-db sh -c \
    'PGPASSWORD="$POSTGRES_PASSWORD" psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"' \
    < ./app/db/populate.sql

# Set environment variables for AWS

export AWS_ACCESS_KEY_ID= # AWS access key ID here

export AWS_SECRET_ACCESS_KEY= # AWS secret access key

export AWS_DEFAULT_REGION= # AWS region name (ex. us-east-1)

export AWS_REGION_NAME=$AWS_DEFAULT_REGION

export S3_BUCKET_NAME= # S3 bucket name for SOSO storage

export DYNAMODB_TABLE_NAME= # DynamoDb table name for SOSO scheduling metadata

# Start the backend server Docker container
docker compose up backend -d
