#!/bin/bash

echo "🚀 Setting up Matrioska OS Collaboration Infrastructure..."

# Create required documentation files
echo "📜 Creating CONTRIBUTING.md..."
cat <<EOF > CONTRIBUTING.md
# 🚀 Contributing to Matrioska OS

Matrioska OS is a revolution, and you can be a part of it.

## 🛠 Steps to Contribute
1️⃣ **Fork the repo** on GitHub  
2️⃣ **Clone it locally**  
3️⃣ **Create a branch** for your feature  
4️⃣ **Write amazing code**  
5️⃣ **Submit a Pull Request** 🚀  

## 💡 How We Work
- 📂 Follow the project structure
- 🏗 Use feature branches (`feature-xyz`)
- 📝 Follow coding standards

EOF
echo "✅ CONTRIBUTING.md created."

echo "📜 Creating SECURITY.md..."
cat <<EOF > SECURITY.md
# 🔒 Matrioska OS Security Policy

We take security **seriously**. If you find a vulnerability, **report it immediately**.

1. Open a **GitHub Issue** with the label `security`.
2. Contact the core team at **security@matrioska-os.dev**.
EOF
echo "✅ SECURITY.md created."

echo "📜 Creating CODE_OF_CONDUCT.md..."
cat <<EOF > CODE_OF_CONDUCT.md
# 🌍 Code of Conduct

1. Be respectful.  
2. Help beginners.  
3. No discrimination or hate speech.  
4. Innovate, collaborate, and build the future.  
EOF
echo "✅ CODE_OF_CONDUCT.md created."

# Initialize GitHub Project Board
echo "📊 Setting up GitHub Project Board..."
gh project create --title "Matrioska OS Development" --format json > project.json
echo "✅ Project Board initialized."

# Setting up CI/CD
echo "🛠 Setting up GitHub Actions for CI/CD..."
mkdir -p .github/workflows

cat <<EOF > .github/workflows/build.yml
name: Build & Test Matrioska OS

on:
  push:
    branches:
      - develop
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v2
      
      - name: Setup Environment
        run: |
          sudo apt update && sudo apt install build-essential
      
      - name: Run Tests
        run: |
          make test
EOF
echo "✅ GitHub Actions workflow added."

# Announce in terminal
echo "📢 Generating announcement..."
cat <<EOF > announcement.txt
🚀 Matrioska OS is now OPEN for collaboration!
Join us in building the **most advanced modular OS** ever.
Contribute, innovate, and shape the future.

🔗 GitHub: https://github.com/elmackico93/matrioska-os
📌 Tasks: Check GitHub Issues & Project Board
EOF
echo "📢 Announcement ready in announcement.txt."

# Commit changes
echo "📡 Committing changes..."
git add .
git commit -m "Setup collaboration framework & CI/CD pipeline 🚀"
git push origin develop
echo "✅ Collaboration setup completed! Push live changes with 'git push'."

# Display next steps
echo "✅ ✅ ✅ ALL SET! Here’s what to do next:"
echo "👉 Share the announcement.txt on Twitter, Reddit, Discord!"
echo "👉 Check GitHub Issues and Projects for your first task!"
