# GitLab procedures

Role: Administration

1. Create user Step: Click the `Admin area`, then click `New User`, input all relevant information
> Successful: able to receive confirmation email and change the password

2. Create group (Group Scope) Step: Click the `Admin area`, then click `New Group`, input all relevant inforamtion
> Successful: able to customize the group setting

  2.1. Add users into the group
  Step: Click the `Groups` in the dashboard, and then `add users to group`
  > Successful: assigning a member with his role in the group, with a notification email.

  2.2. Add projects in the group
  Step: Click the `Projects` in the `Admin area`, click `New Project`, choose `Project Path`
  > Successful: creating a project in the group, all users in the same group will have the same projects.

  2.3. generate SSH key to enable pull or push in shell for a given project (for newly created project)
  Step:
    1.In the `user area` (Attention: not admin area), click `projects`, choose desired `Project`
    2.Click `Add an SSH Key` above in an orange block and then click `generate it`
    3.go to the bash of gitlab docker:
    ```sh
    docker exec -it [container-name or id] bash
    ```
    4.See whether SSH key exists.
    ```sh
    cat ~/.ssh/id_rsa.pub
    ```
    If you see a long string, copy-paste the key to the `My SSH Keys` section under the `SSH` tab in your user profile. Please copy the complete key starting with ssh-rsa and ending with your username and host. otherwise, generate the key:
    ```
    ssh-keygen -t rsa -C "admin@example.com"
    ```
    Please input your email here.
    Note: It is a best practice to use a password for an SSH key, but it is not required and you can skip creating a password by pressing enter. Note that the password you choose here can't be altered or retrieved.
    Then,
    ```sh
    cat ~/.ssh/id_rsa.pub
    ```
    and copy and paste it.
    > Successful: generating the SSH Key for administrator

  2.4 Command line instructions

  ```sh
  # Git global setup
  git config --global user.name "Administrator"
  git config --global user.email "admin@example.com"

  # Create a new repository
  git clone ssh://git@gitlab_url/my_awesome_group/my-awesome-project.git
  cd my-awesome-project
  touch README.md
  git add README.md
  git commit -m "add README"
  git push -u origin master

  # Existing folder or Git repository
  cd existing_folder
  git init
  git remote add origin ssh://git@gitlab_url:10022/my_awesome_group/my-awesome-project.git
  git add .
  git commit
  git push -u origin master
  ```
  > Successful: cloning the repository, pushing an empty readme, change the content of README, creating and pushing empty folder, adding files in the folder and pushing it, and creating a cpp file and pushing it.

  2.5 Create branch

  ```sh
  # Create a branch to update the content.
  # Before creating a new branch, pull the changes from upstream.
  # Your master needs to be up to date.

  # Create the branch on your local machine and switch in this branch :
  git checkout -b [name_of_your_new_branch]

  # Push the branch on github :
  git push origin [name_of_your_new_branch]

  # When you want to commit something in your branch, be sure to be in your branch.
  # You can see all branches created by using :
  git branch
  ```
  > Successful: creating a new branch and updating its content.

  2.6 Fork a Project
  Step: Choose the project and then click `Fork` to fork it.
  Note: `2.4, 2.5, 2.6` All can be implemented in the dashboard and the user panel.
  If you want to delete the project, it seems that only the administrator can do that.

  2.7 Merge request
  Step: click the merge request on the dashboard, and then the owner of the project will be notified about it, If the owner accept it, then merge will finish.

  2.8 Create and delete the Snippet

  2.9 Create and Close Issue
  Step: specify the project, (required), assign members (there will be a notification email.) (optional), Setting the due date (optional), comment the issue (there will be a notification email), close the issue (there will be notification email to assignee)
  > Successful: All activities can be seen inside the issue.(Click the issue on the dashboard)

  2.10 Create and Close Milestone
  Step: Click `Milestone` on the dashboard and choose a group or a project(required), input Title (required), set Due Day and attach a file(optional), create Issues under the Milestone, close the Milestone, delete the Milestone.

   2.11 All Your activities can be seen in `Activity` on the dashboard.

3. Create Project (Individual Scope) Note: Steps are all most the same as those under the group scope.
