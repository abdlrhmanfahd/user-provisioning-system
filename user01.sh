#!/bin/bash

CSV_FILE="/home/ubuntu/employee.csv"
OUTPUT_FILE="/home/ubuntu/out.txt"

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

if [ ! -f "$CSV_FILE" ]; then
    echo "CSV file not found: $CSV_FILE"
    exit 1
fi

while IFS=',' read -r username full_name; do
    if id "$username" &>/dev/null; then
        echo "User $username already exists. Skipping..."
        continue
    fi

    password=$(openssl rand -base64 12)

    useradd -m -c "$full_name" -s /bin/bash "$username"
    if [ $? -ne 0 ]; then
        echo "Failed to create user: $username"
        continue
    fi

    echo "$username:$password" | chpasswd
    chage -d 0 "$username"

    echo "User created: $username"
    echo "Password: $password"
    echo "$username,$password" >> "$OUTPUT_FILE"

done < "$CSV_FILE"
