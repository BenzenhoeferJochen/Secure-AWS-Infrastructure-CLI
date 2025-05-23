# Secure-AWS-Infrastructure-CLI

**Secure-AWS-Infrastructure-CLI** is a command-line utility for provisioning a secure web server environment on AWS. This project uses Bash scripts to automate the creation of key infrastructure components such as VPCs, subnets, route tables, and AWS CLI authentication. 

The tool emphasizes best practices in security, modularity, and reusability—ideal for developers and DevOps engineers needing to quickly deploy secure, isolated AWS environments.

---

## 📚 Table of Contents

- [Project Structure](#project-structure)
- [Features](#features)
- [Requirements](#requirements)
- [Getting Started](#getting-started)
  - [Clone the Repository](#1-clone-the-repository)
  - [Authenticate with AWS](#2-authenticate-with-aws)
  - [Create the VPC](#3-create-the-vpc)
  - [Create the Subnets](#4-create-the-subnets)
  - [Configure Route Tables](#5-configure-route-tables)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)
- [Support](#support)

---

## 📁 Project Structure

```
Secure-AWS-Infrastructure-CLI/
│
├── src/
│   ├── login/
│   │   └── login.sh                # Authenticates with AWS using CLI credentials
│   │
│   ├── route_table/
│   │   └── create_route_table.sh   # Creates route tables and associations
│   │
│   ├── subnet/
│   │   ├── create_subnet.sh        # Provisions public and/or private subnets
│   │   └── main.sh                 # Orchestrates subnet creation logic
│   │
│   └── vpc/
│   |   ├── create_vpc.sh           # Creates a VPC with CIDR configuration
│   └── main.sh                     # VPC setup orchestration
│
├── .gitignore                      # Files and folders to exclude from Git
├── LICENSE                         # Project license
└── README.md                       # Project documentation
```

---

## 🚀 Features

- 🔐 **Secure VPC Setup** — Create custom VPCs with isolated environments
- 🌐 **Subnets & Route Tables** — Configure public/private subnets and routing logic
- 💻 **Web Server Ready** — Build foundational infrastructure for secure web hosting
- 🧩 **Modular Scripts** — Easily extensible, separated by AWS component
- 🛠️ **AWS CLI Integration** — Relies on `aws` CLI for provisioning and management

---

## 📦 Requirements

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) installed and configured (`aws configure`)
- Bash shell (Linux/macOS or Windows with WSL/Git Bash)
- IAM user or role with appropriate VPC, EC2, and networking permissions

---

## 🔧 Getting Started

### 1. Clone the Repository

```bash
git clone git@github.com:BenzenhoeferJochen/Secure-AWS-Infrastructure-CLI.git
cd Secure-AWS-Infrastructure-CLI
```

### 2. Start the main.sh

```bash
./src/main.sh
```

## 🌍 Roadmap

- [ ] Add EC2 instance deployment with security group configurations
- [ ] Implement Elastic Load Balancer (ELB) support
- [ ] Integrate CloudWatch for logging and monitoring
- [ ] Parameterize scripts using CLI options or config files
- [ ] Provide Terraform version for full IaC support

---

## 🤝 Contributing

Contributions are welcome!  
Please fork the repository, create a new branch, and open a pull request.  
Issues, improvements, and ideas are appreciated.

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## 💬 Support

For issues or questions, feel free to [open an issue](https://github.com/BenzenhoeferJochen/Secure-AWS-Infrastructure-CLI/issues) in the repository.

---
