# 🧑‍💻 User Provisioning System

A Bash-based tool to automate the process of adding multiple Linux users from a CSV file with randomly generated passwords and first-login password resets.

---

## 📌 Features

- Add new users in bulk from a CSV file
- Auto-generate secure passwords using OpenSSL
- Force password change on first login
- Prevent duplication: skips already existing users
- Log all credentials in a separate output file
- Collect user data via terminal with confirmation
- Clean, modular Bash scripts

---

## 🛠 How It Works

This system includes two scripts:

### `data.sh` – Collect user info

```bash
read -p "Enter your username: " user
read -p "Enter your full-name: " name
...
echo $user,$name >> employee.csv
```

It takes a `username` and `full-name`, confirms the input, then appends the result to `employee.csv`.

---

### `user01.sh` – Process CSV and create users

```bash
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

while IFS=',' read -r username full_name; do
  ...
  password=$(openssl rand -base64 12)
  useradd -m -c "$full_name" "$username"
  echo "$username:$password" | chpasswd
  chage -d 0 "$username"
  echo "$username,$password" >> "$OUTPUT_FILE"
done < "$CSV_FILE"
```

This script reads each line from `employee.csv`, checks if the user exists, and if not:

- Creates the user
- Assigns a random password
- Logs the password in `out.txt`
- Forces the user to reset it on first login

---

## 🧪 Demo Screenshots

> Here's a step-by-step visual walk-through of the scripts in action.

### 1. Add user data to CSV

![Add Users](screenshots/01-adding-users.png)

### 2. View the CSV file

![CSV View](screenshots/02-cat-employee-dot-csv.png)

### 3. Confirm the CSV contents via Vim

![Vim CSV](screenshots/03-vim-employee-dot-csv.png)

### 4. Take input and confirmation from the user

![User Input](screenshots/04-take-data-from-user-and-confirmation.png)

### 5. Handle random password generation and checking

![Handle Probabilities](screenshots/05-handel-all-answers-probabilities.png)

### 6. Declare variables in the main script

![Variables](screenshots/06-declaring-variables-at-user-script.png)

### 7. Check if script runs as root

![Root Check](screenshots/07-checking-if-user-is-root.png)

### 8. Verify if CSV file exists

![Check CSV](screenshots/08-checking-if-csv-file-exists.png)

### 9. Skip existing users

![User Exists](screenshots/09-check-if-user-already-exists.png)

### 10. Generate random passwords

![Generate Password](screenshots/10-assign-random-passwords.png)

### 11. Attach password and force change on login

![Attach Password](screenshots/11-attach-random-password-to-user-and-force-change-for-first-login.png)

### 12. Log the result in a file

![Output File](screenshots/12-output-txt-file-testing.png)

---

## 📂 Project Structure

```
user-provisioning-system/
│
├── data.sh                   # Script to collect user info
├── user01.sh                 # Script to create users
├── employee.csv              # (generated) List of users
├── out.txt                   # (generated) Log file of user-password pairs
├── README.md                 # This file
└── screenshots/              # Images for documentation
```

---

## 🚀 How to Use

```bash
# 1. Run the data collector
bash data.sh

# 2. Run the user creation script (as root)
sudo bash user01.sh
```

---

## 📜 License

This project is licensed under the [MIT License](LICENSE).

---

## Author

**Abdelrahman Fahd** – [GitHub](https://github.com/abdlrhmanfahd)
