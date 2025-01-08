**## Instructions for Working with an Organization Repository and Forks in GitHub**

### **1. Creating a Branch, Adding, Committing, and Pushing to an Organization Repository**
#### **Step 1: Check the branch you are on**
```bash
git branch
```
#### **Step 2: Create a New Branch**
```bash
git checkout -b <name_of_branch>
```
Replace `name_of_branch` with a descriptive branch name, such as `fix-bug` or `add-feature`.


#### **Step 3: Make Changes and Commit**
Check the status of modified files:
```bash
git status
```

Stage all changes:
```bash
git add .
```

Commit the changes with a meaningful message:
```bash
git commit -m "Description of changes"
```

#### **Step 4: Push the New Branch to the Organization Repository**
```bash
git push origin feature-branch
```

#### **Step 5: Create a Pull Request (PR)**
1. Go to the **GitHub organization repository** (`https://github.com/org-name/repo-name`).
2. You will see a prompt **"Compare & pull request"** → Click it.
3. Select the **base branch** (e.g., `main` or `develop`) and your **feature branch**.
4. Add a description of the changes and submit the PR.
5. Once approved, the changes will be merged into the organization's repository.

---



### **2. Updating a Forked Repository with Changes from the Organization Repository**



#### **Step 1: Fetch the Latest Changes from the Organization Repository**
```bash
git fetch upstream
```

#### **Step 2: Merge the Latest Changes into Your Local Branch**
```bash
git checkout main  # Switch to the main branch
```
```bash
git merge upstream/main
```
If there are merge conflicts, manually resolve them before proceeding.

#### **Step 3: Push the Updated Changes to Your Forked Repository**
```
git push origin main
```

