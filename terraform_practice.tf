#git configuration setting commands
 git config --global user.email "you@example.com"
  git config --global user.name "Your Name"
  
#it'll then prompt you to enter you Github username & a password which is your personal access token in Github
<enter your Github username>
<personal access token from Github>

#Use this command to push
git push --set-upstream origin “ENTER THE NAME OF YOUR BRANCH"

#Head back over to your Github, and now you show see a pull request!
click Compare & pull request > Review the changes> merge > make any necessary comments> delete branch> save changes!

#You can use this command to save your credentials so you don’t have to re-enter your token.
git config — global credential.helper store

