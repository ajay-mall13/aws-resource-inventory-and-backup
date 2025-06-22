
# 🛠️ AWS Resource Snapshot Automation

This project automates the process of **listing all resources** in an AWS account, saving the output to a **JSON file**, and **uploading it to an S3 bucket daily** using a shell script and cron.

---

## 📌 Features

- Lists key AWS resources: EC2, S3, RDS, Lambda, IAM, etc.
- Saves output to a timestamped `.json` file
- Uploads the file to a specified S3 bucket for backup purposes
- Scheduled via `cron` for daily execution
  

---

## 🧰 Requirements

- Linux/Unix machine
- AWS CLI installed and configured
- IAM user with permissions for:
  - `Describe*`, `List*` on all AWS services
  - `PutObject` on your S3 bucket


---

## 🚀 Setup Instructions

### 1. Clone or Copy the Script

```bash
git clone https://github.com/yourusername/aws-resource-snapshot.git
cd aws-resource-snapshot
```

### 2. Configure Script

Edit the `aws_snapshot.sh` file:

```bash
S3_BUCKET="your-s3-bucket-name"
REGION="your-region"
```


### 🔷 3. Configure AWS CLI

Run the following command:

```bash
aws configure
```

You will be prompted to enter:

```
AWS Access Key ID [None]: YOUR_ACCESS_KEY
AWS Secret Access Key [None]: YOUR_SECRET_KEY
Default region name [None]: us-east-1
Default output format [None]: json
```

---

### 🔷 4. Verify Configuration

```bash
cat ~/.aws/credentials
cat ~/.aws/config
```


### 3. Make the Script Executable

```bash
chmod 764 aws_snapshot.sh
```

### 4. Run Manually (for testing)

```bash
 Usage: ./aws_resource_list.sh  <aws_region> <aws_service>
 Example: ./aws_resource_list.sh us-east-1 ec2
```

---

## 🕒 Automate with Cron (Daily at 6 AM)
![Screenshot 2025-06-22 093317](https://github.com/user-attachments/assets/e1270d87-bbcd-4422-882b-322d039ae845)

Edit crontab:

```bash
crontab -e
```

Add the line:

```bash
0 6 * * * /path/to/aws_snapshot.sh
```

---

## 📂 Output

- JSON files stored in `./aws_logs/`
- Filenames like: `aws_snapshot_2025-06-21_06-00-00.json`
- Uploaded to your specified S3 bucket automatically

---



---

## 🔒 Security Notes

- Do **not** hardcode AWS credentials
- Use IAM roles or environment variables for sensitive data
- Make sure S3 bucket has proper write permissions

---

## 🧑‍💻 Author

**Ajay Mall**  
_Shell Scripting | AWS | DevOps Enthusiast_

---

## 📘 License

This project is licensed under the MIT License.
