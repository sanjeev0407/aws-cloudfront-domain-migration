# Publish this project to GitHub

From the extracted project folder:

```powershell
git init
git add .
git status
git commit -m "Add AWS domain migration project"
git branch -M main
git remote add origin https://github.com/sanjeev0407/aws-domain-migration.git
git push -u origin main
```

If the repository already exists, verify the remote before pushing:

```powershell
git remote -v
```

Never commit `terraform.tfvars`, Terraform state, plan files, or credentials.
